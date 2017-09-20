###################################################
# s01_datasetPrep.R
# 
# Author: 
# Created on: 
# Description: Dataset preparation for R
# Dependencies: setup01_projectPackages.R 
#               setup02_projectDirectories.R 
#               setup03_projectVariables.R 
###################################################

# The column names etc used below are default from the AZ data standards. 
# That is, it will need to be updated depending on the present data structure 

# -----------------------------------------------
# Read in dataset
# -----------------------------------------------
# Data should b eplaced in the SourceData dir and not modified
rawdata <- read.csv(file=paste(sourceDataDir, sourcedataFileName, sep="/"),
                    stringsAsFactors=F, na.strings = c(".","NA", "-99"))

# remove C=C  (original data still in "rawdata")
data <- rawdata[is.na(rawdata$C) | rawdata$C !="C", ]

# -----------------------------------------------
# Write function for addition of flags and additional 
#   variables for plotting and subsetting
# -----------------------------------------------
add_variables <- function(dataset){
  # 1. REGIMEN
  dataset$REGIMEN <- paste(as.character(dataset$DOSE), 
                           as.character(dataset$FREQ),
                           sep = " mg ")
  # sort(unique(dataset$REGIMEN))
  dataset$REGIMEN <- factor(dataset$REGIMEN)
  
  # 2. Combined NMSEQSID and OCC (used for plotting time after dose. Remove if no occ given)
  dataset$ID.OCC <- rep(NA, nrow(dataset))
  # summary(dataset$OCC[!is.na(dataset$OCC)])
  # unique(paste(dataset$NMSEQSID[!is.na(dataset$OCC)], dataset$OCC[!is.na(dataset$OCC)], sep='.'))
  dataset$ID.OCC[!is.na(dataset$OCC)] <- 
    paste(dataset$NMSEQSID[!is.na(dataset$OCC)], dataset$OCC[!is.na(dataset$OCC)], sep='.')
  dataset$ID.OCC <- factor(as.numeric(dataset$ID.OCC))
  
  # Example for a dose flag: 
  # 3. Single/first dose vs multiple dose (Day 1, vs 8)
  dataset$DOSEFLAG <- rep(NA, nrow(dataset))

  dataset$DOSEFLAG[!is.na(dataset$OCC) & dataset$OCC==1] <- "Single dose"
  dataset$DOSEFLAG[!is.na(dataset$OCC) & dataset$OCC==2] <- "Multiple dose"
  dataset$DOSEFLAG <- factor(dataset$DOSEFLAG, levels = c("Single dose", "Multiple dose"))

  return(dataset)
}

# -----------------------------------------------
# Set the structure and add variables
# -----------------------------------------------
data  <- r_data_structure(data, 
                          data_spec=file.path(sourceDataDir, dataSpecFileName))
data  <- add_variables(data)
str(data)
# ------------------------------------------------------------------
#  Subsetting of data for graphical visualisation (used in EDA)
# ------------------------------------------------------------------
## Exclude missing samples and dose events
concData <- data[data$EVID==0, ]
concData <- concData[!(concData$MDV==1 & is.na(concData$BLQ)), ]
concDataNoBLQ <- concData[concData$BLQ=="Non-BLQ", ] # dataset without BLQ samples

## Handle LLOQ values in figures
concData$DV[concData$BLQ=="BLQ"] <- LLOQ/2

## List of data subsets to generate 12 plots per page for individual data
concDataIdSplits <- 
  ind_data_split(concData, n_per_page = 12, id="NMSEQSID")

## Baseline data for covariate evaluation 
# (this selects the first row of each ID, may need to be adjusted depending on dataset)
baselineData <- data[!duplicated(data$OSID), ]

## List of data subsets for study and dose group
# This is an example section which work with the simulated dataset provided in: XXX
concData$StudyDoseSplit <- 
  paste0("Study: ", concData$OSTUDYID, 
         ", Dose: ",  concData$DOSE," mg")
concData$StudyDoseSplit <- 
  factor(concData$StudyDoseSplit, 
         levels = c("Study: d0000c0001, Dose: 100 mg",
                    "Study: d0000c0001, Dose: 150 mg", 
                    "Study: d0000c0002, Dose: 25 mg",
                    "Study: d0000c0002, Dose: 300 mg"))
concDataStudyDoseSplit <- split(concData, concData$StudyDoseSplit)

############ Save environment and then clear environment ############
# (need to have the datasetsets and the dataset names)
save.image(file = paste(scriptsDir, "s01.RData", sep="/"))

## Empty environment
rm(list = ls())
