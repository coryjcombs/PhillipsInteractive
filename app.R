#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#

library(shiny)

# Define UI
ui <- fluidPage(

  #shinythemes::themeSelector(),

  titlePanel("Title Panel"),

  sidebarLayout(position="right",
    sidebarPanel(
      h4("Sidebar Panel", align=''),
      p("Sidebar text here."),
      div(img(src="pc_scenarios.png", width=175), align='center')
      ),
    mainPanel(
      h4("Main Panel", align=''),
      p("Sidebar text here.")
      )
  )

)

# Define server logic
server <- function(input, output) {



}

# Run the application
shinyApp(ui = ui, server = server)
