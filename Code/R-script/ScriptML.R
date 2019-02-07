# source a set of functions
source("categorical.R")

# set working directory
#setwd("G:/My Drive/appunti/Gio ed Elia/Magistrale/Primo Semestre/Data Technology and Machine Learning/Progetto/Dataset/WIP/Giorgia/code/R-script")
setwd("~/MosquitoDiseaseSpreadRatePrediction/Code/R-script")

# load input file
dataset <- read.table("data-1549540504937.csv", header = TRUE, sep =",", dec = ".")
dataset_with_only_features_and_target <- get_features_dataset(dataset)

# some statistics ...
head(dataset)
str(dataset)
summary(dataset)

# split into Train and Validation sets: 80 - 20 (random)
set.seed(100)
train <- sample(nrow(dataset_with_only_features_and_target), 0.8*nrow(dataset_with_only_features_and_target), replace = FALSE)
TrainSet <- dataset_with_only_features_and_target[train,]
ValidSet <- dataset_with_only_features_and_target[-train,]
summary(TrainSet)
summary(ValidSet)

if(!require("randomForest")){
  install.packages("randomForest")
}
library(randomForest)

# this model use as features all the columns except for that with more than 53 categories
model0 <- randomForest(result ~ ., data = TrainSet, importance = TRUE)
model0

## Check importance variable
importance(model0)        
varImpPlot(model0) 

predTrain0 <- predict(model0, TrainSet, type = "class")
# Checking classification accuracy
table(predTrain0, TrainSet$result) 

## Predicting on Validation set
predValid0 <- predict(model0, ValidSet, type = "class")
# Checking classification accuracy
acc_m0<- mean(predValid0 == ValidSet$result)                    
table(predValid0,ValidSet$result)
