if (!require("mxnet")) {
  cran <- getOption("repos")
  cran["dmlc"] <- "https://apache-mxnet.s3-accelerate.dualstack.amazonaws.com/R/CRAN/"
  options(repos = cran)
  
  install.packages("mxnet")
}

library(mxnet)
library(tictoc)
library(ROCR)

# source a set of functions
source("categorical.R")

# load input file
dataset <- read.table("features_dataset_final.csv", header = TRUE, sep =",", dec = ".")

target <- as.integer(as.logical(dataset$result))

# keep only numeric columns
dataset <- dataset[, get_numeric_list(dataset)]

# rescale all values to range [0, 1]
maxs <- apply(dataset, 2, max)
mins <- apply(dataset, 2, min)
dataset <- as.data.frame(scale(dataset)) #, center=mins, scale=maxs - mins))

# remove columns that always contain the same value
varying_columns <- (mins != maxs)
dataset <- dataset[, varying_columns]

# set fixed seeds for reproducibility
set.seed(42)
mx.set.seed(42)

mx.callback.train.stop <- function(tol = 1e-3, 
                                   mean.n = 1e2, 
                                   period = 100, 
                                   min.iter = 1000
) {
  function(iteration, nbatch, env, verbose = TRUE) {
    if (nbatch == 0 & !is.null(env$metric)) {
      continue <- TRUE
      acc.train <- env$metric$get(env$train.metric)$value
      if (is.null(env$acc.log)) {
        env$acc.log <- acc.train
      } else {
        if ((abs(acc.train - mean(tail(env$acc.log, mean.n))) < tol &
             abs(acc.train - max(env$acc.log)) < tol &
             iteration > min.iter) | 
            acc.train == 1) {
          cat("Training finished with final accuracy: ", 
              round(acc.train * 100, 2), " %\n", sep = "", file="crossval.log", append=TRUE)
          continue <- FALSE 
        }
        env$acc.log <- c(env$acc.log, acc.train)
      }
    }
    if (iteration %% period == 0) {
      cat("[", iteration,"]"," training accuracy: ", 
          round(acc.train * 100, 2), " %\n", sep = "") 
    }
    return(continue)
  }
}

# create cross validation folds
fold_count = 10
folds <- cut(seq(1, nrow(dataset)), breaks=fold_count, labels=FALSE)

for (i in 1:fold_count) {
  cat("Cross Validation fold ", i, "\n", file="crossval.log", append=TRUE)
  
  is_train = (folds != i)
  
  train.x <- data.matrix(dataset[is_train,])
  train.y <- target[is_train]
  
  test.x <- data.matrix(dataset[!is_train,])
  test.y <- target[!is_train]
  
  tic("Tempo di addestramento:")
  
  # define the neural network architecture
  model <- mx.mlp(
    train.x,
    train.y,
    array.layout = "rowmajor",
    hidden_node = c(30, 15),
    out_node = 2,
    dropout = 0.5,
    activation = "sigmoid",
    out_activation = "softmax",
    num.round = 2000,
    array.batch.size = 128,
    learning.rate = 0.01,
    momentum = 0.9,
    eval.metric = mx.metric.accuracy,
    epoch.end.callback = mx.callback.train.stop(),
    ctx = mx.cpu(0)
  )
  
  # evaluate the performance on the test set
  preds = predict(model, test.x, array.layout="rowmajor")
  pred.label = max.col(t(preds)) - 1
  pred.probs = t(preds)[,2]
  
  pred.label = factor(pred.label, levels=0:1)
  confmat = table(pred.label, test.y)
  
  accuracy = mean(pred.label == test.y)
  cat("Test accuracy:", accuracy, "\n", file="crossval.log", append=TRUE)
  
  toc()
  
  # Precision: tp/(tp+fp):
  precision = confmat[2,2]/sum(confmat[2,1:2])
  
  # Recall: tp/(tp + fn):
  recall = confmat[2,2]/sum(confmat[1:2,2])
  
  # F-Score: 2 * precision * recall /(precision + recall):
  f.score =  2 * precision * recall / (precision + recall)
  
  cat("Confmat: ", confmat, "\n", file="crossval.log", append=TRUE)
  cat("Precision: ", precision, "\n", file="crossval.log", append=TRUE)
  cat("Recall: ", recall, "\n", file="crossval.log", append=TRUE)
  cat("F-Measure: ", f.score, "\n", file="crossval.log", append=TRUE)
  
  # ROC
  preds = ROCR::prediction(labels = test.y, predictions=pred.probs)
  
  perf.rocr = performance(preds, measure = "auc", x.measure = "cutoff")
  perf.tpr.rocr = performance(preds, "tpr", "fpr")
  
  pdf(paste("roc-", i, ".pdf", sep=""))
  plot(perf.tpr.rocr, colorize = T, main = paste("AUC:", (perf.rocr@y.values)))
  dev.off()
  
  cat("\n", file="crossval.log", append=TRUE)
}
