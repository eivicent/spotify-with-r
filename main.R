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


playlist.selected <- filter(playlists, name == "Jazzy Mix") %>% select(id)

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



aux <- total_info %>% 
  rowwise %>%
  mutate(sentiment = classify_track_sentiment(valence,energy)) %>%
  ungroup





