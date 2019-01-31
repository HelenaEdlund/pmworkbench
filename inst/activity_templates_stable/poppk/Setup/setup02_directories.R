###################################################
# setup02_directories.R
# 
# Author: 
# Created on: 
# Description: Define all directories relative to the top level dir
#              This folder structure are the default for the AZ knowledge management
# Dependencies: None
###################################################

# This function is kept here to make it easy to add/remove
# Kept in a function to not crowd global environment with all dir names separately

list_directories <- function(make = T){
  # Directories at activity level
  # do not remove the leading ".", it will cause problems with latex/knitr)
  scripts_dir       <- file.path(".", "Scripts")
  derived_data_dir  <- file.path(".", "DerivedData")
  model_dir         <- file.path(".", "Models")
  report_dir        <- file.path(".", "Report")
  results_dir       <- file.path(".", "Results")
  sim_dir           <- file.path(".", "Simulations")
  source_data_dir   <- file.path(".", "SourceData")
  
  ##sub-directories
  #script_dir
  setup_dir         <- file.path(scripts_dir, "Setup")
  functions_dir     <- file.path(scripts_dir, "Functions")
  
  # #model_dir - no need for this example
  # base_model_dir      <- file.path(model_dir, "BaseModel")
  # covariate_model_dir <- file.path(model_dir, "CovariateModel")
  
  #result_dir
  res_other_dir       <- file.path(results_dir, "Other")
  res_eda_dir         <- file.path(results_dir, "ExploratoryDataAnalysis")
  res_base_model_dir  <- file.path(results_dir, "BaseModel")
  res_cov_model_dir   <- file.path(results_dir, "CovariateModel")
  
  # # Uncomment if using latex+knitr for report writing
  #report_dir 
  # rep_setup_dir <- file.path(report_dir, "Setup")
  # rep_sections_dir <- file.path(report_dir, "sections")
  # rep_appendicies_dir <- file.path(report_dir, "appendices")
  # rep_images_dir <- file.path(report_dir, "images")
  
  ##list_all_directories
  all_dir <-
    list(
      scripts_dir = scripts_dir,
      derived_data_dir = derived_data_dir,
      model_dir = model_dir,
      report_dir = report_dir,
      results_dir = results_dir,
      sim_dir = sim_dir,
      source_data_dir = source_data_dir,
      setup_dir = setup_dir,
      functions_dir = functions_dir,
    # base_model_dir = base_model_dir,
    # covariate_model_dir = covariate_model_dir,
      res_other_dir = res_other_dir,
      res_eda_dir = res_eda_dir,
      res_base_model_dir = res_base_model_dir,
      res_cov_model_dir = res_cov_model_dir #,
    # # Uncomment if using latex+knitr for report writing
    # rep_setup_dir = rep_setup_dir,
    # rep_sections_dir = rep_sections_dir,
    # rep_appendicies_dir = rep_appendicies_dir,
    # rep_images_dir = rep_images_dir
    )
  
  if(make){
    # make directories not already created 
    lapply(all_dir, pmworkbench::mkdirp)
  }
  
  # return list of all directories
  return(all_dir)
} 

directories <- list_directories()
