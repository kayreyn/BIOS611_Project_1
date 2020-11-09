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

str(heart)
# Prepare Table

#################################################################

# Get User Input
#args <- commandArgs(trailingOnly = TRUE)

# Find Port
#port <- as.numeric(args[[1]])

## Shiny App

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Train K Means for Disease Status"),
  
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
                  choices = nice.name[2:5]),
      
      # Input: Cluster Assignment ----
      selectInput(inputId = "clust",
                  label = "Heart Disease Cluster:",
                  choice = c("1", "2"),
                  selected = "1"),

    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Scatterplot by Disease Status ----
      plotOutput(outputId = "ScatterDisease"),
      textOutput(outputId = "FScore")
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
    
    # Create Confusion Matrix
    conf.mat <- as.data.frame(table(as.factor(kmean.df$disease.status), kmean.df$cluster.num))
    ReactiveDf(conf.mat)
    
    # Make Scatter by Disease Status
    d <- ggplot(heart, aes_string(x = the.x, y = the.y, color = "disease.status")) + geom_point() +
      ggtitle(paste("Heart Disease Status by ", input$x.ax, " and ", input$y.ax, sep = "")) +
      ylab(nice.name[which(cont.name == the.y)]) +
      xlab(nice.name[which(cont.name == the.x)]) +
      labs(color = "Disease Status") +
      scale_color_manual(labels = c("Healthy", "Heart Disease"), values = c("blue", "red"))
  
    # Graph
    k <- ggplot(kmean.df, aes_string(x = the.x, y = the.y, color = "cluster.num")) +
      geom_point() +
      labs(color = "Cluster") +
      ggtitle("K Means Clusters") +
      scale_color_manual(labels = c("1", "2"), values = c("deepskyblue", "indianred1")) +
      ylab(nice.name[which(cont.name == the.y)]) +
      xlab(nice.name[which(cont.name == the.x)])

      
    # Clump Graphs
    grid.arrange(d, k)

  })    
  
  ReactiveDf <- reactiveVal(df)
  
  # Output f1 Score
  output$FScore <- renderText({
    req(input$y.ax != "")

    conf.mat <- ReactiveDf()

    d.y <- input$clust
    d.n.ops <- c("1", "2")
    d.n <- d.n.ops[which(d.n.ops != d.y)]

    # Calculate Precision and Recall
    pres <- (conf.mat[which(conf.mat$Var1 == "1" & conf.mat$Var2 == d.y), 3]) /
      (conf.mat[which(conf.mat$Var1 == "1" & conf.mat$Var2 == d.y), 3] +
        conf.mat[which(conf.mat$Var1 == "0" & conf.mat$Var2 == d.y), 3])
    rec <-  (conf.mat[which(conf.mat$Var1 == "1" & conf.mat$Var2 == d.y), 3]) /
      (conf.mat[which(conf.mat$Var1 == "1" & conf.mat$Var2 == d.y), 3] +
        conf.mat[which(conf.mat$Var1 == "1" & conf.mat$Var2 == d.n), 3])

    # F1 Score
    f1 <- 2 * (pres * rec) / (pres + rec)

    paste("The F1 Score is ", round(f1, 3), sep = "")
  })
  
}

shinyApp(ui = ui, server = server) 
