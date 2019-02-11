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

# split into Train and Validation sets: 80 - 20 (random)
proportion = 0.8
is_train <- sample(nrow(dataset), proportion*nrow(dataset), replace = FALSE)

train.x <- data.matrix(dataset[is_train,])
train.y <- target[is_train]

test.x <- data.matrix(dataset[-is_train,])
test.y <- target[-is_train]

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
              round(acc.train * 100, 2), " %\n", sep = "")
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

tic("Tempo di addestramento:")

model_name = "models/mlp-sigmoid.RData"

if (file.exists(model_name)) {
  load(model_name)
  model <- mx.unserialize(model_data)
} else {
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
  
  model_data <- mx.serialize(model)
  save(model_data, file=model_name)
}

# evaluate the performance on the test set
preds = predict(model, test.x, array.layout="rowmajor")
pred.label = max.col(t(preds)) - 1
pred.probs = t(preds)[,2]
confmat = table(pred.label, test.y)

accuracy = mean(pred.label == test.y)
print(accuracy)

toc()

# Precision: tp/(tp+fp):
precision = confmat[2,2]/sum(confmat[2,1:2])

# Recall: tp/(tp + fn):
recall = confmat[2,2]/sum(confmat[1:2,2])

# F-Score: 2 * precision * recall /(precision + recall):
f.score =  2 * precision * recall / (precision + recall)

cat("Precision: ", precision, "\n")
cat("Recall: ", recall, "\n")
cat("F-Measure: ", f.score, "\n")

preds = ROCR::prediction(labels = test.y, predictions=pred.probs)

perf.rocr = performance(preds, measure = "auc", x.measure = "cutoff")
perf.tpr.rocr = performance(preds, "tpr", "fpr")

pdf(paste(model_name, "test_roc.pdf"))
plot(perf.tpr.rocr, colorize = T, main = paste("AUC:", (perf.rocr@y.values)))
dev.off()

preds = predict(model, train.x, array.layout="rowmajor")
pred.probs = t(preds)[,2]

# training ROC
preds = predict(model, train.x, array.layout="rowmajor")
pred.probs = t(preds)[,2]

preds = ROCR::prediction(labels = train.y, predictions=pred.probs)

perf.rocr = performance(preds, measure = "auc", x.measure = "cutoff")
perf.tpr.rocr = performance(preds, "tpr", "fpr")

pdf(paste(model_name, "training_roc.pdf"))
plot(perf.tpr.rocr, colorize = T, main = paste("AUC:", (perf.rocr@y.values)))
dev.off()
