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

SLR <- read_delim("/Users/chloe/Desktop/INFO201/ps06-shiny-app/GMSL_TPJAOS_5.1_199209_202212.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
  tabsetPanel(
    tabPanel("Plot", 
             # Application title
             titlePanel("Plot of General Mean Sea Level Rise Variation by Year"),
             
             # Sidebar with a slider input for number of bins 
             sidebarLayout(
               sidebarPanel(
                 checkboxInput("trendline", "Add trend line", value = TRUE)
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
             
             # Sidebar with a slider input for number of bins 
             sidebarLayout(
               sidebarPanel(
                 checkboxGroupInput("columns", "Select columns to display:",
                                    choices = colnames(SLR),
                                    selected = colnames(SLR)),
                 
               ),
               
               # Show a plot of the generated distribution
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
      ggplot(aes(x = Year, y = GMSLV_in_mm)) +
      geom_point() +
      if (input$trendline) {
        stat_smooth(method = "lm")
      }
  })
  
  output$table <- renderTable({
    data_subset <- SLR %>%
      select(input$columns)
    
    data_subset
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
