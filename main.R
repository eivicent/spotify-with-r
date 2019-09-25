rm(list = ls())
library(tidyverse)
library(rvest)
# devtools::install_github('charlie86/spotifyr', force = T)
library(spotifyr)

Sys.setenv(SPOTIFY_CLIENT_ID = '4c1f28cf38b74679aabcb1e24abacea3')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '61c63628400d4381800ff675e81a45be')

access_token <- get_spotify_access_token()

auth <- get_spotify_authorization_code()

user <- "eivicent"


playlists <- list()
for(ii in 1:10){
  tryCatch(playlists[[ii]] <- get_user_playlists(user, limit = 50, offset = 50*(ii-1)) %>%
    select(id, name, tracks.total), error = function(e) break)
}
playlists <- bind_rows(playlists) %>% arrange(tracks.total)


playlist.selected <- filter(playlists, name == "SPGym_Latin_Selection") %>% select(id)

songs <- get_playlist(playlist.selected, fields = "tracks.items") 
%>%
  bind_rows()

get_track_audio_features(songs$track.id[1])


songs_features <- get_track_audio_features(songs$tracks$items$track.id)
songs_popularity <- get_track_popularity(songs)

songs_total <- songs %>% inner_join(
  inner_join(songs_features, songs_popularity))
