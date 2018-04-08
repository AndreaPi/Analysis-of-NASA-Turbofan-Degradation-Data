library(knitr)
library(readr)
library(ggplot2)
library(tools)
library(magrittr)
library(skimr)
library(dplyr)
library(tidyr)
library(viridis)

# chunk options
opts_chunk$set(warning = FALSE,
               message = FALSE,
               echo    = FALSE,
               fig.align  = "center",
               fig.width  = 15,
               fig.height = 12)

# set random seed for reproducibility
set.seed(1024)

# tibble printing options
options(tibble.print_max = 100, tibble.print_min = 100)

# Setup plot environment
textSize <- 15
theme_set(theme_gray(base_size = textSize))

# Set data directory
data_dir <- file.path("..", "data")

# source useful functions
source("EDA_functions.r")

# Setup skimr::skim defaults
skim_with(numeric = list(p0 = NULL, p25 = NULL, p75 = NULL, p100 = NULL, 
                         hist = NULL, iqr = iqr_na_rm),
          integer = list(p0 = NULL, p25 = NULL, p75 = NULL, p100 = NULL, 
                         hist = NULL, iqr = iqr_na_rm))
skim_format(.levels = list(max_char = 6))



