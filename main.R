rm(list = ls())
library(tidyverse)
# devtools::install_github('charlie86/spotifyr')
library(spotifyr)

Sys.setenv(SPOTIFY_CLIENT_ID = '7fe779b7476a47b4a807e87dedb2b7b7')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'dd0ff5a47a154010a9ee9db776ba57d8')

access_token <- get_spotify_access_token()


playlists <- get_user_playlists("eivicent")






