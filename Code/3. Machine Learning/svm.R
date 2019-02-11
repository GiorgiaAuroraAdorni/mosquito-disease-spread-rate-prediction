if (!require("e1071"))
{
  install.packages("e1071")
}

if (!require("ROCR"))
{
  install.packages("ROCR")
}

library(e1071)
library(ROCR)

# source a set of functions
source("categorical.R")

# load dataset
dataset <- read.table("features_dataset_final.csv", header = TRUE, sep =",", dec = ".")

# get result values
target <- dataset$result

# keep only numeric columns
dataset <- dataset[, get_numeric_list(dataset)]

# set result values
dataset$result <- target

# remove columns with always same value
dataset <- dataset[vapply(dataset, function(x) length(unique(x)) > 1, logical(1L))]

# set fixed seeds for reproducibility
set.seed(108)

# split into Train and Validation sets: 80 - 20 (random)
proportion = 0.8
train <- sample(nrow(dataset), proportion * nrow(dataset), replace = FALSE)
trainset <- dataset[train,]
testset <- dataset[-train,]

svm_model <- NULL

if (file.exists("svm-radial.RData"))
{
  load("svm-radial.RData")
} else
{
  # train model
  tuned_cost <- 10
  tuned_gamma <- 0.01
  svm_model <- svm(result~., data=trainset, kernel="radial", cost=tuned_cost, gamma=tuned_gamma, probability=TRUE)
  
  # save model to file
  save(svm_model, file = "svm-radial.RData")
}

# test set predictions
pred_test <- predict(svm_model, testset, probability=TRUE)

# accuracy
accuracy <- sum(pred_test == testset$result) / nrow(testset)
print(accuracy)

# confusion matrix
confmat <- table(pred_test, testset$result)
print(confmat)

# Precision: tp/(tp+fp):
precision <- confmat[2,2]/sum(confmat[2,1:2])

# Recall: tp/(tp + fn):
recall <- confmat[2,2]/sum(confmat[1:2,2])

# F-Score: 2 * precision * recall /(precision + recall):
f.score <-  2 * precision * recall / (precision + recall)

pred_test.prob <- attr(pred_test, "probabilities")[,2]
pred_test.roc <- prediction(pred_test.prob, testset$result)
pred_test.perf <- performance(pred_test.roc, measure = "auc", x.measure = "cutoff")
pred_test.tpr <- performance(pred_test.roc, "tpr", "fpr")
plot(pred_test.tpr, colorize=T, main=paste("AUC:", (pred_test.perf@y.values)))
