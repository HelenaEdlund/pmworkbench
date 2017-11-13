###################################################
# setup03_projectVariables.R
# 
# Author: 
# Created on: 
# Description: set variables used throughout workflow
# Dependencies: None
###################################################

# Note, this script is a little bit of a mixbag for reporting and workflow. 
# Should probably be splitted into the appropriate parts. 

# The column names etc used below are default from the AZ data standards. 
# That is, it will need to be updated depending on the present data structure   

# ------------------------------------------------------------------
#  People
# ------------------------------------------------------------------
analystName <- "Analyst"
reviewerName <- "Reviewer"
approverName <- "Approver"
programmerName <- "Programmer" 

# ------------------------------------------------------------------
#  Data
# ------------------------------------------------------------------

# --------------------
#  Source dataset
# --------------------
sourcedataFileName      <- "filename_deliverydate.csv"
deliveryDate  <- "deliverydate"
# # or extract from filename it contains deliverydate:
# deliveryDate  <- 
#   paste(str_extract_all(sourcedataFileName, pattern ="[:digit:]")[[1]], collapse = "")
dataSpecFileName        <- "dataSpecFileName.csv" # used by pmxplore::r_data_structure

# --------------------
#  Drug and lloq
# --------------------
drugName <- "DrugName"
DVunit <- "ng/mL"
LLOQ <- 1
# molecularWeight <- # g/mol

# --------------------
#  Columns in data (used in dataset checkout and EDA)
# --------------------
# Define variables as they are expected to be based on protocol and data spec
ostudies <- c("d0000c0001","d0000c0002")   # original names of studies that should be included
studies  <- c(1,2)            # numeric version 
cohorts  <- c(1,2)            # cohorts 
# parts  <- c(1001,1002)      # parts 
doses    <- c(25,100, 150, 300)         # doses 

# Define columns in dataset (and what type)
studyRelatedCols <- 
  c("OSTUDYID", "STUDYID", "COHORT","DOSE", "NMSEQSID", "OSID")
# "PART"

# Continuous columns (not including covariates)
numericCols <- c('TAFD','TAPD','DV','LNDV')

## Character/Categorical columns (not including covariates)
factorCols <- c('C','AMT','OCC','MDV','CMT','BLQ','EVID',"FREQ", "COMMENT")

## Lists of continuous and categorical covariates (which may change with time)
# included these as examples here - they are not actually changing
catCov <- c("BRENAL")
contCov <- c("BWT","BBMI")

## List of baseline continuous and categorical covariates (should not change with time)
bCatCov  <- c("SEXM","RACE","ETHNIC","BRENAL")
bContCov <- c("AGE","BSCR","BEGFR","BWT","BHT","BBMI")

allCols <- c(studyRelatedCols, numericCols, factorCols, bCatCov, bContCov)

# ------------------------------------------------------------------
#  List lables and settings for plots used in EDA
# ------------------------------------------------------------------
# Reoccuring labels
labTAPD <- "Time after dose (h)"
labTAFD <- "Time after first dose (h)"
labConc <- paste0(drugName," concentration (", DVunit,")")

# Re-occuring x-axis breaks
tapdBreaks <- c(0, 2, 4, 6, 8, seq(from=12, to=200, by=6))
