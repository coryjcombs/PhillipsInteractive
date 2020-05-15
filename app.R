#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#

library(shiny)

# Define UI
ui <- fluidPage(

  #shinythemes::themeSelector(),

  titlePanel("Title Panel"),

  sidebarLayout(position="left",

    sidebarPanel(
      #h3("Sidebar Panel", align=''),
      p("Sidebar help text here."),
      #div(img(src="pc_scenarios.png", width=175), align='center'),
      selectInput("var",
                  label="Choose a variable to test",
                  choices=list("Beta 1",
                                 "Beta 2",
                                 "Beta 3"),
                  selected="Beta 1"),
      sliderInput("yearRange", label="Range of years to test",
                  min=1949, max=2017, value=c(1949, 2017),
                  sep="")
      ),

    mainPanel(
      h4("Main Panel", align=''),
      p("Sidebar text here."),

      textOutput("selectedVar"),

      textOutput("yearDiff")
      )
  )

)

# Define server logic
server <- function(input, output) {

  output$selectedVar <- renderText({
    paste0("You are testing ", input$var,
          " for the period ", input$yearRange[1],
          " to ", input$yearRange[2], ".")
  })

  output$yearDiff <- renderText({
    paste0("The period is ",
           input$yearRange[2] - input$yearRange[1],
           " years long.")
  })

}

# Run the application
shinyApp(ui = ui, server = server)
