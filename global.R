library(shiny)
library(shinydashboard)
library(httr)
library(shiny)
library(shinyjs)
library(shinyBS)
library(tidyverse)
library(shinymaterial)
library(tibble)
library(highcharter)
library(RColorBrewer)
library(shinycssloaders)
library(htmltools)
library(lubridate)
library(lazyeval)
library(spotifyr)
library(shinydashboardPlus)
library(formattable)


source('helpers.R')


Sys.setenv(SPOTIFY_CLIENT_ID = '4c1f28cf38b74679aabcb1e24abacea3')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '61c63628400d4381800ff675e81a45be')

playlists <- list()
for(ii in 1:100){
  playlists[[ii]] <- get_user_playlists("eivicent", limit = 50, offset = 50*(ii-1))
  if(is.null(nrow(playlists[[ii]]))){break}
}
list_of_playlists <- bind_rows(playlists)
