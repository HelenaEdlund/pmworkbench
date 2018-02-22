###################################################
# setup03_projectVariables.R
# 
# Author: 
# Created on: 
# Description: Set variables used throughout workflow
# Dependencies: None
###################################################

# Note, this script is a little bit of a mixbag for reporting and workflow. 
# Should probably be splitted into the appropriate parts. 

# The column names etc used below are default from the AZ data standards. 
# That is, it will need to be updated depending on the present data structure   

# ------------------------------------------------------------------
#  People
# ------------------------------------------------------------------
all_people <- list(
  analyst_name = "Analyst", 
  reviewer_name = "Reviewer",
  approver_name = "Approver",
  programmer_name = "Programmer") 

# ------------------------------------------------------------------
#  Data
# ------------------------------------------------------------------

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
drug_name <- "drugname"
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
# parts  <- c(1001,1002)           # parts 
doses    <- c(25, 100, 150, 300)   # doses 

# Define columns in dataset (and what type)
cols_study_related <- 
  c("OSTUDYID", "STUDYID", "COHORT","DOSE", "NMSEQSID", "OSID")
# "PART"

# Continuous columns (not including covariates)
cols_numeric <- c('TAFD','TAPD','DV','LNDV')

## Character/Categorical columns (not including covariates)
cols_factors <- c('C','AMT','OCC','MDV','CMT','BLQ','EVID',"FREQ", "COMMENT")

## Lists of continuous and categorical covariates (which may change with time)
# included these as examples here - they are not actually changing
cols_cat_cov <- c("BRENAL")
cols_cont_cov <- c("BWT","BBMI")

## List of baseline continuous and categorical covariates (should not change with time)
base_cat_cov  <- c("SEXM","RACE","ETHNIC","BRENAL")
base_cont_cov <- c("AGE","BSCR","BEGFR","BWT","BHT","BBMI")

# This vector should contain all columns of your dataset
all_cols <- c(cols_study_related, cols_numeric, cols_factors, 
              cols_cat_cov,cols_cont_cov,base_cat_cov,base_cont_cov)

# ------------------------------------------------------------------
#  List lables and settings for plots used in EDA
# ------------------------------------------------------------------
# Reoccuring labels
labs_TAPD <- "Time after dose (h)"
labs_TAFD <- "Time after first dose (h)"
labs_conc <- paste0(drug_name," concentration (", dv_unit,")")

# Re-occuring x-axis breaks
tapd_breaks <- c(0, 2, 4, 6, 8, seq(from=12, to=200, by=6))
