# Phillips Curve Analysis              #
# R Shiny App for Interactive Analysis #
# May 15, 2020                         #

# Packages #

library(shiny)
library(shinythemes)
source("helpers/pc.datahelper.R")
source("helpers/pc.visualizationhelper.R")

# Define UI
ui <- navbarPage("Empirical Analysis of the Phillips Curve Model",

  theme = shinytheme("flatly"),

  tabPanel("Inflation Scenarios",

           sidebarLayout(position="right",

                         sidebarPanel(
                           h4("Scenario Analysis", align=''),
                           p("In this tab, you can test the relationship using various models of expected inflation. Compare trends using various values of Beta, where Expected Inflation = Inflation + Beta*(Unemployment - Natural Rate of Unemployment):"),
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
                           sliderInput("yearRangeScenarios", label="Range of years to test",
                                       min=1949, max=2017, value=c(1949, 2017),
                                       sep=""),
                           textOutput("selectionTextScenarios")
                         ),

                         mainPanel(
                           span(strong("The Phillips Curve model")),
                           span("posits that unemployment and inflation have an inverse relationship. High inflation should correlate with low unemployment, and vice versa. Empirical analysis, however, suggests that this relationship has rarely held in the post-WWII United States."),
                           br(), br(),
                           p("Use the control panel to test the Phillips Curve model using historical data over various time periods and using multiple models of expected inflation."),
                           hr(),
                           plotOutput("scenariosPlot")
                         )
           )

  ),

  tabPanel("Standardized Curve Tests",

           sidebarLayout(position="right",

                         sidebarPanel(
                           h4("Standard Model Exploration", align=''),
                           p("U3 is the most commonly used metric of unemployment, and is determined on a monthly basis by BLS. It includes unemployed individuals who are actively seeking work. Unlike U6, however, it does not account for discouraged workers or the underemployed."),
                           p("Use the slider below to test the hypothesized relationship between U3 and inflation for various time periods. Notice that a negative relationship does appear for much of the 1960s, but is hard to find in most other cases."),
                           sliderInput("yearRangeInfl", label="Range of years to test",
                                       min=1949, max=2017, value=c(1949, 2017),
                                       sep=""),
                           br(),
                           textOutput("selectionTextInfl")
                         ),

                         mainPanel(
                           span(strong("The Phillips Curve model")),
                           span("posits that unemployment and inflation have an inverse relationship. High inflation should correlate with low unemployment, and vice versa. Empirical analysis, however, suggests that this relationship has rarely held in the post-WWII United States."),
                           br(), br(),
                           p("Use the control panel to test the Phillips Curve model over various time periods using standardized inflation figures and U3 unemployment."),
                           hr(),
                           plotOutput("inflPlot")
                         )
           )

  ),

  tabPanel("Time Series Data",

           sidebarLayout(position="right",

                         sidebarPanel(
                           h4("Time Series Exploration", align=''),
                           p("In this tab you can explore time series data of the inflation and unemployment rates over a broad swathe of contemporary U.S. history. The figure uses U3 unemployment figures."),
                           p("Notice the relative degrees of change in each metric: unemployment varies considerably more dramatically than inflation."),
                           p("As an exercise, locate notable recessions and bubbles in the timeline; what happened to each metric in each period? Does the relationship posited by the Phillips Curve model hold more for these periods than others?"),
                           sliderInput("yearRangeIU", label="Range of years to test",
                                       min=1949, max=2017, value=c(1949, 2017),
                                       sep=""),
                           br(),
                           textOutput("selectionTextIU")
                         ),

                         mainPanel(
                           span(strong("The Phillips Curve model")),
                           span("posits that unemployment and inflation have an inverse relationship. High inflation should correlate with low unemployment, and vice versa. Empirical analysis, however, suggests that this relationship has rarely held in the post-WWII United States."),
                           br(), br(),
                           p("Use the control panel to view standardized inflation and U3 unemployment data over various historical periods."),
                           hr(),
                           plotOutput("influ3Plot")
                         )
           )

  ),

  tabPanel("Natural Rate of Unemployment",

           sidebarLayout(position="right",

                         sidebarPanel(
                           h4("Natural Rate of Unemployment Exploration", align=''),
                           p("The natural rate of unemployment indicates structural economic effects, such as the displacement of manual labor by technology or shifts in demand for labor in context of global trade. It can vary significantly from the observed (actual) rate of unemployment, whether considering U3, U6, or other alternatives."),
                           p("Here, you can explore the change in the natural rate of unemployment over time. Notice that it is far smoother than U3 or U6, and generally does experience spikes in the same way. This is a reasonable outcome, as structural changes should, in principle, take longer to change than other, more short-term drivers of unemployment."),
                           p("As an exercise, compare it to another unemployment rate. Does it still follow the same trends? How does it track with inflation?"),
                           sliderInput("yearRangeUnemp", label="Range of years to test",
                                       min=1949, max=2017, value=c(1949, 2017),
                                       sep=""),
                           br(),
                           textOutput("selectionTextUnemp")
                           ),

                         mainPanel(
                           span(strong("The Phillips Curve model")),
                           span("posits that unemployment and inflation have an inverse relationship. High inflation should correlate with low unemployment, and vice versa. Empirical analysis, however, suggests that this relationship has rarely held in the post-WWII United States."),
                           br(), br(),
                           p("Use the control panel to view the natural rate of unemployment over various historical periods."),
                           hr(),
                           #plotOutput("u3Plot"),
                           #plotOutput("u6Plot"),
                           #plotOutput("u3u6Plot"),
                           plotOutput("nrouPlot")
                         )
           )

  ),

  tabPanel("Regression Analysis",

           sidebarLayout(position="right",

                         sidebarPanel(
                           h4("Regression Analysis", align=''),
                           p("Beyond graphical analysis, regression analysis can provide a quantitative indication of whether variables demonstrate a significant relationship."),
                           p("In this tab, see how a linear regression and a nonlinear regression - in this case quadratic - compare. Does either provide more robust results, or indicate a significant trend?"),
                           p("In all models, under-fitting and over-fitting are key issues. Note the statistical significance of the regression results and match with expectations from the graphical analysis to consider how each model is performing over the selected time periods (by decade and for the full period)."),
                           br(),
                           radioButtons("regPlotButtons", label="Select linear or nonlinear regression.",
                                        choices=c("Linear", "Nonlinear"),
                                        selected="Linear")
                         ),

                         mainPanel(
                           span(strong("The Phillips Curve model")),
                           span("posits that unemployment and inflation have an inverse relationship. High inflation should correlate with low unemployment, and vice versa. Empirical analysis, however, suggests that this relationship has rarely held in the post-WWII United States."),
                           br(), br(),
                           p("Use the panel on the right to conduct linear and nonlinear regressions on historical data over various time periods."),
                           hr(),
                           conditionalPanel(
                             condition = "input.regPlotButtons == 'Linear'",
                             htmlOutput("linregTable", container = div)
                           ),
                           conditionalPanel(
                             condition = "input.regPlotButtons == 'Nonlinear'",
                             htmlOutput("nonlinregTable", container = div)
                           )
                         )
           )

  )

)

