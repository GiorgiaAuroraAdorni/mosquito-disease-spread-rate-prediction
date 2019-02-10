holdout <- function(dataset) {
  # split into Train and Validation sets: 80 - 20 (random)
  set.seed(100)
  train <<- sample(nrow(dataset), 0.8*nrow(dataset), replace = FALSE)
  TrainSet <<- dataset[train,]
  ValidSet <<- dataset[-train,]
  
  # statistics
  summary(TrainSet)
  summary(ValidSet)
  
  # this model use as features all the columns except for that with more than 53 categories
  model0 <<- randomForest(result ~ ., data = TrainSet, importance = TRUE)
  
  #show tree
  getTree(model0, 1, labelVar=TRUE)
  
  reprtree:::plot.getTree(model0)
  
  # show model error
  plot(model0, ylim=c(0,1.2))
  legend('topright', colnames(model0$err.rate), col=1:3, fill=1:3)
  
  # check importance variable
  importance(model0)        
  varImpPlot(model0) 
  
  predTrain0 <<- predict(model0, TrainSet, type = "prob")
  predTrain0_True <<- predTrain0[,2]
  
  # checking classification accuracy
  table(predTrain0_True, TrainSet$result) 
  acc_mT0 <<- mean(predTrain0_True == TrainSet$result)   
  
  ## predicting on Validation set
  predValid0 <<- predict(model0, ValidSet, type = "prob")
  predValid0_True <<- predValid0[,2]
  
  # checking classification accuracy
  acc_m0 <<- mean(predValid0_True == ValidSet$result)                    
  table(predValid0_True, ValidSet$result)
  
  # plot auc
  plot_auc(predTrain0_True, TrainSet$result, 1) # train
  plot_auc(predValid0_True, ValidSet$result, 1) # valid
}
