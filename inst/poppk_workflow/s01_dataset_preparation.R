###################################################
# s01_dataset_preparation.R
# 
# Author: 
# Created on: 
# Description: Dataset preparation for R
# Dependencies: All scripts in ./Scritps/Setup 
###################################################

# The column names etc used below are default from the AZ data standards. 
# That is, it will need to be updated depending on the present data structure 
# Running example can be downloaded from: https://github.com/HelenaEdlund/Demo-PopPK-workflow-AZ


# -----------------------------------------------
# Prepare environment
# -----------------------------------------------
library(pmworkbench)
source_dir("./Scripts/Setup")
source_dir("./Scripts/Functions")



# -----------------------------------------------
# Read in dataset
# -----------------------------------------------
# Data should b eplaced in the SourceData dir and not modified
rawdata <- read.csv(file=file.path(directories[["source_data_dir"]], sourcedata_filename),
                    stringsAsFactors=F, na.strings = c(".", "NA", "-99"))

# remove C=C  (original data still in "rawdata")
data <- rawdata %>% filter(is.na(C) | C !="C")



# -----------------------------------------------
# Write function for addition of flags and additional 
#   variables for plotting and subsetting
# -----------------------------------------------
# these are just two examples, you can add anything you want available 

add_variables <- function(dataset){
  # 1. REGIMEN FLAG
  dataset$REGIMEN <- paste(as.character(dataset$DOSE), 
                           as.character(dataset$FREQ),
                           sep = " mg ")
  # sort(unique(dataset$REGIMEN))
  dataset$REGIMEN <- factor(dataset$REGIMEN)
  
  # 2. Single/first dose vs multiple dose (e.g. Day 1, vs steady state)
  dataset$DOSEFLAG <- rep(NA, nrow(dataset))
  
  dataset$DOSEFLAG[!is.na(dataset$OCC) & dataset$OCC==1] <- "Single dose"
  dataset$DOSEFLAG[!is.na(dataset$OCC) & dataset$OCC==2] <- "Multiple dose"
  dataset$DOSEFLAG <- factor(dataset$DOSEFLAG, levels = c("Single dose", "Multiple dose"))
  
  return(dataset)
}



# -----------------------------------------------
# Set the structure and add variables defined above
# -----------------------------------------------
data  <- 
  r_data_structure(data,
                   data_spec = file.path(directories[["source_data_dir"]], dataspec_filename))
# str(data)
data  <- add_variables(data)





# ------------------------------------------------------------------
#  Subsetting of data for graphical visualisation 
#  (used in EDA. Subsets saved as lists to work better with ggplot)
# ------------------------------------------------------------------
# 1: Baseline data for covariate evaluation 
# (this selects the first row of each ID, may need to be adjusted depending on dataset)
baseline_data <- data %>% 
  filter(!duplicated(NMSEQSID))

# 2: Subsets of concentration data
# 2.1 Exclude missing samples and dose events
conc_data <- data %>% 
  filter(EVID==0) %>% 
  filter(!(MDV==1 & is.na(BLQ))) %>% 
  # Plot LLOQ values in figures as DV=LLOQ/2
  mutate(DV = ifelse(BLQ == "BLQ", LLOQ/2, DV))   


# 2.2 List of subsets to generate pages with 12 individuals per page
conc_data_id_splits <- 
  ind_data_split(conc_data, id="NMSEQSID", 
                 n_per_page = 12)


# 2.3 List of subset by stratification (in this case study and dose)
conc_data <- conc_data %>% 
  mutate(STRATSPLIT = paste0("Study: ", OSTUDYID, ", Dose: ",  DOSE," mg"), 
         STRATSPLIT = factor(STRATSPLIT, 
                             levels = c("Study: d0000c0001, Dose: 100 mg",
                                        "Study: d0000c0001, Dose: 150 mg", 
                                        "Study: d0000c0002, Dose: 25 mg",
                                        "Study: d0000c0002, Dose: 300 mg")))

conc_data_strat_split <- 
  split(conc_data, conc_data$STRATSPLIT)




# -----------------------------------------------
# Save environment to use in next scripts
# -----------------------------------------------
save.image(file = file.path(directories[["scripts_dir"]], "s01.RData"))

