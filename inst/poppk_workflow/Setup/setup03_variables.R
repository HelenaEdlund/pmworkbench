###################################################
# setup03_variables.R
# 
# Author: 
# Created on: 
# Description: Set variables used throughout workflow
# Dependencies: setup01_rEnvironment.R
###################################################

# ------------------------------------------------------------------
#  People
# ------------------------------------------------------------------
# Uncomment and use if using Latex for report writing
# people <- list(
#   analyst_name = "Analyst", 
#   reviewer_name = "Reviewer",
#   approver_name = "Approver",
#   programmer_name = "Programmer") 




# ------------------------------------------------------------------
#  Data
# ------------------------------------------------------------------

# The column names etc used below are default from the AZ data standards. 
# That is, it will need to be updated depending on the present data structure   

# -------------------- 
#  Source dataset
# --------------------
sourcedata_filename      <- "filename_deliverydate.csv"
dataspec_filename        <- "dataVariablesSpecification.csv" 
# used by pmxplore::r_data_structure

# delivery_date  <- "deliverydate"
# # or extract from filename it contains deliverydate:
delivery_date  <-
  sourcedata_filename %>% 
  str_extract_all(pattern ="(_).*\\d") %>% 
  str_replace_all(pattern ="_", "") %>% 
  unlist %>% 
  as.numeric

# --------------------
#  Drug and lloq
# --------------------
dv_name <- "drugname"
dv_unit <- "ng/mL"
LLOQ <- 1
# molecularWeight <- # g/mol

# --------------------
#  Columns in data (used in dataset checkout and EDA)
# --------------------
# Define variables as they are expected to be based on protocol and data spec
ostudies <- c("study1","study2")   # original names of studies that should be included
studies  <- c(1,2)                 # numeric version 
cohorts  <- c(1,2)                 # cohorts 
parts    <- c(1001,1002)           # parts 
doses    <- c(25, 100, 150, 300)   # doses 


# Define columns in dataset (and what type they are)
# (pre-defined columns are examples - modify as needed)

list_columns <- function(){
  
  study_related <- c("OSTUDYID", "STUDYID", "COHORT","PART","DOSE","NMSEQSID","OSID")
  
  # Continuous columns (not including covariates)
  numeric <- c('TAFD','TAPD','DV',"LNDV","DAY")
  
  # Character/Categorical columns (not including covariates)
  factors <- c('C','AMT','OCC','MDV','CMT','BLQ','EVID',"FREQ","COMMENT")
  
  # Baseline continuous and categorical covariates
  base_cat_cov  <- c("SEXM","RACE")
  base_cont_cov <- c("AGE","BCRCL","BWT")
  
  # Time-varyint continuous and categorical covariates
  cat_cov <- c("RENAL")
  cont_cov <- c("WT","BMI")
  
  # This list should contain all columns of your dataset
  cols <- list(study_related = study_related, 
               numeric = numeric, 
               factors = factors, 
               cat_cov = cat_cov,
               cont_cov = cont_cov,
               base_cat_cov = base_cat_cov,
               base_cont_cov = base_cont_cov)
  
  all_cols <- unlist(cols, use.names = F)
  
  cols <- c(cols, list(all = all_cols))
  
  return(cols)
}

columns <- list_columns()




# ------------------------------------------------------------------
#  List lables and settings for plots used in EDA
# ------------------------------------------------------------------
# Reoccuring labels
labs_TAPD <- "Time after dose (h)"
labs_TAFD <- "Time after first dose (h)"
labs_conc <- paste0(dv_name," concentration (", dv_unit,")")

# Re-occuring x-axis breaks
tapd_breaks <- c(0, 2, 4, 6, 8, seq(from=12, to=200, by=6))






# ------------------------------------------------------------------
#  Save environment 
# ------------------------------------------------------------------
# this will also contain the list of directories since its executed before this script
save.image(file = file.path("Scripts",'Setup',"setup_variables.RData"))
