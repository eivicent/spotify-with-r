rm(list = ls())
library(tidyverse)
library(rvest)
# devtools::install_github('charlie86/spotifyr', force = T)
library(spotifyr)

Sys.setenv(SPOTIFY_CLIENT_ID = '4c1f28cf38b74679aabcb1e24abacea3')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '61c63628400d4381800ff675e81a45be')

access_token <- get_spotify_access_token()

auth <- get_spotify_authorization_code()



get_user_profile("eivicent") %>%View

playlists <- get_user_playlists("eivicent")

list <- filter(playlists, name == "Nick Waterhouse")

songs <- get_playlist(list$id)

get_track_audio_features(songs$track.id[1])


songs_features <- get_track_audio_features(songs$tracks$items$track.id)
songs_popularity <- get_track_popularity(songs)

songs_total <- songs %>% inner_join(
  inner_join(songs_features, songs_popularity))
