library(shiny)
library(shinydashboard)

ui <- dashboardPage(

  skin = "blue",

  dashboardHeader(title = "My Example App"),

  dashboardSidebar(),

  dashboardBody(
    lapply(1:12, function(i){
      box(
        status = "primary",
        solidHeader = T,
        width = 6,
        title = paste("Box Number", i, sep=" "),
        paste("Box ", i, "'s content will go here...", sep=""),
        br(), br(),
        paste("Here's a random number just for kicks:", round(runif(1, 1, 99999)))
      )
    })
  )

)

server <- function(input, output) {


}

shinyApp(ui = ui, server = server)
