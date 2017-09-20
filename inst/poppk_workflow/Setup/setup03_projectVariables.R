###################################################
# setup03_projectVariables.R
# 
# Author: Helena Edlund
# Created on: 2017-03-23
# Description: set variables used through out project
# Dependencies: None
###################################################

drugName <- "AZDTest"

analystName <- "A Pharmacometrican"
reviewerName <- "Another Pharmacometrican"
approverName <- "Someone from LT"
programmerName <- "QCP programming group" # or specific?

# Source dataset file name and delivery date
sourcedataFileName      <- "AZDTest_20170918.csv"
deliveryDate  <- 
  paste(str_extract_all(sourcedataFileName, pattern ="[:digit:]")[[1]], collapse = "")
dataSpecFileName        <- "qcpVariablesSpecification.csv"
  
# ------------------------------------------------------------------
#  List columns of the dataset to be used in dataset checkout and EDA
# ------------------------------------------------------------------

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

# Define the reported LLOQ
LLOQ <- 1

# ------------------------------------------------------------------
#  List lables and settings for plots used in EDA
# ------------------------------------------------------------------
res <- 300

# Reoccuring labels
labTAPD <- "Time after dose (h)"
labTAFD <- "Time after first dose (h)"
labConc <- "AZDTest concentration (ng/mL)"

# Reoccuring x-axis breaks
tapdBreaks <- c(0, 2, 4, 6, 8, 
               seq(from=12, to=200, by=6))
