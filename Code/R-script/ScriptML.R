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

if(!require("Amelia")){
  install.packages("Amelia")
}
library(Amelia)

if(!require("pscl")){
  install.packages("pscl")
}
library(pscl)

if(!require("lattice")){
  install.packages("lattice")
}
library(lattice)

missmap(dataset, main = "Missing values vs observed")

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

#show tree
getTree(model0, 1, labelVar=TRUE)

if(!require("devtools")){
  install.packages("devtools")
}
library(devtools)
devtools::install_github('araastat/reprtree')


if(!require("reprtree")){
  install.packages("reprtree")
}
library(reprtree)

reprtree:::plot.getTree(model0)

# show model error
plot(model0, ylim=c(0,0.36))
legend('topright', colnames(model0$err.rate), col=1:3, fill=1:3)
## check importance variable
importance(model0)        
varImpPlot(model0) 

predTrain0 <- predict(model0, TrainSet, type = "class")

# checking classification accuracy
table(predTrain0, TrainSet$result) 

## predicting on Validation set
predValid0 <- predict(model0, ValidSet, type = "class")

# checking classification accuracy
acc_m0<- mean(predValid0 == ValidSet$result)                    
table(predValid0,ValidSet$result)
