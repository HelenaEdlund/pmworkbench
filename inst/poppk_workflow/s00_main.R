###################################################
# s00_main.R
# 
# Author: 
# Created on: 
# Description: Make file for population PK analysis workflow
# Dependencies: None
###################################################
# When starting a new project, run make_project() and open the 
# project with the OpenProject.Rproj

# All programs that needs to be executed are "sourced" below in the order they should be 
# executed. 

# Function to source all scripts in one directory
sourceDir <- function(path, trace=TRUE, ...) {
  for(nm in list.files(path, pattern = "[.][Rr]$")){
    if(trace) cat(nm,":")
    source(file.path(path, nm), ...)
    if(trace) cat("\n")
  }
}

# ----------- Project setup -------------------
sourceDir("./Scripts/Setup")
# sourceDir("./Scripts/Functions")
# tidyproject checks
Renvironment_info()
check_session()


# ----------- Read in source data and set stucture for R ------------------
source(file = file.path(scriptsDir, "s01_datasetPrep.R"))


# The .Rmd scripts below generate a .html file with the output. 
# If you also want graphs and tables to be outputted as separate files, 
# set printResults to TRUE

# ----------- Dataset checkout ------------------
# Go through the script to make sure all relevant columns are included and checked
rmarkdown::render(input=file.path("Scripts","s02_datasetReview.Rmd"))

# ----------- Summarize excluded data ------------------
rmarkdown::render(input=file.path("Scripts","s03_summaryOfExcludedData.Rmd"), 
                  params = list(printResults=F))

# ----------- Exploratory Data Analysis ------------------
rmarkdown::render(input = file.path("Scripts", "s04_EDACovariates.Rmd"), 
                  params = list(printResults=F))
rmarkdown::render(input = file.path("Scripts", "s05_EDAConcTime.Rmd"), 
                  params = list(printResults=F))
rmarkdown::render(input = file.path("Scripts", "s06_EDAPkLinearity.Rmd"), 
                  params = list(printResults=F))

# The error: 
# Error in unlockBinding("params", <environment>) : no binding for "params"
# Can be ignored. It's because we need to delete "params" before the scripts is done.

# ----------- Preparation of NONMEM datasets ------------------
# If printCSV is true the script outputs the dataset(s) to "DerivedData", 
# otherwise it just saves the datasets and the names of the datasets s07.RData
rmarkdown::render(input =file.path("Scripts","s07_NMDatasets.Rmd"), 
                  params = list(printCSV=T))





## To be continued with model development and reporting ##



