# set working directory
#setwd("G:/My Drive/appunti/Gio ed Elia/Magistrale/Primo Semestre/Data Technology and Machine Learning/Progetto/Dataset/WIP/Giorgia/code/R-script")
setwd("~/MosquitoDiseaseSpreadRatePrediction/Code/R-script")

# source a set of functions
source("categorical.R")
source("utilities.R")
source("data_exploration.R")
source("holdout.R")
source("10foldcross.R")

# Libraries
libraries_list <- c("DataExplorer", "Amelia", "pscl", "devtools", "lattice", "reprtree", "randomForest", "ROCR", "cowplot", "ggplot2")
import_libaries(libraries_list)

devtools::install_github('araastat/reprtree')
require(tidyverse)

# Load input file
dataset <- read.table("features_dataset_final.csv", header = TRUE, sep =",", dec = ".")
dataset_with_only_features_and_target <- get_features_dataset(dataset)

# some statistics
save_data_exploration_plot(dataset) 

head <- head(dataset)
str <- str(dataset)
summary <- summary(dataset)

capture.output(head, file = "DataExplorer/head.txt")
capture.output(str(dataset), file = "DataExplorer/str.txt")
capture.output(summary, file = "DataExplorer/summary.txt")

holdout(dataset_with_only_features_and_target)
crossValidation(dataset_with_only_features_and_target)
