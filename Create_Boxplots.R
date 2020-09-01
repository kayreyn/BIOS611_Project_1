## Heart Disease ##
## Kaylia Reynolds ##

## Libraries
library(ggplot2)
library(tidyverse)
library(gridExtra)

#############################################################

## Load Data
heart <- read.csv("source_data\\heart.csv", header = TRUE)

# Examine
str(heart)
