get_numeric_dataset <- function(dataset) {
  return(dataset[sapply(dataset, is.numeric)])
}

get_numeric_list <- function(dataset) {
  # column names of the original dataset
  full_dataset_list <- colnames(dataset)
  
  # return the column names of the numeric dataset
  return(names(get_numeric_dataset(dataset)))
}

get_categorical_list <- function(dataset) {
  # get the column names of the numeric dataset
  numeric_list <- (get_numeric_list(dataset))
  
  # return the column names of the categorical dataset
  return(setdiff(colnames(dataset), numeric_list))
}

get_categorical_dataset <- function(dataset) {
  # return the categorical dataset
  return(dataset[, get_categorical_list(dataset)] )
}

get_excluded_features_list <- function(dataset) {
  categorical_ds <- get_categorical_dataset(dataset)
  
  # get the number of categories for each column
  cat_list_length <- apply(categorical_ds, 2, function(x) length(unique(x)))
  
  # return the variable categorical with more than 53 categories
  return(names(which(cat_list_length > 53)))
}

get_features_list <- function(dataset) {
  features <- setdiff(colnames(dataset), get_excluded_features_list(dataset)) 

  return(features)
}

get_features_dataset <- function(dataset) {
  return(dataset[,   get_features_list(dataset)] )
}
