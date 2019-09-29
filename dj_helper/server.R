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
  # artist_audio_features <- eventReactive(input$tracks_go, {
  #   df <- get_artist_audio_features(selected_artist()$name, authorization = spotify_access_token()) %>% 
  #     mutate(album_img = map_chr(1:nrow(.), function(row) {
  #       .$album_images[[row]]$url[1]
  #     }))
  #   if (nrow(df) == 0) {
  #     stop("Sorry, couldn't find any tracks for that artist's albums on Spotify.")
  #   }
  #   return(df)
  # })
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
  # observeEvent(input$tracks_go, {
  #   output$artist_plot <- renderUI({
  #     if (input$GetScreenWidth >= 800) {
  #       withSpinner(highchartOutput('artist_quadrant_chart', width = '820px', height = '800px'), type = 5, color = '#1ed760')
  #     } else {
  #       withSpinner(highchartOutput('artist_quadrant_chart'), type = 5, color = '#1ed760')
  #     }
  #   })
  # })
  
})