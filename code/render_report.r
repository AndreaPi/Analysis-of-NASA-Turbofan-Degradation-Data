library(rmarkdown)
code_dir <- "code" 
filename <- "NASA_Engine_Degradation_Data_Analysis"
rmd_filename <- file.path(code_dir, paste0(filename, ".Rmd"))
output_dir <- "output"
output_reldir <- file.path("..", output_dir)
render(rmd_filename, output_dir = output_dir, params = list(output_dir = output_reldir),
       envir = new.env())
# need full path names for URL browsing
project_dir <- getwd()
html_absolute_path <- file.path(project_dir, output_dir, paste0(filename, ".html"))
report_URL <- paste0("file://", html_absolute_path)
browseURL(report_URL)