# Define server logic
server <- function(input, output) {

  output$selectionTextScenarios <- renderText({
    paste0("You are testing the ",
           input$yearRangeScenarios[2] - input$yearRangeScenarios[1],
           "-year period from ",
           input$yearRangeScenarios[1],
           " to ",
           input$yearRangeScenarios[2], ".")
  })

  output$selectionTextUnemp <- renderText({
    paste0("You are testing the ",
           input$yearRangeUnemp[2] - input$yearRangeUnemp[1],
           "-year period from ",
           input$yearRangeUnemp[1],
           " to ",
           input$yearRangeUnemp[2], ".")
  })

  output$selectionTextInfl <- renderText({
    paste0("You are testing the ",
           input$yearRangeInfl[2] - input$yearRangeInfl[1],
           "-year period from ",
           input$yearRangeInfl[1],
           " to ",
           input$yearRangeInfl[2], ".")
  })

  output$selectionTextIU <- renderText({
    paste0("You are testing the ",
           input$yearRangeIU[2] - input$yearRangeIU[1],
           "-year period from ",
           input$yearRangeIU[1],
           " to ",
           input$yearRangeIU[2], ".")
  })

  output$selectionTextReg <- renderText({
    paste0("You are testing the ",
           input$yearRangeReg[2] - input$yearRangeReg[1],
           "-year period from ",
           input$yearRangeReg[1],
           " to ",
           input$yearRangeReg[2], ".")
  })

  output$scenariosPlot <- renderPlot({
    plot.infl.exp.nrou(data = pc_nrou,
                       b1 = input$b1, b2 = input$b2, b3 = input$b3,
                       period_start = input$yearRangeScenarios[1], period_end = input$yearRangeScenarios[2],
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
    plot.pc(data = pc, period_start = input$yearRangeInfl[1], period_end = input$yearRangeInfl[2])
  })

  # Plot unemployment (U3) over time for the specified period
  output$u3Plot <- renderPlot({
    plot.u3(data = pc, period_start = input$yearRangeUnemp[1], period_end = input$yearRangeUnemp[2])
  })

  # Plot unemployment (U6) over time for the specified period
  output$u6Plot <- renderPlot({
    plot.u6(data = pc_u6, period_start = input$yearRangeUnemp[1], period_end = input$yearRangeUnemp[2])
  })

  # Plot the natural unemployment rate over time for the specified period
  output$u3u6Plot <- renderPlot({
    plot.unemployment(data = pc_u6, period_start = input$yearRangeUnemp[1], period_end = input$yearRangeUnemp[2])
  })

  # Plot the natural unemployment rate over time for the specified period
  output$nrouPlot <- renderPlot({
    plot.nrou(data = pc_nrou, period_start = input$yearRangeUnemp[1], period_end = input$yearRangeUnemp[2])
  })

  # Jointly plot the inflation rate and unemployment rate over time for the specified period
  output$influ3Plot <- renderPlot({
    plot.infl.u3(data = pc, period_start = input$yearRangeIU[1], period_end = input$yearRangeIU[2])
  })

}

# Run the application
shinyApp(ui = ui, server = server)