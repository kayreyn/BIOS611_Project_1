## Heart Disease ##
## Kaylia Reynolds ##

## Libraries
library(tidyverse)
library(bestglm)
library(pROC)
library(pixiedust)
library(gridExtra)
library(webshot)
library(magick)

########################################

## Load Data
heart <- suppressMessages(read_csv("derived_data/pure_heart.txt",
                  col_names = TRUE))

## Cleaning
# Factors
cols.to.change <- c(2, 3, 6, 7, 9, 11, 12, 13, 14)
heart[, cols.to.change] <- lapply(heart[, cols.to.change], factor)

########################################

## Variable Selection
my.best.model <- bestglm(as.data.frame(heart), IC = "AIC", method = "exhaustive", family = binomial)
heart.mod <- my.best.model$BestModel
#summary(my.best.model)
#summary(heart.mod)

## Predict
pred.probs <- predict.glm(heart.mod, type = "response") 

## Rock curve
a.roc <- suppressMessages(roc(heart$disease.status, pred.probs))

# save
roc.df <- data.frame("sens" = a.roc$sensitivities, "spec1" = 1 -a.roc$specificities)
ggsave("figures/ROC_Curve.png", 
       ggplot(roc.df, aes(x = spec1, y = sens)) +
        geom_line(size = 1.001) +
        geom_abline(intercept = 0, slope = 1) +
        ylab("Sensitivity") +
        xlab("1 - Specificity")+
        ggtitle("Regression ROC Curve"), 
       device = png(), width = 3, height = 3)

# Threshold Best
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

# Save Plot
thrsh.df <- data.frame("thr" = thresh, "misclass" = misclass)
ggsave("figures/Threshold_Classification.png", 
       ggplot(thrsh.df, aes(x = thr, y = misclass)) +
         geom_line() +
         geom_vline(xintercept = my.thresh, col = "darkgreen", size = 1.2) +
         ylab("Misclassification Rate") +
         xlab("Threshold Value")+
         ggtitle("Best Threshold"), 
       device = png(), width = 4, height = 3)

####################################

# Cross validation

## Choose number of CV studies to run in a loop & test set size
n.cv <- 500
n.test <- round(.1*nrow(heart))

## Set my threshold for classifying
cutoff <- my.thresh
set.seed(34546266)

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
  train.set <- heart[-test.obs, ]
  
  # Fit best model to training set
  train.model <- glm(disease.status ~ age + chest.pain + restingbp + maxheartrate +
                      exercise.ang + st.depress + oldpeak + mag.vessels + thal,
                     data = train.set, family = "binomial")
  
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
ad <- exp(as.data.frame(confint(heart.mod)))
rownames(ad) <- c()
colnames(ad) <- c("lower", "upper")

# Combine Confidence with Rest of Table
whole.table <- cbind(dust(heart.mod), ad)[, c(1,2,5,6,7)]
whole.table$estimate <- exp(as.numeric(whole.table$estimate))
whole.table$p.value <- as.numeric(whole.table$p.value)

# Beautify Table and Save
png(filename="figures/log_reg_table.png")
dust(whole.table) %>%
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
                                          "Thallium - Fixed Defect", "Thallium - Reversable Defect")) %>%
  as.data.frame() %>%
  write.table("derived_data/regression_output.txt", quote = FALSE, sep = "\t", row.names =  FALSE)