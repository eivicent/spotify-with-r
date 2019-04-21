#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source("./ui/playlist_summary.R")
# Define server logic required to draw a histogram
shinyServer(function(input,output) {
  
  
  output$pl_summary_nsongs <- renderInfoBox({
    infoBox("Number of Songs",
      nrow(songs_total))
    })

  output$pl_summary_totduration <- renderInfoBox({
    infoBox("Number of Songs",
      sum(songs_total$duration_ms/(1000*60)))
    })

  output$pl_summary_avgpopularity <- renderInfoBox({
    infoBox("Number of Songs",
      mean(songs_total$track_popularity,na.rm = T))
    })
   
  # observeEvent(input$users_list, {
  #   # test <- get_playlist_tracks(playlists %>% filter(playlist_name == input$users_list))
  #   # output <- get_track_audio_features(test)
  #   test <- songs
  #   output <- songs_features
  #   processed <- output %>% 
  #     inner_join(test, by = "track_uri") %>% 
  #     mutate(duration = duration_ms/(1000*60),
  #            duration_grups = cut(duration,  breaks = c(0,3,5,7,Inf), labels = c("Short", "Normal", "Long", "Super Long")),
  #            tempo_grups = cut(tempo, breaks = c(0,70,90,100,120,Inf), labels = c("Super Slow","Slow", "Normal", "Fast", "Super Fast")),
  #            instrumental_grups = cut(instrumentalness, breaks = c(-Inf,0.2,0.5,0.75,Inf), labels = c("Vocal", "Vocal+Instru", "Instrumentalish", "Instrumental")),
  #            energy_grups = cut(energy, breaks = c(0,0.6,1), labels = c("EA", "EB")),
  #            valence_grups = cut(valence, breaks = c(0,0.4, 0.6, 1), labels = c("VA", "VB", "VC")),
  #            dance_grups = cut(danceability, breaks = c(-Inf,0.4, 0.6,0.8,Inf), labels = c("DA","DB","DC","DD"))) %>%
  #     select(-track_uri, -key_mode, -time_signature, -key, -loudness, -acousticness, -speechiness, -liveness)
  #   return(processed)
  # })
  
  # observeEvent(input$users_list,{
    # speed2duration <- count(processed, duration_grups, tempo_grups) %>% spread(tempo_grups, n)
  # })

})


# upsi <- processed %>% count(mode)
# 
# vocal <- count(processed, instrumental_grups)
# processed %>% count(energy_grups, valence_grups) %>% spread(valence_grups, n)
# processed %>% count(dance_grups) %>% spread(dance_grups, n)
