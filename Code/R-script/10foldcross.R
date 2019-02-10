crossValidation <- function(dataset) {
  #Randomly shuffle the data
  set.seed(100)
  
  #Create 10 equally size folds
  folds <<- cut(seq(1, nrow(dataset)), breaks=10, labels=FALSE)
  
  model0 <<- list()
  acc_mT0 <<- list()
  acc_mV0 <<- list()
  precision_positive <<- list()
  recall_positive <<- list()
  f.score_positive <<- list()
  precision_negative <<- list()
  recall_negative <<- list()
  f.score_negative <<- list()
  
  #Perform 10 fold cross validation
  for(i in 1:10){
    #Segement your data by fold using the which() function 
    Crosstrain <<- which(folds==i,arr.ind=TRUE)
    CrossTrainSet <<- dataset[-Crosstrain, ]
    CrossValidSet <<- dataset[Crosstrain, ]
    
    #Use the test and train data partitions however you desire...
    
    # this model use as features all the columns except for that with more than 53 categories
    model0[[i]] <<- randomForest(result ~ ., data = CrossTrainSet, importance = TRUE)
    
    # show model error
    pdf(paste("CrossValidationRF/model_error_", i, ".pdf", sep=""))
    plot(model0[[i]], ylim=c(0,1.2))
    legend('topright', colnames(model0[[i]]$err.rate), col=1:3, fill=1:3)
    dev.off()
    
    ## check importance variable
    print(importance(model0[[i]]))   
    pdf(paste("CrossValidationRF/model_importance_", i, ".pdf", sep=""))
    varImpPlot(model0[[i]]) 
    dev.off()
    
    predTrain0 <<- predict(model0[[i]], CrossTrainSet, type = "prob")
    predTrain0_True <<- predTrain0[,2]
    
    # checking classification accuracy
    acc_mT0[i] <<- mean(predTrain0_True == CrossTrainSet$result) 
    capture.output(acc_mT0, file = paste("CrossValidationRF/acc_mT0_2", i, ".txt", sep=""))
    capture.output(table(predTrain0_True, CrossTrainSet$result), file = paste("CrossValidationRF/train_accuracy_", i, ".txt", sep=""))
    
    ## predicting on Validation set
    predValid0 <<- predict(model0[[i]], CrossValidSet, type = "prob")
    predValid0_True <<- predValid0[,2]
    
    # checking classification accuracy
    acc_mV0[i] <<- mean(predValid0_True == CrossValidSet$result) 
    capture.output(acc_mT0, file = paste("CrossValidationRF/acc_mV0_", i, ".txt", sep=""))
    capture.output(table(predValid0_True, CrossValidSet$result), file = paste("CrossValidationRF/valid_accuracy_", i, ".txt", sep=""))
    
    # plot auc
    plot_auc(predTrain0_True, CrossTrainSet$result, i, "CrossValidationRF/train") # train
    plot_auc(predValid0_True, CrossValidSet$result, i, "CrossValidationRF/validation") # valid
  }
}
