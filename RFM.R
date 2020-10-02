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
table(heart.test$disease.status)



