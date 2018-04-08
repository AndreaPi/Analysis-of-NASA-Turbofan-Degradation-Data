# a few useful functions for Exploratory Data Analysis

percent_missing <- function(X){
  # percent of NA elements in object x: return a scalar percent_missing
  
  if (!is.null(dim(x))) {
    
    percent_missing <- sum(is.na(x)) / prod(dim(x)) * 100
    
  } else {
    
    percent_missing <- mean(is.na(x)) * 100
    
  }
}

find_missing_columns <- function(dataframe) {
  # find columns in dataframe where all values are NA: return a logical vector 
  # index
  
  all_na <- function(x) all(is.na(x))
  index <- purrr::map_lgl(dataframe, ~ all_na(.))
  
}

iqr_na_rm <- function(x) IQR(x, na.rm = TRUE)
