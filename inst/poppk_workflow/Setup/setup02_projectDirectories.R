# Replaced by proj_dirs.R


# ###################################################
# # setup02_projectDirectories.R
# # 
# # Author: 
# # Created on: 
# # Description: Define all project directories relative to the top level dir
# #              This folder structure are the default for the AZ knowledge management
# # Dependencies: None
# ###################################################
# 
# # Directories at activity level 
# # (do not remove the leading "." , it will casuse problems with latex/knitr)
# scriptsDir      <- file.path(".","Scripts") 
# derivedDataDir  <- file.path(".", "DerivedData")
# modelDir        <- file.path(".", "Models")
# reportDir       <- file.path(".", "Report")
# resultsDir      <- file.path(".", "Results")
# simDir          <- file.path(".", "Simulations")
# sourceDataDir   <- file.path(".", "SourceData")
# 
# ## Sub-directories
# # Script dir
# setupDir            <- file.path(scriptsDir,"Setup")
# functionsDir        <- file.path(scriptsDir,"Functions")
# 
# # Model dir
# baseModelDir        <- file.path(modelDir, "BaseModel")        
# covariateModelDir   <- file.path(modelDir, "CovariateModel")   
# 
# # Result dir
# resOtherDir         <- file.path(resultsDir, "Other")
# resEDADir           <- file.path(resultsDir, "ExploratoryDataAnalysis")
# resBaseModelDir     <- file.path(resultsDir, "BaseModel")
# resCovModelDir      <- file.path(resultsDir, "CovariateModel")
# 
# # Report dir
# repSetupDir         <- file.path(reportDir, "Setup")
# repSectionsDir      <- file.path(reportDir, "Sections")
# repAppendiciesDir   <- file.path(reportDir, "Appendices")
# repImagesDir        <- file.path(reportDir, "Images")
# 
# ## list all directories
# allDir <- c(scriptsDir, derivedDataDir, modelDir, reportDir, resultsDir, simDir, sourceDataDir, 
#             setupDir, functionsDir,  
#             baseModelDir, covariateModelDir,
#             resOtherDir, resEDADir, resBaseModelDir, resCovModelDir, 
#             repSetupDir,repSectionsDir,repAppendiciesDir,repImagesDir)
# 
# ## Create any non-existing directories
# myDirCreate <- function(directories){
#   for(i in directories){
#     if(!file.exists(i)){
#       dir.create(i)
#     }
#   }
# }
# 
# myDirCreate(allDir)
