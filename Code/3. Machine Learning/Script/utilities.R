# Import of libraries
import_libaries <- function(libraries_list) {
    if(!require("easypackages")) {
      install.packages("easypackages")
    }
    library(easypackages)
    packages(libraries_list)
    libraries(libraries_list)
}

# Plot auc fucntion and save 
plot_auc <- function(prediction, label, i, type, prediction_class) {
  
  confmat <<- table(prediction_class, label)
  
  # Precision: tp/(tp+fp):
  precision_positive[i] <<- confmat[2,2]/sum(confmat[2,1:2])
  
  # Recall: tp/(tp + fn):
  recall_positive[i] <<- confmat[2,2]/sum(confmat[1:2,2])
  
  # F-Score: 2 * precision * recall /(precision + recall):
  f.score_positive[i] <<- 2 * precision_positive[[i]] * recall_positive[[i]] / (precision_positive[[i]] + recall_positive[[i]])
  
  # Precision: tn/(tn+fn):
  precision_negative[i] <<- confmat[1,1]/sum(confmat[1,1:2])
  
  # Recall: tn/(tn + fp):
  recall_negative[i] <<- confmat[1,1]/sum(confmat[1:2,1])
  
  # F-Score: 2 * precision * recall /(precision + recall):
  f.score_negative[i] <<- 2 * precision_negative[[i]]  * recall_negative[[i]]  / (precision_negative[[i]]  + recall_negative[[i]])
  
  # accuracy
  accuracy[i] <<- (confmat[2,2] + confmat[1,1]) / (confmat[1,1] + confmat[1,2] + confmat[2,1] + confmat[2,2])
  
  # auc
  roc_preds <<- ROCR::prediction(labels = as.numeric(label), predictions = as.numeric(prediction))
  
  perf.rocr <<- performance(roc_preds, measure = "auc", x.measure = "cutoff")
  perf.tpr.rocr <<- performance(roc_preds, "tpr", "fpr")
  
  pdf(paste(type, "/auc_", i, ".pdf", sep="")) 
  plot(perf.tpr.rocr, colorize = T, main = paste("AUC:", (perf.rocr@y.values)))
  dev.off() 
  
  capture.output(confmat, file = paste(type, "/confmat_", i, ".txt", sep=""))
  capture.output(accuracy[i], file = paste(type, "/accuracy_", i, ".txt", sep=""))
  capture.output(recall_positive[i], file = paste(type, "/recall_positive_", i, ".txt", sep=""))
  capture.output(recall_negative[i], file = paste(type, "/recall_negative_", i, ".txt", sep=""))
  capture.output(f.score_positive[i], file = paste(type, "/f.score_positive_", i, ".txt", sep=""))
  capture.output(f.score_negative[i], file = paste(type, "/f.score_negative_", i, ".txt", sep=""))
  capture.output(precision_positive[i], file = paste(type, "/precision_positive_", i, ".txt", sep=""))
  capture.output(precision_negative[i], file = paste(type, "/precision_negative_", i, ".txt", sep=""))
}
