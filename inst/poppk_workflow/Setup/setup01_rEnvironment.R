###################################################
# setup01_rEnvironment.R
# 
# Author: 
# Created on: 
# Description: Prepare R environment by loading libraries and setting global options
# Dependencies: setup02_directories.R
###################################################

# ----------- If needed: do this at first set up -------------------
if(F){
  devtools::install_github("tsahota/NMprojectAZ")
  devtools::install_github("AstraZeneca/pmworkbench")
  devtools::install_github("AstraZeneca/pmxplore")
}

# Workflow related packages
library(rprojroot)
library(knitr)
library(NMproject) # also loads tidyproject
library(pmworkbench)
library(pmxplore)

# Tidyverse and plotting
library(tidyverse)
library(gridExtra)
library(GGally)

# Misc
library(zoo)
library(PKNCA)

