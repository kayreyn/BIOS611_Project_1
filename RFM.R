## Heart Disease ##
## Kaylia Reynolds ##

## Libraries
library(randomForest)

########################################

## Load Data
heart <- read_csv("derived_data/pure_heart.txt",
                  col_names = TRUE)

# Cleaning
cols.to.change <- c(2, 3, 6, 7, 9, 11, 12, 13, 14)
heart[, cols.to.change] <- lapply(heart[, cols.to.change], factor)
# str(heart)

#######################################

## Random Forest Model

# Set Seed
set.seed(1032020)

# Select Numbers for Training/Test
heart.train.nums <- sample(nrow(heart), round(0.9 * nrow(heart)))

# Create Training Group
heart.train <- heart[heart.train.nums, ]
table(heart.train$disease.status)

# Create Testing Group
heart.test <- heart[-heart.train.nums, ]
#table(heart.test$disease.status)

#str(heart.train)

# Tune Parameters
k.rf <- tuneRF(x = heart.train %>% select(-disease.status),
               y = as.factor(heart.train[['disease.status']]),
               ntreeTry = 500, stepFactor = 3, improve = 0.01,
               trace = TRUE, plot = TRUE)
#k.rf

# Fit Model
heart.rf <- randomForest(as.factor(disease.status) ~ .,
                           data = heart.train,
                           mtry = 3,
                           ntree = 500,
                           importance = TRUE)
# Test Model
titanic.rf <- randomForest(x = heart.train %>% select(-disease.status),
                           y = as.factor(heart.train[['disease.status']]),
                           xtest = heart.test %>% select(-disease.status),
                           ytest = as.factor(heart.test$disease.status),
                           mtry = 3,
                           ntree = 500,
                           importance = TRUE)


#heart.rf$err.rate
#plot(heart.rf)                        
#varImpPlot(heart.rf)
#predict(heart.rf, newdata = heart)




