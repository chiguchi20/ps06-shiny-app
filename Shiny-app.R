#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

SLR <- read_delim("GMSL_TPJAOS_5.1_199209_202212.csv")

#colors <- c("cyan2", "darkolivegreen1", "darksalmon")

# Define UI for application that draws a histogram
ui <- fluidPage(
  tabsetPanel(
    tabPanel("General Information",
      titlePanel("General Information"),
      p("This dataset is looking at global mean sea level rise since 1993, and 
        was produced by NASA. They used a variety of different techniques and tools 
        in order to produce as accurate data as possible. The table includes some 
        of the data from the different techniques and strategies that they used.")
    ),
      
    tabPanel("Plot", 
      # Application title
      titlePanel("Plot of General Mean Sea Level Rise Variation by Year"),

      # Sidebar with a slider and checkbox input for number of bins 
      sidebarLayout(
        sidebarPanel(
          
          sliderInput("Year_range", label = "Choose the year range", 
                      min = min(SLR$Year), max = max(SLR$Year),
                      value = c(1994, 2022)),
          
          radioButtons("radio", label = h3("Choose Plot Color"),
                       choices = c("cyan2", "darkgoldenrod1", "darksalmon")),
          
        ),
      
          # Show a plot of the generated distribution
          mainPanel(
            plotOutput("graph")
          )
      )
    ),
    
    tabPanel("Table", 
      # Application title
      titlePanel("Table of General Mean Sea Level Rise Variation by Year"),
             
      # Sidebar with a checkbox input for number of bins 
      sidebarLayout(
        sidebarPanel(
          checkboxGroupInput("columns", "Select columns to display:",
                             choices = colnames(SLR),
                             selected = colnames(SLR)),
          
          ),
               
          # Show a table of the generated distribution
          mainPanel(
            tableOutput("table")
          )
        )     
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
    output$graph <- renderPlot({
      SLR %>%
        filter(Year >= input$Year_range[1], Year <= input$Year_range[2]) %>%
        ggplot(aes(Year, GMSLV_in_mm)) +
        geom_line(color = input$radio) +
        geom_point(color = input$radio)
    }) 

    output$table <- renderTable({
      data_subset <- SLR %>%
        select(input$columns)
      
      data_subset
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
