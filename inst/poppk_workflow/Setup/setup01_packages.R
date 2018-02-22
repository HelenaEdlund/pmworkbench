###################################################
# setup01_projectPackages.R
# 
# Author: 
# Created on: 
# Description: Install and load libraries
# Dependencies: None
###################################################

# ----------- Path to and installation of libraries -------------------
if(F){
  # All packages installed within the project for version control (set up via tidyproject)
  # Only run first time
  devtools::install_github("AstraZeneca/tidyproject")
  devtools::install_github("AstraZeneca/NMproject")
  devtools::install_github("AstraZeneca/pmworkbench")
  devtools::install_github("AstraZeneca/pmxplore")
  devtools::install_github("AstraZeneca/blueprint")
  
  install.packages("PKNCA", "pixiedust", 'xpose', dependencies = TRUE)
}

# Workflow related packages
library(NMproject) # also loads tidyproject
library(xpmworkbench)
library(xpmxplore)
library(blueprint)
library(knitr)
library(rprojroot)
library(pixiedust) # handles tables for latex
library(xpose) # handles tables for latex

# Tidyverse and plotting
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

# Misc
library(zoo)
library(PKNCA)
