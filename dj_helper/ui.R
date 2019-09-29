#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

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



playlists <- list()
for(ii in 1:100){
  playlists[[ii]] <- get_user_playlists("eivicent", limit = 50, offset = 50*(ii-1))
  if(is.null(nrow(playlists[[ii]]))){break}
}
list_of_playlists <- bind_rows(playlists)

# Define UI for application that draws a histogram
function(request) {
  material_page(
    # title = HTML('<span>Sentify</span> <span style="font-size:12px"><a href="http://www.rcharlie.com" target="_blank">by RCharlie</a></span>'),
                nav_bar_color = 'black',
                font_color = 'white',
                background_color = '#828282',
                tags$head(
                  # tags$link(rel = 'icon', type = 'image/png', href = 'green_music_note.png'),
                          tags$title('DJ-Helper')),
                # useShinyjs(),
                # tags$script(jscode),
                # tags$style(appCSS),
                # tags$head(tags$link(rel = 'stylesheet', type = 'text/css', href = 'style.css'),
                          # tags$head(includeScript('www/ga.js')),
                          # tags$head(includeScript('www/hotjar.js'))),
                material_row(
                  material_column(
                    width = 3,
                    material_card(
                      title = '',
                      depth = 4,
                      material_dropdown('select_playlist', 'Select one of your playlists',
                        choice = list_of_playlists$name, selected = '',
                        color = '#1ed760')),
                      
                      ## SHOW INFO
                       uiOutput('selected_playlist_info')
                    )
                  ),
                  material_column(
                    width = 9
                    # ,uiOutput('artist_plot')
                  )
                )
}
