## Heart Disease ##
## Kaylia Reynolds ##

## Libraries
library(tidyverse)
library(bestglm)
library(pROC)
library(pixiedust)
library(kableExtra)
library(gridExtra)
library(webshot)
library(magick)

########################################

## Load Data
heart <- read_csv("derived_data/pure_heart.txt",
                  col_names = TRUE)

## Cleaning
# Factors
cols.to.change <- c(2, 3, 6, 7, 9, 11, 12, 13, 14)
heart[, cols.to.change] <- lapply(heart[, cols.to.change], factor)
# str(heart)

########################################

## Variable Selection
my.best.model <- bestglm(as.data.frame(heart), IC = "AIC", method = "exhaustive", family = binomial)
heart.mod <- my.best.model$BestModel
summary(heart.mod)


##
pred.probs <- predict.glm(heart.mod, type = "response") 

thresh <- seq(0, 1, length = 100)
misclass <- rep(NA, length = length(thresh))

##Find the threshold
for(i in 1:length(thresh)) {
  #If probability greater than threshold then 1 else 0
  my.classification <- ifelse(pred.probs > thresh[i], 1, 0)  # must match what data says :)
  # calculate the pct where my classification not eq truth
  misclass[i] <- mean(my.classification != heart$disease.status)
}

#Find threshold which minimizes misclassification
my.thresh <- thresh[which.min(misclass)]

plot(thresh, misclass, pch  = ".", ylab = "Misclassification", xlab = "Threshold", main = "Threshold Calculation")
  lines(thresh, misclass)
  abline(v = my.thresh)

####################################

# Cross validation

## Choose number of CV studies to run in a loop & test set size
n.cv <- 500
n.test <- round(.1*nrow(heart))

## Set my threshold for classifying
cutoff <- my.thresh

## Initialize matrices to hold CV results
sens <- rep(NA,n.cv)
spec <- rep(NA,n.cv)
ppv <- rep(NA,n.cv)
npv <- rep(NA,n.cv)
auc <- rep(NA,n.cv)


## Begin for loop
for(cv in 1:n.cv){
  # Separate into test and training sets
  test.obs <- sample(1:nrow(heart), n.test)
  test.set <- heart[test.obs,]
  train.set <- heart[-test.obs,]
  
  # Fit best model to training set
  train.model <- heart.mod
  
  # Use fitted model to predict test set
  pred.probs <- predict.glm(train.model, newdata = test.set, type = "response") #response gives probabilities
  
  # Classify according to threshold
  test.class <- ifelse(pred.probs > cutoff, 1, 0)
  
  # Create a confusion matrix
  conf.mat <- addmargins(table(factor(test.set$disease.status, levels = c(0, 1)), factor(test.class, levels = c(0, 1))))
  
  # Pull of sensitivity, specificity, PPV and NPV using bracket notation
  sens[cv] <- conf.mat[2,2] / conf.mat[2,3]
  spec[cv] <- conf.mat[1,1] / conf.mat[1,3]
  ppv[cv] <- conf.mat[2,2] / conf.mat[3,2]
  npv[cv] <- conf.mat[1,1] / conf.mat[3,1]
  
  # Calculate AUC
  auc[cv] <- auc(roc(test.set$disease.status, pred.probs, quiet = TRUE))
} 

# Averages?
mean.auc <- mean(auc)
mean.sens <- mean(sens)
mean.spec <- mean(spec)
mean.ppv <- mean(ppv)
mean.npv <- mean(npv)

#####################################

# Calculate Confidence Intervals
ad <- as.data.frame(confint(heart.mod))
rownames(ad) <- c()
colnames(ad) <- c("lower", "upper")

# Combine Confidence with Rest of Table
whole.table <- cbind(dust(heart.mod), ad)[, c(1,2,5,6,7)]
whole.table$estimate <- as.numeric(whole.table$estimate)
whole.table$p.value <- as.numeric(whole.table$p.value)

# Beautify Table and Save
log.reg.table <- dust(whole.table) %>%
  sprinkle(col = 2:5, round = 3) %>%
  sprinkle_colnames(term = "Variable",
                    estimate = "Beta",
                    p.value = "p",
                    lower = "Lower CI",
                    upper = "Upper CI") %>%
  sprinkle(cols = "term", replace = c("Intercept", "Age - Male",
                                          "Chest Pain - Atypical Angina", "Chest Pain - Non-Anginal Pain",
                                          "Chest Pain - Asymptomatic", "Resting Blood Pressure",
                                          "Maximum Heart Rate", "Exercise Induced Angina - Yes",
                                          "ST Depression", "Slope of the Peak Exercise - Flat",
                                          "Slope of the Peak Exercise - Downsloping", "Colored Major Vessels - 1",
                                          "Colored Major Vessels - 2", "Colored Major Vessels - 3",
                                          "Thalium - Fixed Defect", "Thalium - Reversable Defect")) %>%
  kable() %>%
  kable_styling(bootstrap_options = c("striped","condensed"), full_width = F) %>%
  save_kable("figures/log.reg.table.png", density = 1000)

