rm(list = ls())
library(tidyverse)
library(rvest)
# devtools::install_github('charlie86/spotifyr', force = T)
library(spotifyr)

Sys.setenv(SPOTIFY_CLIENT_ID = '4c1f28cf38b74679aabcb1e24abacea3')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '61c63628400d4381800ff675e81a45be')

access_token <- get_spotify_access_token()

auth <- get_spotify_authorization_code()


#victor l. user <- "1255408767" 

user <- "eivicent"

playlists <- list()
for(ii in 1:10){
  tryCatch(playlists[[ii]] <- get_user_playlists(user, limit = 50, offset = 50*(ii-1)) %>%
    select(id, name, tracks.total), error = function(e) break)
}
playlists <- bind_rows(playlists) %>% arrange(tracks.total)


playlist.selected <- filter(playlists, name == "SPGym_Latin_Selection") %>% select(id)

songs <- get_playlist(playlist.selected, fields = "tracks.items(track(name, id, artists)),")

songs.info <- songs$tracks$items
songs.info$artist <- sapply(lapply(songs$tracks$items$track.artists, function(x) x$name), function(x) x[1])

songs.info <- songs.info %>% select(name = track.name, id = track.id, artist)

features <- get_track_audio_features(songs.info$id) %>%
  mutate(duration = duration_ms/(60*1000)) %>%
  select(-c(uri:analysis_url), -duration_ms, -type, -time_signature)


total_info <- songs.info %>% left_join(features, by = "id")

### VALENCE IS FOR POSITIVENESS
### ENERGY IS FOR INTENSITY
### DANCEABILITY IS FOR DANCING
### TEMPO IS BEATS PER MINUTE
### KEY/MODE

classify_track_sentiment <- function(valence, energy) {
  if (is.na(valence) | is.na(energy)) {
    return(NA)
  }
  else if (valence >= .5) {
    if (energy >= .5) {
      return('Happy/Joyful')
    } else {
      return('Chill/Peaceful')
    }
  } else {
    if (energy >= .5) {
      return('Turbulent/Angry')
    } else {
      return('Sad/Depressing')
    }
  }
}

classify_duration <- function(duration){
  output <- case_when(
    between(duration, 0,2.5) ~ "Short",
    between(duration, 2.5,4) ~ "Normal",
    between(duration, 4,5.5) ~ "Long",
    between(duration, 5,Inf) ~ "Eternal")
  return(output)
}

classify_tempo_swing <- function(tempo){
  output <- case_when(
    between(tempo, 0,120) ~ "SuperSlow",
    between(tempo, 120,140) ~ "Slow",
    between(tempo, 140,160) ~ "Normal",
    between(tempo, 160,190) ~ "Fast",
    between(tempo, 190,Inf) ~ "SuperFast")
  return(output)
}


final_info <- total_info %>% 
  rowwise %>%
  mutate(sentiment = classify_track_sentiment(valence,energy)) %>%
  mutate(duration_group = classify_duration(duration)) %>%
  mutate(tempo_swing = classify_tempo_swing(tempo)) %>%
  ungroup



ggplot(total_info, aes(x = duration, y = tempo)) +
  geom_point(aes(colour = name))
