# Info Section


library(shiny)
source("helpers/pc.analysis.R")
source("helpers/PhillipsCurveAnalysis.R")

# Define UI
ui <- fluidPage(

  shinythemes::themeSelector(),

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
      p("Select three test values for beta, or b, where infl_e = infl + b(U-U_n):"),
      numericInput("b1",
                   "label" = "Beta 1",
                   value = 0.75,
                   step = 0.125,
                   width = "25%"),
      numericInput("b2",
                   "label" = "Beta 2",
                   value = 1.25,
                   step = 0.125,
                   width = "25%"),
      numericInput("b3",
                   "label" = "Beta 3",
                   value = 2.25,
                   step = 0.125,
                   width = "25%"),
      sliderInput("yearRange", label="Range of years to test",
                  min=1949, max=2017, value=c(1949, 2017),
                  sep=""),
      br(),
      textOutput("selectedVar"),
      textOutput("yearDiff")
      ),

    mainPanel(
      h4("Main Panel", align=''),
      p("Sidebar text here."),
      plotOutput("plot"),
      htmlOutput("table", container = div)
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
    paste0("The tested period is ",
           input$yearRange[2] - input$yearRange[1],
           " years long.")
  })

  output$plot <- renderPlot({

    plot.infl.exp.nrou(data = pc_nrou,
                       b1 = input$b1, b2 = input$b2, b3 = input$b3,
                       period_start = input$yearRange[1], period_end = input$yearRange[2],
                       method = "lm")

  })

  output$table <- renderPrint({

    stargazer(pc_model_nonlinear_50s, pc_model_nonlinear_60s, pc_model_nonlinear_70s,
              pc_model_nonlinear_80s, pc_model_nonlinear_90s, pc_model_nonlinear_00s,
              pc_model_nonlinear_10s, pc_model_nonlinear_full,
              type = reg_doctype,
              title = "Nonlinear Phillips Curve Regressions by Decade, 1950-2017",
              out = paste0(reg_dir,"pc_nonlinear_reg_table.htm"),
              dep.var.labels = c("Inflation Rate"),
              covariate.labels = c("U3 Unemployment Rate", "Square of U3", "Constant"))

  })

}

# Run the application
shinyApp(ui = ui, server = server)
