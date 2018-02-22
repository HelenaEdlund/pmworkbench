###################################################
# s01_dataset_preparation.R
# 
# Author: 
# Created on: 
# Description: Dataset preparation for R
# Dependencies: Scripts in Setup 
###################################################

# The column names etc used below are default from the AZ data standards. 
# That is, it will need to be updated depending on the present data structure 
# Examples are given for the dataset provided in demo: 

# -----------------------------------------------
# Read in dataset
# -----------------------------------------------
# Data should b eplaced in the SourceData dir and not modified
rawdata <- read.csv(file=file.path(source_data_dir, sourcedata_filename),
                    stringsAsFactors=F, na.strings = c(".", "NA", "-99"))

# remove C=C  (original data still in "rawdata")
data <- rawdata %>% filter(is.na(C) | C !="C")

# -----------------------------------------------
# Write function for addition of flags and additional 
#   variables for plotting and subsetting
# -----------------------------------------------
add_variables <- function(dataset){
  # 1. REGIMEN FLAG
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
                          data_spec=file.path(source_data_dir, dataspec_filename))
data  <- add_variables(data)

# ------------------------------------------------------------------
#  Subsetting of data for graphical visualisation (used in EDA)
# ------------------------------------------------------------------
# 1. Baseline data for covariate evaluation 
# (this selects the first row of each ID, may need to be adjusted depending on dataset)
baseline_data <- data %>% 
  filter(!duplicated(OSID))

# 2. Subset with concentration data
# 2.1 Exclude missing samples and dose events
conc_data <- data %>% 
  filter(EVID==0) %>% 
  filter(!(MDV==1 & is.na(BLQ))) %>% 
  # Plot LLOQ values in figures as DV=LLOQ/2
  mutate(DV = ifelse(BLQ == "BLQ", LLOQ/2, DV))   

# 2.2 dataset without BLQ samples
conc_data_noBLQ <- conc_data %>% 
  filter(BLQ=="Non-BLQ")

# 2.3 List of subsets to generate pages with 12 individuals per page
conc_data_id_splits <- 
  ind_data_split(conc_data, id="NMSEQSID", 
                 n_per_page = 12)

# 2.4 List of subsets for study and dose group
conc_data <- conc_data %>% 
  mutate(STUDYDOSESPLIT = paste0("Study: ", OSTUDYID, ", Dose: ",  DOSE," mg"), 
         STUDYDOSESPLIT = factor(STUDYDOSESPLIT, 
                                 levels = c("Study: d0000c0001, Dose: 100 mg",
                                            "Study: d0000c0001, Dose: 150 mg", 
                                            "Study: d0000c0002, Dose: 25 mg",
                                            "Study: d0000c0002, Dose: 300 mg")))

conc_data_studydose_split <- 
  split(conc_data, conc_data$STUDYDOSESPLIT)

############ Save environment and then clear environment ############
# (need to have the datasetsets and the dataset names)
save.image(file = paste(scripts_dir, "s01.RData", sep="/"))
