## Heart Disease ##
## Kaylia Reynolds ##

## Libraries
library(ggplot2)
library(tidyverse)
library(gridExtra)

## Filepaths
heart.file <- "C:\\Users\\Kaylia\\Documents\\Kaylia\\UNC First\\BIOS 611\\Project 1\\heart.csv"

#############################################################

## Load Data
heart <- read.csv(heart.file, header = TRUE)

# Examine
str(heart)

#############################################################

## Cleaning
# Rename
names(heart) <- c("age", "sex", "chest.pain", "restingbp", "cholest", "fastingbs",
	"restingec", "maxheartrate", "exercise.ang", "st.depress", "oldpeak",
	"mag.vessels", "thal", "disease.status")

# Factors
cols.to.change <- c(2,3,6,7,9,11,12,13,14)
heart[,cols.to.change] <- lapply(heart[,cols.to.change] , factor)
str(heart)

#############################################################

## Continuous Plots
# Age
age.bx <- ggplot(heart, aes(x = disease.status, y = age)) + 
	geom_boxplot(fill = "lightblue") +
	xlab("Disease Status") +
	coord_flip() +
	ylab("Age (years)") +
	# ggtitle("Distribution of Age by Disease Status") +
	scale_x_discrete(labels = c("Heart Disease", "Control"))

# Resting Blood Pressure
restingbp.bx <- ggplot(heart, aes(x = disease.status, y = restingbp)) + 
	geom_boxplot(fill = "lightblue") +
	xlab("Disease Status") +
	coord_flip() +
	ylab("Resting Blood Pressure ( )") +
	# ggtitle("Distribution of Blood Pressure by Disease Status") +
	scale_x_discrete(labels = c("Heart Disease", "Control"))

# Cholesterol Count
cholest.bx <- ggplot(heart, aes(x = disease.status, y = cholest)) + 
	geom_boxplot(fill = "lightblue") +
	xlab("Disease Status") +
	coord_flip() +
	ylab("Cholesterol Level ()") +
	# ggtitle("Distribution of Cholesterol Levels by Disease Status") +
	scale_x_discrete(labels = c("Heart Disease", "Control"))

# Maximum Heart Rate
maxheartrate.bx <- ggplot(heart, aes(x = disease.status, y = maxheartrate)) + 
	geom_boxplot(fill = "lightblue") +
	xlab("Disease Status") +
	coord_flip() +
	ylab("Maximum Heart Rate ()") +
	# ggtitle("Distribution of Maximum Heart Rate by Disease Status") +
	scale_x_discrete(labels = c("Heart Disease", "Control"))

# SOMETHING
st.depress.bx <- ggplot(heart, aes(x = disease.status, y = st.depress)) + 
	geom_boxplot(fill = "lightblue") +
	xlab("Disease Status") +
	coord_flip() +
	ylab("SOMETHING ()") +
	# ggtitle("Distribution of SOMETHING by Disease Status") +
	scale_x_discrete(labels = c("Heart Disease", "Control"))

# All Continuous Vars
grid.arrange(age.bx, restingbp.bx, cholest.bx, maxheartrate.bx, st.depress.bx)

#############################################################

## Discrete Plots
# Sex Counts
sex.cnt <- ggplot(heart, aes(sex)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	# ggtitle("Sex Frequencies by Disease Status") +
	xlab("Sex") + 
	ylab("Count") +
	scale_fill_manual(values = c("palevioletred3", "#56B4E9"),
				name = "Disease Status", 
				labels = c("Control", "Heart Disease"))

# Chest Pain Counts
chest.cnt <- ggplot(heart, aes(chest.pain)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	# ggtitle("Chest Pain Rating by Disease Status") +
	xlab("Chest Pain") + 
	ylab("Count") +
	scale_fill_manual(values = c("palevioletred3", "#56B4E9"),
				name = "Disease Status", 
				labels = c("Control", "Heart Disease"))

# Fasting Counts
fasting.cnt <- ggplot(heart, aes(fastingbs)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	# ggtitle("Fasting Blood SOmething by Disease Status") +
	xlab("Fasting") + 
	ylab("Count") +
	scale_fill_manual(values = c("palevioletred3", "#56B4E9"),
				name = "Disease Status", 
				labels = c("Control", "Heart Disease"))

# Resting Counts
restingec.cnt <- ggplot(heart, aes(restingec)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	# ggtitle("Sex Frequencies by Disease Status") +
	xlab("Resting") + 
	ylab("Count") +
	scale_fill_manual(values = c("palevioletred3", "#56B4E9"),
				name = "Disease Status", 
				labels = c("Control", "Heart Disease"))

# Old Peak Counts
oldpeak.cnt <- ggplot(heart, aes(oldpeak)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	# ggtitle("Sex Frequencies by Disease Status") +
	xlab("Old Peak") + 
	ylab("Count") +
	scale_fill_manual(values = c("palevioletred3", "#56B4E9"),
				name = "Disease Status", 
				labels = c("Control", "Heart Disease"))

# Exercise Counts
exercise.cnt <- ggplot(heart, aes(exercise.ang)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	# ggtitle("Sex Frequencies by Disease Status") +
	xlab("Exercise") + 
	ylab("Count") +
	scale_fill_manual(values = c("palevioletred3", "#56B4E9"),
				name = "Disease Status", 
				labels = c("Control", "Heart Disease"))

# Max Vessels Counts
mag.vessels.cnt <- ggplot(heart, aes(mag.vessels)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	# ggtitle("Sex Frequencies by Disease Status") +
	xlab("Max Vessels") + 
	ylab("Count") +
	scale_fill_manual(values = c("palevioletred3", "#56B4E9"),
				name = "Disease Status", 
				labels = c("Control", "Heart Disease"))

# Thal Counts
thal.cnt <- ggplot(heart, aes(thal)) + 
	geom_bar(aes(fill = disease.status), position = "dodge") + 
	# ggtitle("Sex Frequencies by Disease Status") +
	xlab("thal") + 
	ylab("Count") +
	scale_fill_manual(values = c("palevioletred3", "#56B4E9"),
				name = "Disease Status", 
				labels = c("Control", "Heart Disease"))

# All Discrete Vars
grid.arrange(thal.cnt, mag.vessels.cnt, exercise.cnt, 
	oldpeak.cnt, restingec.cnt, fasting.cnt, chest.cnt, sex.cnt)

