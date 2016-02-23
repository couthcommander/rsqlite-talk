library(shiny)

shinyUI(fluidPage(
  titlePanel("Data from SQLite"),
  sidebarLayout(
    sidebarPanel(
      fileInput('fids', 'IDs to include', accept='text/plain'),
      checkboxGroupInput('vars', 'Variables to include:', paste0('x', seq(10)), selected=paste0('x', seq(5)))
    ),
    mainPanel(
      textOutput("filename"),
      tableOutput("distPlot"),
      tableOutput("cnt")
    )
  )
))
