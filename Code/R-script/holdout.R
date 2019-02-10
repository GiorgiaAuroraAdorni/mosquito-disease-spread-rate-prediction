holdout <- function(dataset) {
  # split into Train and Validation sets: 80 - 20 (random)
  set.seed(100)
  train <<- sample(nrow(dataset_with_only_features_and_target), 0.8*nrow(dataset_with_only_features_and_target), replace = FALSE)
  TrainSet <<- dataset_with_only_features_and_target[train,]
  ValidSet <<- dataset_with_only_features_and_target[-train,]
  
  # statistics
  summary(TrainSet)
  summary(ValidSet)
  
  # this model use as features all the columns except for that with more than 53 categories
  model1 <<- randomForest(result ~ ., data = TrainSet, importance = TRUE)
  
  #show tree
  getTree(model1, 1, labelVar=TRUE)
  
  reprtree:::plot.getTree(model1)
  
  # show model error
  pdf("HoldoutRF/model_error.pdf") 
  plot(model1, ylim=c(0,1.2))
  legend('topright', colnames(model1$err.rate), col=1:3, fill=1:3)
  dev.off() 
  
  # check importance variable
  importance(model1)   
  pdf("HoldoutRF/model_importance.pdf")
  varImpPlot(model1) 
  dev.off() 
  
  predTrain1 <<- predict(model1, TrainSet, type = "prob")
  predTrain1_True <<- predTrain1[,2]
  
  # checking classification accuracy
  capture.output(table(predTrain1_True, TrainSet$result), file = "HoldoutRF/train_accuracy.txt")
  acc_mT1 <<- mean(predTrain1_True == TrainSet$result)   
  capture.output(acc_mT1, file = "HoldoutRF/acc_mT1.txt")
  
  ## predicting on Validation set
  predValid1 <<- predict(model1, ValidSet, type = "prob")
  predValid1_True <<- predValid1[,2]
  
  # checking classification accuracy
  acc_mV1 <<- mean(predValid1_True == ValidSet$result)                    
  capture.output(acc_mV1, file = "HoldoutRF/acc_mV1.txt")
  capture.output(table(predValid1_True, ValidSet$result), file = "HoldoutRF/valid_accuracy.txt")
  
  precision_positive <<- list()
  recall_positive <<- list()
  f.score_positive <<- list()
  precision_negative <<- list()
  recall_negative <<- list()
  f.score_negative <<- list()
  
  # plot auc
  plot_auc(predTrain1_True, TrainSet$result, 1, "HoldoutRF/train") # train
  plot_auc(predValid1_True, ValidSet$result, 1, "HoldoutRF/validation") # valid
}
