###################################################
# setup01_projectPackages.R
# 
# Author: Helena Edlund
# Created on: 2017-08-04
# Description: Install and load libraries
# Dependencies: None
###################################################

# ----------- Path to and installation of libraries -------------------
# All packages installed within the project for version control (set up via tidyproject)
# Only run first time
if(F){
  devtools::install_github("tsahota/tidyprojectAZ")
  devtools::install_github("tsahota/NMprojectAZ")
  devtools::install_github("AstraZeneca/blueprint")
#   devtools::install_github("AstraZeneca/xplore")
  devtools::install_github("ronkeizer/vpc")
  
  install.packages("PKNCA", "pixiedust")
  # "glue" ? 
  
  # devtools::install_github("HelenaEdlund/tmp-data-review", 
  #                          auth_token = Sys.getenv("GITHUB_PAT"))
}

# load 
library(tidyprojectAZ)
library(NMprojectAZ)
library(knitr)
library(rprojroot)
library(grid)
library(gridExtra)
library(tibble) # load before ggplot to get the newest version loaded
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
library(pixiedust)
library(vcd)
library(azrdatareview)
# library(xplore)
library(blueprint)
