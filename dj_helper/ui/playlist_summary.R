ui_playlist_summary <- 
tabItem(tabName = "pl_summary",
  	fluidPage(
  		fluidRow(),
		fluidRow(
			infoBoxOutput("pl_summary_nsongs"),
            infoBoxOutput("pl_summary_totduration"),
            infoBoxOutput("pl_summary_avgpopularity")
        ),
        fluidRow(
        	#plotOutput(output$plot_duration_distribution),
        	#plotOutput(output$plot_tempo_distribution),
        	#plotOutput(output$plot_danceability_distribution),
        	#plotOutput(output$plot_mood_danceability)
            )
	)
)