#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#

library(shiny)

# Define UI
ui <- fluidPage(

  shinythemes::themeSelector(),

  titlePanel("Title Here"),

  sidebarLayout(position="right",
    sidebarPanel("Sidebar Panel"),
    mainPanel("Main Panel")
  )

)

# Define server logic
server <- function(input, output) {



}

# Run the application
shinyApp(ui = ui, server = server)
