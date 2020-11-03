## Kaylia Reynolds ##
## R Shiny App ##

## Libraries
library(shiny)
library(tidyverse)
library(plotly)
library(stats)
library(gridExtra)

#################################################################

## Load Data
heart <- suppressMessages(read_csv("derived_data/pure_heart.txt",
                                   col_names = TRUE))

#################################################################

## Cleaning
heart$disease.status <- as.factor(heart$disease.status)

## List of Continuous Variable Choices
cont.name <- names(heart)[c(1,4,5,8, 10)]
nice.name <- c("Age", "Resting Blood Pressure", "Cholesterol", "Maximum Heart Rate", "Standard Depression")

str(heart)
# Prepare Table

#################################################################

# Get User Input
args <- commandArgs(trailingOnly=T)

# Find Port
port <- as.numeric(args[[1]])

## Shiny App

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("K Means for Disease Status"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      div("Please Select Variables"),
      
      # Input: X Axis Variable ----
      selectInput(inputId = "x.ax",
                  label = "Explantory:",
                  choices = nice.name),#,
                  #selected = "Age"),
      
      # Input: Y Axis Variable ----
      selectInput(inputId = "y.ax",
                  label = "Response:",
                  choices = ""),

    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Scatterplot by Disease Status ----
      plotOutput(outputId = "ScatterDisease")
      
    )
  )
)

server <- function(input, output, session) {

  # Update: Y Axis Variable
  observeEvent(input$x.ax,({
    updateSelectInput(session, 
                      "y.ax", 
                      choices = nice.name[which(nice.name != input$x.ax)])
  }))
  

  
  # Output
  output$ScatterDisease <- renderPlot({
    
    # Which X and Y were chosen?
    the.x <- cont.name[which(nice.name == input$x.ax)]
    the.y <- cont.name[which(nice.name == input$y.ax)]
    req(the.y != "")
    # Make Scatter by Disease Status
    d <- ggplot(heart, aes_string(x = the.x, y = the.y, color = "disease.status")) + geom_point() +
      ggtitle(paste("Heart Disease Status by ", input$x.ax, " and ", input$y.ax, ".", sep = "")) +
      ylab(nice.name[which(cont.name == the.y)]) +
      xlab(nice.name[which(cont.name == the.x)]) +
      labs(color = "Disease Status") +
      scale_color_manual(labels = c("Healthy", "Heart Disease"), values = c("blue", "red"))
      
    ## K Means
    # Prepare small df
    kmean.df <- heart %>% select(c(the.x, the.y))
    
    # KMeans
    cluster.det <- kmeans(kmean.df, 2)
    
    # Assign Cluster Nums
    kmean.df$cluster.num <- as.character(cluster.det$cluster)
    
    # Graph
    k <- ggplot(kmean.df, aes_string(x = the.x, y = the.y, color = "cluster.num")) +
      geom_point() +
      labs(color = "Cluster") +
      scale_color_manual(labels = c("Group 1", "Group 2"), values = c("red", "blue")) +
      ggtitle("K Means Clusters") +
      ylab(nice.name[which(cont.name == the.y)]) +
      xlab(nice.name[which(cont.name == the.x)])
    
      grid.arrange(d, k)
  })    
}

shinyApp(ui = ui, server = server) 
