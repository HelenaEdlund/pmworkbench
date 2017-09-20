###################################################
# setup01_projectPackages.R
# 
# Author: 
# Created on: 
# Description: Install and load libraries
# Dependencies: None
###################################################

# ----------- Path to and installation of libraries -------------------
# All packages installed within the project for version control (set up via tidyproject)
# Only run first time
if(F){
  devtools::install_github("tsahota/tidyproject")
  devtools::install_github("tsahota/NMproject")
#   devtools::install_github("AstraZeneca/pmworkbench?")
#   devtools::install_github("AstraZeneca/pmxplore")
  devtools::install_github("AstraZeneca/blueprint")
#   devtools::install_github("UUPharmacometrics/xpose")
  devtools::install_github("ronkeizer/vpc")
  
  install.packages("PKNCA", "pixiedust")
}

# load
library(tidyproject)
library(NMproject)
# library(pmxplore)
library(blueprint)
library(knitr)
library(rprojroot)
library(pixiedust)

library(grid)
library(gridExtra)
library(tibble)
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(purrr)
library(stringr)
library(GGally)
library(zoo)
library(xpose4)
library(PKNCA)
