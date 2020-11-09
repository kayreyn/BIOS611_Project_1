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
cont.name <- names(heart)[c(1, 4, 5, 8, 10)]
nice.name <- c("Age", "Resting Blood Pressure", "Cholesterol", "Maximum Heart Rate", "Standard Depression")

#################################################################

# Get User Input
# Find Port
args <- commandArgs(trailingOnly=T)
port <- as.numeric(args[[1]])

## Shiny App

# Define UI for app  ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Train K Means for Disease Status"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      div("Please Select Desired Variables"),
      
      # Input: X Axis Variable ----
      selectInput(inputId = "x.ax",
                  label = "Variable 1:",
                  choices = nice.name),#,
                  #selected = "Age"),
      
      # Input: Y Axis Variable ----
      selectInput(inputId = "y.ax",
                  label = "Variable 2:",
                  choices = nice.name[2:5]),
      
      # Input: Cluster Assignment ----
      selectInput(inputId = "clust",
                  label = "Which cluster should represent individuals with heart disease?",
                  choice = c("1", "2"),
                  selected = "1"),

    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Scatterplot by Disease Status ----
      plotOutput(outputId = "ScatterDisease"),
      textOutput(outputId = "FScore"),
      tags$head(tags$style("#FScore{color: black;
                                 font-size: 20px;
                                 font-style: bold;
                                 }"))
    )
  )
)

server <- function(input, output, session) {

  # Update: Y Axis Variable
  observeEvent(input$x.ax,{
    if (input$x.ax == input$y.ax){
      updateSelectInput(session, 
                        "y.ax", 
                        choices = nice.name[which(nice.name != input$x.ax)])
    }
  })
  
  # Graph Output
  output$ScatterDisease <- renderPlot({
    
    # Pause Until Y Var is Chosen
    req(input$y.ax != "")
    req(input$y.ax != input$x.ax)
    
    # Which X and Y were chosen? Which Cluster?
    the.x <- cont.name[which(nice.name == input$x.ax)]
    the.y <- cont.name[which(nice.name == input$y.ax)]
    d.y <- input$clust
    d.n.ops <- c("1", "2")
    d.n <- d.n.ops[which(d.n.ops != d.y)]

    ## K Means
    if (which(nice.name == input$x.ax) < which(nice.name == input$y.ax)){
      kmean.df <- heart %>% select(c("disease.status", the.x, the.y))
    } else {
      kmean.df <- heart %>% select(c("disease.status", the.y, the.x))
    }
    
    # Copy and Scale
    kmean.df.s <- kmean.df
    kmean.df.s[ ,c(2:3)] <- scale(kmean.df.s[ , c(2:3)])
    
    # KMeans
    cluster.det <- kmeans(kmean.df.s[, c(2:3)], 2, nstart = 25)
    
    # Assign Cluster Nums
    kmean.df$cluster.num <- as.factor(cluster.det$cluster)

    # Make Scatter by Disease Status
    d <- ggplot(heart, aes_string(x = the.x, y = the.y, color = "disease.status")) + geom_point() +
      ggtitle("Original Distribution by Heart Disease Status") +
      ylab(nice.name[which(cont.name == the.y)]) +
      xlab(nice.name[which(cont.name == the.x)]) +
      labs(color = "Disease Status") +
      scale_color_manual(labels = c("Healthy", "Heart Disease"), values = c("blue", "red"))
    
    # Graph
    k <- ggplot(kmean.df, aes_string(x = the.x, y = the.y, color = "cluster.num")) +
      geom_point() +
      labs(color = "Cluster") +
      ggtitle("Calculated K Means Clusters") +
      scale_color_manual(breaks = c("1", "2"), labels = c("1", "2"), values = c("darkturquoise", "purple")) +
      ylab(nice.name[which(cont.name == the.y)]) +
      xlab(nice.name[which(cont.name == the.x)])

    # Make Conf
    conf.mat <- as.data.frame(table(as.factor(kmean.df$disease.status), as.factor(kmean.df$cluster.num)))
    
    # Calculate Precision and Recall
    pres <- (conf.mat[which(conf.mat$Var1 == "1" & conf.mat$Var2 == d.y), 3]) /
      (conf.mat[which(conf.mat$Var1 == "1" & conf.mat$Var2 == d.y), 3] +
         conf.mat[which(conf.mat$Var1 == "0" & conf.mat$Var2 == d.y), 3])
    rec <-  (conf.mat[which(conf.mat$Var1 == "1" & conf.mat$Var2 == d.y), 3]) /
      (conf.mat[which(conf.mat$Var1 == "1" & conf.mat$Var2 == d.y), 3] +
         conf.mat[which(conf.mat$Var1 == "1" & conf.mat$Var2 == d.n), 3])
    
    # F1 Score
    f1 <- 2 * (pres * rec) / (pres + rec)
  
    output$FScore <- renderText({
      pay.attention <- input$clust
      paste("The F1 Score is ", round(f1, 3), sep = "")
    })
    
    # Clump Graphs
    grid.arrange(d, k)

  })   

  
}  



print(sprintf("Starting shiny on port %d", port))
shinyApp(ui = ui, server = server, options = list(port=port,
                                                host="0.0.0.0")) 