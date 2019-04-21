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
# library(shinydashboardPlus)
# library(formattable)

source("./ui/playlist_summary.R")

# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(title = "DJ Helper 0.1"),
  dashboardSidebar(
    selectInput(inputId = "all_users_list_names", label = "Select your spotify List", 
                choices = unique(playlists), multiple = F, selected = "Salsa"),
    sidebarMenu(
      menuItem("Playlist Summary",
               tabName = "pl_summary",
               selected = TRUE,
               newtab = TRUE)
  )),
  dashboardBody(
    tabItems(
      ui_playlist_summary
    )
  )
)
