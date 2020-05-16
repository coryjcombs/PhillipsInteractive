# Info Section

#### Packages ####

library(shiny)
source("helpers/pc.datahelper.R")
source("helpers/pc.visualizationhelper.R")

# Define UI
ui <- fluidPage(

  #shinythemes::themeSelector(),

  titlePanel(h2("Empirical Analysis of the Phillips Curve Model")),


  sidebarLayout(position="left",

    sidebarPanel(
      #h3("Sidebar Panel", align=''),
      p("The Phillips Curve model posits that unemployment and inflation have an inverse relationship. High inflation is correlated with low unemployment, and vice versa."),
      p("Empirical analysis, however, suggests that this relationship has rarely held in the post-WWII United States."),
      p("This application allows users to explore the data for themselves to test for the correlation the Phillips Curve model posits."),
      br(),
      #div(img(src="pc_scenarios.png", width=175), align='center'),
      p("Select three test values for beta, or b, where infl_e = infl + b(U-U_n):"),
      numericInput("b1",
                   "label" = "Beta 1",
                   value = 0.75,
                   step = 0.125,
                   width = "85px"),
      numericInput("b2",
                   "label" = "Beta 2",
                   value = 1.25,
                   step = 0.125,
                   width = "85px"),
      numericInput("b3",
                   "label" = "Beta 3",
                   value = 2.25,
                   step = 0.125,
                   width = "85px"),
      sliderInput("yearRange", label="Range of years to test",
                  min=1949, max=2017, value=c(1949, 2017),
                  sep=""),
      br(),
      textOutput("selectionText")
      ),

    mainPanel(
      h4("Main Panel", align=''),
      p("Sidebar text here."),
      plotOutput("scenariosPlot"),
      htmlOutput("linregTable", container = div),
      htmlOutput("nonlinregTable", container = div),
      plotOutput("inflPlot"),
      plotOutput("u3Plot"),
      plotOutput("u6Plot"),
      plotOutput("u3u6Plot"),
      plotOutput("influ3Plot"),
      plotOutput("nrouPlot")
      )
  )

)

# Define server logic
server <- function(input, output) {

  output$selectionText <- renderText({
    paste0("You are testing the ",
           input$yearRange[2] - input$yearRange[1],
           "-year period from ",
           input$yearRange[1],
           " to ",
           input$yearRange[2], ".")
  })

  output$scenariosPlot <- renderPlot({
    plot.infl.exp.nrou(data = pc_nrou,
                       b1 = input$b1, b2 = input$b2, b3 = input$b3,
                       period_start = input$yearRange[1], period_end = input$yearRange[2],
                       method = "lm")
  })

  output$linregTable <- renderPrint({
    stargazer(pc_model_linear_50s, pc_model_linear_60s, pc_model_linear_70s,
              pc_model_linear_80s, pc_model_linear_90s, pc_model_linear_00s,
              pc_model_linear_10s, pc_model_linear_full,
              type = reg_doctype,
              title = "Linear Phillips Curve Regressions by Decade, 1950-2017",
              out = paste0(reg_dir,"pc_linear_reg_table.htm"),
              flip = TRUE,
              dep.var.labels = c("Inflation Rate"),
              covariate.labels = c("U3 Unemployment Rate", "Constant"))
  })

  output$nonlinregTable <- renderPrint({
    stargazer(pc_model_nonlinear_50s, pc_model_nonlinear_60s, pc_model_nonlinear_70s,
              pc_model_nonlinear_80s, pc_model_nonlinear_90s, pc_model_nonlinear_00s,
              pc_model_nonlinear_10s, pc_model_nonlinear_full,
              type = reg_doctype,
              title = "Nonlinear Phillips Curve Regressions by Decade, 1950-2017",
              out = paste0(reg_dir,"pc_nonlinear_reg_table.htm"),
              dep.var.labels = c("Inflation Rate"),
              covariate.labels = c("U3 Unemployment Rate", "Square of U3", "Constant"))
  })

  # Plot inflation over time for the specified period
  output$inflPlot <- renderPlot({
    plot.pc(data = pc, period_start = input$yearRange[1], period_end = input$yearRange[2])
  })

  # Plot unemployment (U3) over time for the specified period
  output$u3Plot <- renderPlot({
    plot.u3(data = pc, period_start = input$yearRange[1], period_end = input$yearRange[2])
  })

  # Plot unemployment (U6) over time for the specified period
  output$u6Plot <- renderPlot({
    plot.u6(data = pc_u6, period_start = input$yearRange[1], period_end = input$yearRange[2])
  })

  # Plot the natural unemployment rate over time for the specified period
  output$u3u6Plot <- renderPlot({
    plot.unemployment(data = pc_u6, period_start = input$yearRange[1], period_end = input$yearRange[2])
  })

  # Jointly plot the inflation rate and unemployment rate over time for the specified period
  output$influ3Plot <- renderPlot({
    plot.infl.u3(data = pc, period_start = input$yearRange[1], period_end = input$yearRange[2])
  })

  # Plot the natural unemployment rate over time for the specified period
  output$nrouPlot <- renderPlot({
    plot.nrou(data = pc_nrou, period_start = input$yearRange[1], period_end = input$yearRange[2])
  })

}

# Run the application
shinyApp(ui = ui, server = server)