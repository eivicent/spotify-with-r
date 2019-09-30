shinyServer(function(input, output, session) {
  
  spotify_access_token <- reactive({
    get_spotify_access_token()
  })
  

    output$selected_playlist_info <- renderUI({
      tagList(
        textOutput('playlist_num_tracks'),
        htmlOutput('playlist_img'),
        br()
      )
    })
   
    selected_playlist <- reactive({
      list_of_playlists %>% 
        filter(name == input$select_playlist)
    })
    
    
    observeEvent(input$select_playlist, {
      playlist_img <- ifelse(!is.na(selected_playlist()$images[[1]]$url[1]), 
                           selected_playlist()$images[[1]]$url[1], 
                           'https://pbs.twimg.com/profile_images/509949472139669504/IQSh7By1_400x400.jpeg')
      
      output$playlist_img <- renderText({
        HTML(str_glue('<img src={playlist_img} height="200">'))
      })
      
      output$playlist_num_tracks <- renderText({
        selected_playlist()$tracks.total
      })
      
    })
  # 
    
  playlist_audio_features <- eventReactive(input$select_playlist, {
    # 74IYLj2nChgN9S7Es6LWqJ
    songs <- get_playlist(selected_playlist()$id, fields = "tracks.items(track(name, id, artists)),")
    songs.info <- songs$tracks$items
    songs.info$artist <- sapply(lapply(songs$tracks$items$track.artists, function(x) x$name), function(x) x[1])
    
    features <- get_track_audio_features(songs.info$track.id) %>%
      mutate(duration = duration_ms/(60*1000)) %>%
      select(-c(uri:analysis_url), -duration_ms, -type, -time_signature)
    
    
    total_info <-  songs.info %>% left_join(features, by = c("track.id" = "id"))
    
    df <-  total_info %>% 
      rowwise %>%
      mutate(sentiment = classify_track_sentiment(valence,energy)) %>%
      mutate(duration_group = classify_duration(duration)) %>%
      mutate(tempo_swing = classify_tempo_swing(tempo)) %>%
      ungroup
    return(df)
  })
  # 
  # output$artist_quadrant_chart <- renderHighchart({
  #   artist_quadrant_chart(artist_audio_features()) %>% 
  #     hc_add_event_point(event = 'mouseOver')
  # })
  # 
  # output$artist_chart_song_ui <- renderUI({
  #   
  #   req(input$artist_quadrant_chart_mouseOver, input$artist_autoplay == TRUE)
  #   
  #   artist_track_hover <- input$artist_quadrant_chart_mouseOver
  #   track_preview_url <- artist_audio_features() %>% filter(
  #     album_name == artist_track_hover$series,
  #     valence == artist_track_hover$x,
  #     energy == artist_track_hover$y
  #   ) %>% pull(track_preview_url)
  #   
  #   if (!is.na(track_preview_url)) {
  #     tagList(
  #       tags$audio(id = 'song_preview', src = track_preview_url, type = 'audio/mp3', autoplay = NA, controls = NA),
  #       tags$script(JS("myAudio=document.getElementById('song_preview'); myAudio.play();"))
  #     )
  #   } else {
  #     h5('No preview for this track on Spotify')
  #   }
  # })
  # 
  observeEvent(input$select_playlist, {
    output$playlist_plot <- renderPlot({
      aux <- playlist_audio_features()
      ggplot(aux, aes(x = duration, y = tempo)) +
        geom_point(aes(colour = track.name))
      
    })
  })
  
})