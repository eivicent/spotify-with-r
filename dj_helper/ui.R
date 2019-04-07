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
library(shinydashboardPlus)
library(formattable)

# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(title = "DJ Helper"),
  dashboardSidebar(
    selectInput(inputId = "users_list", label = "Select your spotify List", 
                choices = unique(playlists$playlist_name), multiple = F)
  ),
  dashboardBody(
    fluidPage(
      fluidRow(
               infoBox(title = "Number of Songs", value = nrow(processed)),
               infoBox(title = "Distribution", value = speed2duration)
               )
      )
    )
  )
