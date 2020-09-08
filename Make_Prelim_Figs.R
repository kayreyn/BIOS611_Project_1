## Heart Disease ##
## Kaylia Reynolds ##

## Libraries
library(ggplot2)
library(tidyverse)
library(gridExtra)
library(grid)

#############################################################

## Load Data
heart <- read_csv("derived_data/pure_heart.txt",
                  col_names = TRUE)

# nrow(heart)

#############################################################

## Cleaning
# Factors
cols.to.change <- c(2, 3, 6, 7, 9, 11, 12, 13, 14)
heart[, cols.to.change] <- lapply(heart[, cols.to.change], factor)
# str(heart)

#############################################################

## Continuous Plots
# Age
age.bx <- ggplot(heart, aes(x = disease.status, y = age)) + 
	geom_boxplot(fill = "lightblue") +
	xlab("") +
	coord_flip() +
	ylab("Age (years)") +
	scale_x_discrete(labels = c("Heart Disease", "Control"))

# Resting Blood Pressure
restingbp.bx <- ggplot(heart, aes(x = disease.status, y = restingbp)) + 
	geom_boxplot(fill = "lightblue") +
	xlab("") +
	coord_flip() +
	ylab("Resting Blood Pressure (mmHg)") +
	scale_x_discrete(labels = c("Heart Disease", "Control"))

# Cholesterol Count
cholest.bx <- ggplot(heart, aes(x = disease.status, y = cholest)) + 
	geom_boxplot(fill = "lightblue") +
	xlab("") +
	coord_flip() +
	ylab("Cholesterol Level (mmol/L)") +
	scale_x_discrete(labels = c("Heart Disease", "Control"))

# Maximum Heart Rate
maxheartrate.bx <- ggplot(heart, aes(x = disease.status, y = maxheartrate)) + 
	geom_boxplot(fill = "lightblue") +
	xlab("") +
	coord_flip() +
	ylab("Maximum Heart Rate (bpm)") +
	scale_x_discrete(labels = c("Heart Disease", "Control"))

# SOMETHING
st.depress.bx <- ggplot(heart, aes(x = disease.status, y = st.depress)) + 
	geom_boxplot(fill = "lightblue") +
  xlab("") +
	coord_flip() +
	ylab("ST Depression Induced by Exercise Relative to Rest (mm)") +
	scale_x_discrete(labels = c("Heart Disease", "Control"))

lay <- rbind(c(1,1,1,1,10),
             c(2,2,2,2,10),
             c(3,3,3,3,10),
             c(4,4,4,4,10),
             c(5,5,5,5,10))

# All Continuous Vars
#grid.arrange(age.bx, restingbp.bx, cholest.bx, maxheartrate.bx, st.depress.bx, 
#            left = "Disease Status",
#            top = textGrob("Continuous Variable Distributions", gp = gpar(fontsize = 15)),
#            layout_matrix = lay)

cont.vars <- arrangeGrob(age.bx, restingbp.bx, cholest.bx, maxheartrate.bx, st.depress.bx,
                         left = textGrob("Disease Status", gp = gpar(fontsize = 15), rot = 90),
                         top = textGrob("Continuous Variable Distributions", gp = gpar(fontsize = 18)),
                         layout_matrix = lay)

ggsave("figures/cont_var_distributions.png", cont.vars, width = 5, height = 6)


#############################################################

## Discrete Plots

# Set colors
bar.cols <- c("palevioletred3", "steelblue3")

# Sex Counts
sex.cnt <- ggplot(heart, aes(sex)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	xlab("Sex") + 
	ylab("") +
	scale_fill_manual(values = bar.cols,
				name = "Disease Status", 
				labels = c("Control", "Heart Disease")) +
  theme(legend.position="right") +
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("Female", "Male"))

