# source a set of functions
source("categorical.R")

# set working directory
#setwd("G:/My Drive/appunti/Gio ed Elia/Magistrale/Primo Semestre/Data Technology and Machine Learning/Progetto/Dataset/WIP/Giorgia/code/R-script")
setwd("~/MosquitoDiseaseSpreadRatePrediction/Code/R-script")

if(!require("randomForest")){
  install.packages("randomForest")
}
library(randomForest)

# load input file
dataset <- read.table("features_dataset_final.csv", header = TRUE, sep =",", dec = ".")
dataset_with_only_features_and_target <- get_features_dataset(dataset)

#Randomly shuffle the data
set.seed(100)

#Create 10 equally size folds
folds <- cut(seq(1,nrow(dataset_with_only_features_and_target)),breaks=10,labels=FALSE)

Models = list()
TrainPredictions =  list()
ValidPredictions = list()
Accs = list()

#Perform 10 fold cross validation
for(i in 1:10){
  #Segement your data by fold using the which() function 
  Crosstrain <- which(folds==i,arr.ind=TRUE)
  CrossTrainSet <- dataset_with_only_features_and_target[-Crosstrain, ]
  CrossValidSet <- dataset_with_only_features_and_target[Crosstrain, ]
  
  #Use the test and train data partitions however you desire...
  
  # this model use as features all the columns except for that with more than 53 categories
  model0 <- randomForest(result ~ ., data = CrossTrainSet, importance = TRUE)
  model0
  Models[[length(Models)+1]] = model0
  
  # show model error
  plot(model0, ylim=c(0,1.2))
  legend('topright', colnames(model0$err.rate), col=1:3, fill=1:3)
  ## check importance variable
  importance(model0)        
  varImpPlot(model0) 
  
  predTrain0 <- predict(model0, CrossTrainSet, type = "class")
  TrainPredictions[[length(TrainPredictions)+1]] = predTrain0
  
  # checking classification accuracy
  table(predTrain0, CrossTrainSet$result) 
  
  ## predicting on Validation set
  predValid0 <- predict(model0, CrossValidSet, type = "class")
  ValidPredictions[[length(ValidPredictions)+1]] = predValid0
  
  # checking classification accuracy
  acc_m0 <- mean(predValid0 == CrossValidSet$result) 
  Accs[[length(Accs)+1]] = acc_m0
  table(predValid0,CrossValidSet$result)
}
