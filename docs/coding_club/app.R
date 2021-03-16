## libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinyjs)
    library(shinydashboard)
    library(ggplot2)
    library(dplyr)
    library(tidyr)
    library(readr)
})

## functions ----

# source("R/func.R") # put long functions in external files

# set up blank file for saving data if it doesn't exist
if (!file.exists("data.csv")) write_csv(data.frame(), "data.csv")

# display debugging messages in R if local,
# or in the console log if remote
debug_msg <- function(...) {
    is_local <- Sys.getenv('SHINY_PORT') == ""
    txt <- paste(...)
    if (is_local) {
        message(txt)
    } else {
        shinyjs::logjs(txt)
    }
}

## tabs ----

# you can put complex tabs in separate files and source them
source("ui/main_tab.R")
source("ui/fb_tab.R")
source("ui/info_tab.R")

# if the header and/or sidebar get too complex,
# put them in external files and uncomment below
# source("ui/header.R") # defines the `header`
# source("ui/sidebar.R") # defines the `sidebar`


## UI ----
ui <- dashboardPage(
    skin = "black",
    # header, # if sourced above
    # sidebar, # if sourced above
    dashboardHeader(title = "Quiz"),
    dashboardSidebar(
        # https://fontawesome.com/icons?d=gallery&m=free
        sidebarMenu(
            id = "tabs",
            menuItem("Quiz", tabName = "main_tab",
                     icon = icon("home")),
            menuItem("Feedback", tabName = "fb_tab",
                     icon = icon("bar-chart")),
            menuItem("Info", tabName = "info_tab",
                     icon = icon("info"))
        )
    ),
    dashboardBody(
        shinyjs::useShinyjs(),
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"), # links to www/custom.css
            tags$script(src = "custom.js") # links to www/custom.js
        ),
        tabItems(
            main_tab,
            info_tab,
            fb_tab
        )
    )
)


## server ----
server <- function(input, output, session) {
    # constants ----
    c_levels <- c("r", "o", "y", "g", "b", "p")
    c_names <- c("Red", "Orange", "Yellow", "Green", "Blue", "Purple")
    c_colour <- c("firebrick", "darkorange3", "goldenrod", "darkgreen", "dodgerblue3", "mediumpurple4")
    q_levels <- c("Flower", "Landscape", "Animal", "Favourite")

    # variables ----
    v <- reactiveValues(
        answers = rep(NA, 3), # for 3 image button questions
        alldata = readr::read_csv("data.csv", col_names = F)
    )

    # initial visibility ----
    hide("save_data")

    # Image button function ----
    Q <- function(Q = 1, add = "r") {
        # set selected outline
        ids <- paste0("Q", Q, "_", c_levels)
        sapply(ids, removeClass, class = "selected")
        addClass(paste0("Q", Q, "_", add), "selected")

        # record answer
        v$answers[Q] <- add
        debug_msg(v$answers)

        # go to next Q
        runjs(sprintf("closeBox('Q%s');", Q))
        runjs(sprintf("openBox('Q%s');", Q+1))
    }

    # Q1 ----
    observeEvent(input$Q1_r, { Q(1, "r") })
    observeEvent(input$Q1_o, { Q(1, "o") })
    observeEvent(input$Q1_y, { Q(1, "y") })
    observeEvent(input$Q1_g, { Q(1, "g") })
    observeEvent(input$Q1_b, { Q(1, "b") })
    observeEvent(input$Q1_p, { Q(1, "p") })

    # Q2 ----
    observeEvent(input$Q2_r, { Q(2, "r") })
    observeEvent(input$Q2_o, { Q(2, "o") })
    observeEvent(input$Q2_y, { Q(2, "y") })
    observeEvent(input$Q2_g, { Q(2, "g") })
    observeEvent(input$Q2_b, { Q(2, "b") })
    observeEvent(input$Q2_p, { Q(2, "p") })

    # Q3 ----
    observeEvent(input$Q3_r, { Q(3, "r") })
    observeEvent(input$Q3_o, { Q(3, "o") })
    observeEvent(input$Q3_y, { Q(3, "y") })
    observeEvent(input$Q3_g, { Q(3, "g") })
    observeEvent(input$Q3_b, { Q(3, "b") })
    observeEvent(input$Q3_p, { Q(3, "p") })

    # finish quiz ----
    observeEvent(input$view_feedback, {
        runjs("closeBox('Q4');")
        show("save_data")
        updateTabItems(session, "tabs", selected = "fb_tab")
    })

    # make individual feedback plot ----
    output$my_plot <- renderPlot({
        debug_msg("my_plot")

        # make data frame for this person
        data <- tibble(
            !!q_levels[1] := v$answers[[1]],
            !!q_levels[2] := v$answers[[2]],
            !!q_levels[3] := v$answers[[3]],
            !!q_levels[4] := input$fav_colour
        )

        # show their plot
        data %>%
            gather(category, colour, 1:ncol(.)) %>%
            # make things display in the right order
            mutate(colour = factor(colour, levels = c_levels)) %>%
            ggplot(aes(x = colour, fill = colour)) +
            geom_bar(show.legend = F, ) +
            scale_fill_manual(values = c_colour, drop=FALSE) +
            scale_x_discrete(labels = c_names, name = "", drop=FALSE)
    })

    # make group feedback plot ----
    output$others_plot <- renderPlot({
        debug_msg("others_plot")

        if (nrow(v$alldata) == 0) return()

        names(v$alldata) <- q_levels

        v$alldata %>%
            gather(category, colour, 1:ncol(.)) %>%
            mutate(colour = factor(colour, levels = c_levels),
                   category = factor(category, levels = q_levels)) %>%
            ggplot(aes(x = colour, fill = colour)) +
            geom_bar(show.legend = F, ) +
            facet_wrap(~category) +
            scale_fill_manual(values = c_colour, drop=FALSE) +
            scale_x_discrete(labels = c_names, name = "", drop=FALSE)
    })

    # save data ----
    observeEvent(input$save_data, {
        debug_msg("save", input$save_data)

        if (input$save_data > 1) {
            runjs("alert('You can only add your data once');")
            return()
        }

        data <- data.frame(
            flower = v$answers[1],
            landscape = v$answers[2],
            animal = v$answers[3],
            favourite = input$fav_colour
        )

        readr::write_csv(data, "data.csv", append = TRUE)

        v$alldata <- readr::read_csv("data.csv", col_names = F)
    }, ignoreInit = TRUE)
}

shinyApp(ui, server)
