### VALENCE IS FOR POSITIVENESS
### ENERGY IS FOR INTENSITY
### DANCEABILITY IS FOR DANCING
### TEMPO IS BEATS PER MINUTE
### KEY/MODE









withBusyIndicatorUI <- function(button) {
  id <- button[['attribs']][['id']]
  div(
    `data-for-btn` = id,
    button,
    span(
      class = 'btn-loading-container',
      hidden(
        img(src = 'ajax-loader-bar.gif', class = 'btn-loading-indicator'),
        icon('check', class = 'btn-done-indicator')
      )
    ),
    hidden(
      div(class = 'btn-err',
          div(icon('exclamation-circle'),
              tags$b('Error: '),
              span(class = 'btn-err-msg')
          )
      )
    )
  )
}



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

classify_duration <- function(duration){
  output <- case_when(
    between(duration, 0,2.5) ~ "Short",
    between(duration, 2.5,4) ~ "Normal",
    between(duration, 4,5.5) ~ "Long",
    between(duration, 5,Inf) ~ "Eternal")
  return(output)
}

classify_tempo_swing <- function(tempo){
  output <- case_when(
    between(tempo, 0,120) ~ "SuperSlow",
    between(tempo, 120,140) ~ "Slow",
    between(tempo, 140,160) ~ "Normal",
    between(tempo, 160,190) ~ "Fast",
    between(tempo, 190,Inf) ~ "SuperFast")
  return(output)
}