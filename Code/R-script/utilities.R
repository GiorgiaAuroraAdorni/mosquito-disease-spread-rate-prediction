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
plot_auc <- function(prediction, label, i) {
  
  confmat <<- table(prediction, label)
  
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
  
  # auc
  roc_preds <<- ROCR::prediction(labels = as.numeric(label), predictions = as.numeric(prediction))
  
  perf.rocr <<- performance(roc_preds, measure = "auc", x.measure = "cutoff")
  perf.tpr.rocr <<- performance(roc_preds, "tpr", "fpr")
  
  plot(perf.tpr.rocr, colorize = T, main = paste("AUC:", (perf.rocr@y.values)))
}
