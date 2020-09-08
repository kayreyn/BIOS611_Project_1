## Heart Disease ##
## Kaylia Reynolds ##

## Libraries
library(ggplot2)
library(tidyverse)
library(gridExtra)
library(grid)

#############################################################

## Load Data
heart <- read_csv("source_data/cleveland.txt",
                  col_names = FALSE)

# Examine
# str(heart)
# table(heart$disease.status)


#############################################################

## Cleaning
# Rename
names(heart) <- c("age", "sex", "chest.pain", "restingbp", "cholest", "fastingbs",
                  "restingec", "maxheartrate", "exercise.ang", "st.depress", "oldpeak",
                  "mag.vessels", "thal", "disease.status")

# Renumber Heart Disease Indicator
heart.dis <- heart %>% mutate(disease.status = case_when(disease.status == 0 ~ 0, 
                                                         disease.status > 0 ~ 1))

# Remove Na's in Mag.Vessels and Thal
heart.no.nas <- heart.dis %>% filter(mag.vessels != "?")
heart.no.nas.final <- heart.no.nas %>% filter(thal != "?")

# Factors
cols.to.change <- c(2, 3, 6, 7, 9, 11, 12, 13, 14)
heart.no.nas.final[, cols.to.change] <- lapply(heart.no.nas.final[, cols.to.change], factor)
# str(heart.no.nas.final)

# table(heart.no.nas.final$disease.status)

# Save New Data
write.table(heart.no.nas.final, file = "derived_data/pure_heart.txt", sep = ",",
            row.names = FALSE, col.names = TRUE)
