library(shiny)
library(shinydashboard)
library(tidyverse)

# function for calculating visual angle
get_va <- function(size, distance, approx=F){
  if (approx) {
    rad <- atan(size/distance)
  } else {
    rad <- 2*atan(size/(2*distance))
  }
  rad*(180/pi)  # radians to angle
}
# function for converting to consistent units (mm)
to_mm <- function(val, units){
  recode(
    units,
    "mm"=as.double(val),
    "cm"=as.double(val)*10,
    "inches"=as.double(val)*25.4
  )
}


ui <- dashboardPage(
  
  skin = "green",
  
  dashboardHeader(title = "My VA Calculator"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Stimulus Features", tabName="stim-features", icon=icon("cube")),
      menuItem("Results", tabName="results", icon=icon("calculator"))
    )
  ),
  
  dashboardBody()
  
)

server <- function(input, output) {
  
  
  
}

shinyApp(ui = ui, server = server)