# Chest Pain Counts
chest.cnt <- ggplot(heart, aes(chest.pain)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	xlab("Chest Pain Type") + 
	ylab("") +
	scale_fill_manual(values = bar.cols,
				name = "Disease Status", 
				labels = c("Control", "Heart Disease")) +
  theme(legend.position="none") +
  scale_x_discrete(breaks=c("1","2", "3", "4"),
                   labels=c("Typical\nAngina", "Atypical\nAngina", "Non-Anginal\nPain", "Asymptomatic"))

# Fasting Counts
fasting.cnt <- ggplot(heart, aes(fastingbs)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	xlab("Fasting Blood Sugar") + 
	ylab("") +
	scale_fill_manual(values = bar.cols,
				name = "Disease Status", 
				labels = c("Control", "Heart Disease")) +
  theme(legend.position="none") +
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("False", "True"))

# Resting Counts
restingec.cnt <- ggplot(heart, aes(restingec)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	xlab("Resting Electrocardiographic Results") + 
	ylab("") +
	scale_fill_manual(values = bar.cols,
				name = "Disease Status", 
				labels = c("Control", "Heart Disease")) +
  theme(legend.position="none") +
  scale_x_discrete(breaks=c("0","1", "2"),
                   labels=c("Normal", "ST-T Wave\n Abnormality", "Left Ventricular\nHypertrophy"))

# Old Peak Counts
oldpeak.cnt <- ggplot(heart, aes(oldpeak)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	xlab("Peak Exercise ST Segment Slope") + 
	ylab("") +
  scale_fill_manual(values = bar.cols,
    name = "Disease Status", 
		labels = c("Control", "Heart Disease")) +
  theme(legend.position="none") +
  scale_x_discrete(breaks=c("1","2", "3"),
                   labels=c("Upsloping", "Flat", "Downsloping"))

# Exercise Counts
exercise.cnt <- ggplot(heart, aes(exercise.ang)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	xlab("Exercise Induced Angina") + 
	ylab("") +
	scale_fill_manual(values = bar.cols,
				name = "Disease Status", 
				labels = c("Control", "Heart Disease")) +
  theme(legend.position="none") +
  scale_x_discrete(breaks=c("0","1"),
                   labels=c("No", "Yes"))

# Max Vessels Counts
mag.vessels.cnt <- ggplot(heart, aes(mag.vessels)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	xlab("Major Vessels Colored by Flourosopy") + 
	ylab("") +
	scale_fill_manual(values = bar.cols,
				name = "Disease Status", 
				labels = c("Control", "Heart Disease")) +
  theme(legend.position="none")

# Thal Counts
thal.cnt <- ggplot(heart, aes(thal)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	xlab("Thalium") + 
	ylab("") +
	scale_fill_manual(values = bar.cols,
				name = "Disease Status", 
				labels = c("Control", "Heart Disease")) +
  theme(legend.position="none") +
  scale_x_discrete(breaks=c("3", "6","7"),
                   labels=c("Normal", "Fixed\nDefect", "Reversable\nDefect"))  
  
# Layout
third.lay <- rbind(c(1,1,1,1,2,2,2,2,9,9),
                   c(4,4,4,4,5,5,5,5,9,9),
                   c(7,7,7,7,8,8,8,8,9,9),
                   c(3,3,3,3,6,6,6,6,9,9))

# Function for Extracting a Legend
g_legend <- function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

mylegend <- g_legend(sex.cnt)

# All Discrete Vars
#grid.arrange(arrangeGrob(sex.cnt + theme(legend.position="none"),
#                         mag.vessels.cnt, exercise.cnt, oldpeak.cnt, 
#                         restingec.cnt, fasting.cnt, chest.cnt, thal.cnt, 
#                         mylegend, layout_matrix = third.lay),
#	top = textGrob("Discrete Variable Distributions", gp = gpar(fontsize = 18)),
#	left = textGrob("Count", gp = gpar(fontsize = 15), rot = 90))

# Plot and Save
discrete.vars <- arrangeGrob(arrangeGrob(sex.cnt + theme(legend.position="none"),
                                         mag.vessels.cnt, exercise.cnt, oldpeak.cnt, 
                                         restingec.cnt, fasting.cnt, chest.cnt, thal.cnt, 
                                         mylegend, layout_matrix = third.lay),
                             top = textGrob("Discrete Variable Distributions", gp = gpar(fontsize = 18)),
                             left = textGrob("Count", gp = gpar(fontsize = 15), rot = 90))

ggsave("figures/disc_var_distributions.png", discrete.vars, height = 9, width = 9.5)
