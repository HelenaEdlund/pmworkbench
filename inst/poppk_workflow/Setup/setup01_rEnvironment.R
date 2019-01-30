###################################################
# setup01_rEnvironment.R
# 
# Author: 
# Created on: 
# Description: Prepare R environment by loading libraries and setting global options
# Dependencies: 
###################################################


# -----------------------------------------------
# Load needed packages
# -----------------------------------------------

# ----------- If needed: do this at first set up -------------------
if(F){
  devtools::install_github("tsahota/NMprojectAZ")
  devtools::install_github("AstraZeneca/pmworkbench")
  devtools::install_github("AstraZeneca/pmxplore")
  # need latest version of these two
  install.packages("GGally", repos = "https://cran.rstudio.com") 
  install.packages("rmarkdown", repos = "https://cran.rstudio.com") 
}

# Workflow related packages
library(rprojroot)
library(knitr)
# options(kableExtra.latex.load_packages=FALSE)
library(kableExtra)
library(NMprojectAZ) # also loads tidyproject
library(pmworkbench)
library(pmxplore)
library(tableone)

# Tidyverse and plotting
library(tidyverse)
library(gridExtra)
library(GGally)

# Misc
library(zoo)
library(PKNCA)


# -----------------------------------------------
# Settings for latex used in kableExtra as_image()
# -----------------------------------------------
latex_settings_standaloneAZ <- c(
  "\\usepackage{arydshln}",
  "\\usepackage[T1]{fontenc}",
  "\\renewcommand{\\rmdefault}{ftm}"
)

# -----------------------------------------------
# Settings for ggplot
# -----------------------------------------------
# White background in plots
theme_set(theme_bw()) # to be replaced with a azTheme
update_geom_defaults("point", list(shape = 1))
