img_btn <- function(id, img) {
  tags$button(
    id = id,
    type = "button",
    class = "btn action-button img-btn",
    img(src = img, width = "300px")
  )
}

## main_tab ----
main_tab <- tabItem(
  tabName = "main_tab",
  box(id = "Q1", title = "What is your favourite flower?", width = 12,
      collapsible = T, collapsed = F,
      flowLayout(
        img_btn("Q1_r", "img/poppy-2447327_640.jpg"),
        img_btn("Q1_o", "img/flowers-3215188_640.jpg"),
        img_btn("Q1_y", "img/sunflower-1627193_640.jpg"),
        img_btn("Q1_g", "img/flower-2071522_640.jpg"),
        img_btn("Q1_b", "img/hydrangea-3673120_640.jpg"),
        img_btn("Q1_p", "img/lavenders-1537694_640.jpg")
      )
  ),
  box(id = "Q2", title = "What is your favourite landscape?", width = 12,
      collapsible = T, collapsed = T,
      flowLayout(
        img_btn("Q2_r", "img/tree-736885_640.jpg"),
        img_btn("Q2_o", "img/road-1072821_640.jpg"),
        img_btn("Q2_y", "img/mountains-615428_640.jpg"),
        img_btn("Q2_g", "img/forest-931706_640.jpg"),
        img_btn("Q2_b", "img/lake-1581879_640.jpg"),
        img_btn("Q2_p", "img/bled-2608425_640.jpg")
      )
  ),
  box(id = "Q3", title = "What is your favourite animal?", width = 12,
      collapsible = T, collapsed = T,
      flowLayout(
        img_btn("Q3_r", "img/cardinal-2872966_640.jpg"),
        img_btn("Q3_o", "img/fox-715588_640.jpg"),
        img_btn("Q3_y", "img/lemon-doktorfisch-793384_640.jpg"),
        img_btn("Q3_g", "img/reptile-2042906_640.jpg"),
        img_btn("Q3_b", "img/butterfly-142506_640.jpg"),
        img_btn("Q3_p", "img/bright-4642061_640.jpg")
      )
  ),
  box(id = "Q4", title = "What is your favourite colour?", width = 12,
      collapsible = T, collapsed = T,
      selectInput("fav_colour", NULL,
                  c("", "Red" = "r",
                    "Orange" = "o",
                    "Yellow" = "y",
                    "Green" = "g",
                    "Blue" = "b",
                    "Purple" = "p"))
  ),
  actionButton("view_feedback", "Submit Quiz")
)
