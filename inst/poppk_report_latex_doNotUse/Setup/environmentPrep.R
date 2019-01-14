###################################################
# environmentPrep.R
# 
# Author: Helena Edlund
# Created on: 2017-07-26
# Last modified on: 2017-08-18
# Purpose: R code to prepare the R environment and load all 
# variable names used within the report
# Dependencies: s07_NMDatasets.R
###################################################

# load packages
source(file.path("Scripts","Setup","setup01_projectPackages.R"))

# Load the nonmem dataset 
# (also includes setup03_projectVariables.R containing variables used throughout document)
load("./Scripts/s07.RData")

# To print delivery date as text
deliveryDateForPrint <- 
  format(as.Date(deliveryDate, format="%Y%m%d"), "%d %b %Y")

# Define number for base and final model (used in figures and tables to produce output)
BaseModelNo <- "010"
FinalModelNo <- "012"

# ------- Concentrations -------------
# Rawdata summaries
rawconcDataWithBLQ <- 
  rawdata %>% filter(EVID!=1 & !is.na(BLQ))
  
nTotIdRaw <- length(unique(rawdata$NMSEQSID))
nTotConcRaw <- nrow(rawdata)

## Included data (remove C=C or anything else removed with include/ignore)
# with blq
concDataWithBLQ <- nmData[is.na(nmData$C) & nmData$EVID!=1 & !is.na(nmData$BLQ), ] 
# if BLQ is missing, the record is a missing, not BLQ
percentBLQ <- 100*(nrow(concDataWithBLQ[!is.na(nmData$BLQ) & nmData$BLQ==1,]) / 
  nrow(concDataWithBLQ))

# excluding blq
concData <- nmData[is.na(nmData$C) & nmData$EVID!=1 & !is.na(nmData$BLQ) & nmData$BLQ==0,] 

# ------- Other variables used in text ------------- 
# include n patient and concentrations
nTotId <- length(unique(concData$ID))
nTotConc <- nrow(concData)
# nSamplesExcluded
# nBLQSamplesExcluded

# number of concentration per patient
tmp <- concData %>% 
  group_by(ID) %>% 
  summarize(n = length(DV))

nConcPerId <- paste0(median(tmp$n), " (", min(tmp$n), "--", max(tmp$n),")")

# number of studies
nStudies <- length(unique(data$OSTUDY))

# If developement and validation subsets were used
# nIdDevelopmentSubset
# nIdEvaluationSubset