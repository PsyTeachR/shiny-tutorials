## fb_tab ----
fb_tab <- tabItem(
  tabName = "fb_tab",
  h2("Feedback"),
  p("All colours are great. This is the distribution of your favourites."),
  plotOutput("my_plot"),
  p("And this is what other people think."),
  actionButton("save_data", "Add My Data"),
  plotOutput("others_plot")
)
