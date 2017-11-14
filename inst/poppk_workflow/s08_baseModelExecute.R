###################################################
# s08_baseModelExecute.R
# Author: 
# Created: 
#    
# Description: Generate and execute NONMEM runs for base model development
# Dependencies: s07_NMDatasets.Rmd
###################################################

# ------------------------------------------------------------------
#  Prepare environment
# ------------------------------------------------------------------
# load generated NM datasets
load(file.path("Scripts", "s07.RData"))

# ------------------------------------------------------------------
#  Load blueprint and templates for nonmem 
# ------------------------------------------------------------------
blueprint <- Blueprint$new("nonmem")
templates <- load_templates("nonmem")
models <- available_models("nonmem")

# ------------------------------------------------------------------
#  Define path to data relative the base model dir
# ------------------------------------------------------------------
derivedDataDirRelBase <- paste0("../.", derivedDataDir)

# ------------------------------------------------------------------
#  Settings for plots
# ------------------------------------------------------------------
theme_set(theme_bw())
update_geom_defaults("point", list(shape = 1))

# ------------------------------------------------------------------
#  Units
# ------------------------------------------------------------------
# Drug concentrations are in in mg/L, doses in mg and time(=TAFD) in hours. 
# Hence, Ka in h-1, CL & Q in L/h, V1 & V2 in L, scaling=V
unitDV <- "mg/L"
unitTime <- "h"
unitKA <- "h-1"
unitCL <- "L/h"
unitV  <- "L"
# Used in comment convention ; Parameter name ; Unit ; Transformtion

# ------------------------------------------------------------------
#  Model development
# ------------------------------------------------------------------

# initiating templates with dataset
one_cmt <- blueprint %>% 
  use_template(templates$compartmental) %>%
  model_type(models$one_cmt_oral) %>% 
  # Add data
  with_data(nmData) %>%
  from_path(file.path(derivedDataDirRelBase, nmDataName)) 

two_cmt <- blueprint %>% 
  use_template(templates$compartmental) %>%
  model_type(models$two_cmt_oral) %>% 
  # Add data
  with_data(nmData) %>%
  from_path(file.path(derivedDataDir, nmDataName)) 

two_cmt_rate <- blueprint %>% 
  use_template(templates$compartmental) %>%
  model_type(models$two_cmt_oral) %>% 
  # Add data
  with_data(nmDataComb) %>%
  from_path(file.path(derivedDataDir, nmDataNameComb)) 


# ------------------------------------------------------------------
#  1. Number of compartments
# ------------------------------------------------------------------

# ---------------
#  Run001
# ---------------
modelNo <- "001"

if(modelNo=="001"){
  
  # properties
  description <- "1 cmt model, 1st order abs, BSV on CL"
  basedOn <- NA
  
  # output and dir to run
  fileName   <- paste0("run", modelNo)
  dirName    <- paste0("dir_run", modelNo)
  
  # Select seed to use for NPDEs
  seed <- format(Sys.time(), "%y%m%d%H%M")
  
  # build nonmem control file
  run001 <- one_cmt %>% 
    # add parameters
    parameters(
      KA = parameter(0.8, lower_bound=0,
                     comment = paste0("KA ;", unitKA, ";")),
      CL = parameter(200, lower_bound = 0.01,
                     comment=paste0("CL ;", unitCL, ";")),
      V = parameter(400, lower_bound = 0, 
                    comment=paste0("V ;",unitV, ";"))) %>%
    hierarchies(CL = 0.04) %>% 
    residual_error(PROP = 0.1)
  
  # tweak for adding tables and comments (temporary)
  parms <- names(run001$get_params())
  run001rend <- render(run001)
  
  run001rend <- cltFileUpdate(run001rend)
  run001rend <- add_comments(run001rend, refRun = basedOn,
                             description = description, author = analystName)
  
  # --- write file to cluster
  write(run001rend, file=file.path(baseModelDir, fileName))
  # Discuss with Tarj: 
  # build in as an option in nmproject that warns you about over-writing the file? 
  
  # Command line update
  psnExecute <- executeUpdate(psnExecuteTemp, fileName, dirName) 
  # note: nmproject does not work with clean=3
  
  # --- Add to run using nmproject
  mod1 <- nm(cmd = psnExecute, 
             run_in = baseModelDir)
  run(mod1, quiet=F)
}


# ---------------
#  Run002
# ---------------
modelNo <- "002"

if(modelNo=="002"){ 
  
  # properties
  description <- "1 cmt model, 1st order abs, BSV on CL and V"  
  basedOn <- "001"
  
  # output and dir to run
  fileName   <- paste0("run", modelNo)
  dirName    <- paste0("dir_run", modelNo)
  
  # Select seed to use for NPDEs
  seed <- format(Sys.time(), "%y%m%d%H%M")
  
  run002 <- run001 %>% 
    hierarchies(CL = 0.1, V = 0.1) 
  
  # tweak for adding tables and comments (temporary)
  parms <- names(run002$get_params())
  run002rend <- render(run002)
  
  run002rend <- cltFileUpdate(run002rend)
  run002rend <- add_comments(run002rend, refRun = basedOn,
                             description = description, author = analystName)
  
  # --- write file to cluster
  write(run002rend, file=file.path(baseModelDir, fileName)) 
  
  # command line update
  psnExecute <- executeUpdate(psnExecuteTemp, fileName, dirName)  
  
  # --- Add to run using nmproject
  mod2 <- nm(cmd = psnExecute, 
             run_in = baseModelDir)
  run(mod2, quiet=F)
}

# ---------------
#  Run003
# ---------------
modelNo <- "003"

if(modelNo=="003"){ 
  
  # properties
  description <- "1 cmt model, 1st order abs, BSV on CL and V in block"
  basedOn <- "002"
  
  # output and dir to run
  fileName   <- paste0("run", modelNo)
  dirName    <- paste0("dir_run", modelNo)
  
  # Select seed to use for NPDEs
  seed <- format(Sys.time(), "%y%m%d%H%M")
  
  run003 <- one_cmt %>% 
    # add parameters
    parameters(
      KA = parameter(0.8, lower_bound=0,
                     comment = paste0("KA ;", unitKA, ";")),
      CL = parameter(200, lower_bound = 0.01,
                     comment=paste0("CL ;", unitCL, ";")),
      V = parameter(400, lower_bound = 0, 
                    comment=paste0("V ;",unitV, ";"))) %>%
    hierarchies(b1 = block(0.1, 0.05, 0.1, 
                           param_names = c("CL", "V"))) %>% 
    residual_error(PROP = 0.1)
  
  # tweak for adding tables and comments (temporary)
  parms <- names(run003$get_params())
  run003rend <- render(run003)
  
  # update tables
  run003rend <- cltFileUpdate(run003rend)
  run003rend <- add_comments(run003rend, refRun = basedOn,
                             description = description, author = analystName)
  
  # --- write file to cluster
  write(run003rend, file=file.path(baseModelDir, fileName))
  
  # command line update
  psnExecute <- executeUpdate(psnExecuteTemp, fileName, dirName)  
  
  # --- Add to run using nmproject
  mod3 <- nm(cmd = psnExecute, 
             run_in = baseModelDir)
  run(mod3, quiet=F)
}

# ---------------
#  Run003+M3
# ---------------
# Not implemented in blueprint yet
modelNo <- "003m3"

if(modelNo=="003m3"){
  
  # properties
  # description <- "run 003 with M3 for BLQ"
  # basedOn <- NA  
  #
  # output and dir to run
  #   fileName   <- paste0("run", modelNo)
  #   dirName    <- paste0("dir_run", modelNo)
  #   
  #   # Select seed to use for NPDEs
  #   seed <- format(Sys.time(), "%y%m%d%H%M")
  #   
  #   run003m3 <- one_cmt %>% 
  #     # add parameters
  #     parameters(
  #       KA = parameter(0.8, lower_bound=0,
  #                      comment = paste0("KA ;", unitKA, ";")),
  #       CL = parameter(200, lower_bound = 0.01,
  #                      comment=paste0("CL ;", unitCL, ";")),
  #       V = parameter(400, lower_bound = 0, 
  #                     comment=paste0("V ;",unitV, ";"))) %>%
  #     hierarchies(b1 = block(0.1, 0.05, 0.1, 
  #                            param_names = c("CL", "V"))) # %>% 
  # #     residual_error(PROP = 0.1)
  #   
  #   # tweak for adding tables and comments (temporary)
  #   parms <- names(run003m3$get_params())
  #   run003m3rend <- render(run003m3)
  #   
  #   # update tables
  #   run003m3rend <- cltFileUpdate(run003m3rend)
  #   run003m3rend <- add_comments(run003m3rend, refRun = basedOn,
  #                              description = description, author = analystName)
  #   
  #   # --- write file to cluster
  #   write(run003m3rend, file=file.path(baseModelDir, fileName))
  #   
  #   # command line update
  #   psnExecute <- executeUpdate(psnExecuteTemp, fileName, dirName)  
  #   
  #   # --- Add to run using nmproject
  #   mod3m3 <- nm(cmd = psnExecute, 
  #              run_in = baseModelDir)
  #   run(mod3m3, quiet=F)
}

# ---------------
#  Run004
# ---------------
modelNo <- "004"

if(modelNo=="004"){
  
  # properties
  description <- "2 cmt model with 1st order abs, BSV on CL only"
  basedOn <- "001"
  
  # output and dir to run
  fileName   <- paste0("run", modelNo)
  dirName    <- paste0("dir_run", modelNo)
  
  # Select seed to use for NPDEs
  seed <- format(Sys.time(), "%y%m%d%H%M")
  
  # build nonmem control file
  run004 <- two_cmt %>% 
    # add parameters
    parameters(
      KA = parameter(5, lower_bound=0,
                     comment = paste0("KA ;", unitKA, ";")),
      CL = parameter(140, lower_bound = 0.01,
                     comment=paste0("CL ;", unitCL, ";")),
      V2 = parameter(200, lower_bound = 0, 
                     comment=paste0("V2 ;",unitV, ";")),
      Q = parameter(15, lower_bound = 0, 
                    comment=paste0("Q ;",unitCL, ";")),
      V3 = parameter(250, lower_bound = 0, 
                     comment=paste0("V3 ;",unitV, ";"))) %>%
    hierarchies(CL = 0.04) %>% 
    residual_error(PROP = 0.1)
  
  # tweak for adding tables and comments (temporary)
  parms <- names(run004$get_params())
  run004rend <- render(run004)
  
  # update tables
  run004rend <- cltFileUpdate(run004rend)
  run004rend <- add_comments(run004rend, refRun = basedOn,
                             description = description, author = analystName)
  
  # --- write file to cluster
  write(run004rend, file=file.path(baseModelDir, fileName))
  
  # command line update
  psnExecute <- executeUpdate(psnExecuteTemp, fileName, dirName)  
  
  # --- Add to run using nmproject
  mod4 <- nm(cmd = psnExecute, 
             run_in = baseModelDir)
  run(mod4, quiet=F)
}

# ---------------
#  Run005
# ---------------
modelNo <- "005"

if(modelNo=="005"){ 
  
  # properties
  description <- "2 cmt model with 1st order abs, BSV on CL and V"
  basedOn <- "004" # and 002 (1 cmt)
  
  # output and dir to run
  fileName   <- paste0("run", modelNo)
  dirName    <- paste0("dir_run", modelNo)
  
  # Select seed to use for NPDEs
  seed <- format(Sys.time(), "%y%m%d%H%M")
  
  run005 <- run004 %>% 
    hierarchies(CL = 0.1, V = 0.1) 
  
  # tweak for adding tables and comments (temporary)
  parms <- names(run005$get_params())
  run005rend <- render(run005)
  
  # update tables
  run005rend <- cltFileUpdate(run005rend)
  run005rend <- add_comments(run005rend, refRun = basedOn,
                             description = description, author = analystName)
  
  # --- write file to cluster
  write(run005rend, file=file.path(baseModelDir, fileName))
  
  # command line update
  psnExecute <- executeUpdate(psnExecuteTemp, fileName, dirName)  
  
  # --- Add to run using nmproject
  mod5 <- nm(cmd = psnExecute, 
             run_in = baseModelDir)
  run(mod5, quiet=F)
}

# ---------------
#  Run006
# ---------------
modelNo <- "006"

if(modelNo=="006"){ 
  
  # properties
  description <- "2 cmt model with 1st order abs, BSV on CL and V in block"
  basedOn <- "005" # and 003 (1 cmt)
  
  # output and dir to run
  fileName   <- paste0("run", modelNo)
  dirName    <- paste0("dir_run", modelNo)
  
  # Select seed to use for NPDEs
  seed <- format(Sys.time(), "%y%m%d%H%M")
  
  # build nonmem control file
  run006 <- two_cmt %>% 
    # add parameters
    parameters(
      KA = parameter(5, lower_bound=0,
                     comment = paste0("KA ;", unitKA, ";")),
      CL = parameter(140, lower_bound = 0.01,
                     comment=paste0("CL ;", unitCL, ";")),
      V2 = parameter(200, lower_bound = 0, 
                     comment=paste0("V2 ;",unitV, ";")),
      Q = parameter(15, lower_bound = 0, 
                    comment=paste0("Q ;",unitCL, ";")),
      V3 = parameter(250, lower_bound = 0, 
                     comment=paste0("V3 ;",unitV, ";"))) %>%
    hierarchies(b1 = block(0.1, 0.05, 0.1, 
                           param_names = c("CL", "V2"))) %>% 
    residual_error(PROP = 0.1)
  
  # tweak for adding tables and comments (temporary)
  parms <- names(run006$get_params())
  run006rend <- render(run006)
  
  # update tables
  run006rend <- cltFileUpdate(run006rend)
  run006rend <- add_comments(run006rend, refRun = basedOn,
                             description = description, author = analystName)
  
  # --- write file to cluster
  write(run006rend, file=file.path(baseModelDir, fileName))
  
  # command line update
  psnExecute <- executeUpdate(psnExecuteTemp, fileName, dirName)  
  
  # --- Add to run using nmproject
  mod6 <- nm(cmd = psnExecute, 
             run_in = baseModelDir)
  run(mod6, quiet=F)
}

# ---------------
#  Run006+M3
# ---------------
# Not implemented yet


# ------------------------------------------------------------------
#  2. Investigate different absorption models
# ------------------------------------------------------------------
## Notes: Continue with a 2-compartment model, and BSV on CL and V in block(2)

# ---------------
#  Run007
# ---------------
modelNo <- "007"

if(modelNo=="007"){
  
  # properties
  description <- "Run 006 with lag time"
  basedOn <- "006"
  
  # output and dir to run
  fileName   <- paste0("run", modelNo)
  dirName    <- paste0("dir_run", modelNo)
  
  # Select seed to use for NPDEs
  seed <- format(Sys.time(), "%y%m%d%H%M")
  
  run007 <- run006 %>% 
    parameters(ALAG1 = parameter(0.05, lower_bound=0,
                                 comment = paste0("ALAG;", unitTime, ";")))
  
  # tweak for adding tables and comments (temporary)
  parms <- names(run007$get_params())
  run007rend <- render(run007)
  
  # update tables
  run007rend <- cltFileUpdate(run007rend)
  run007rend <- add_comments(run007rend, refRun = basedOn,
                             description = description, author = analystName)
  
  # --- write file to cluster
  write(run007rend, file=file.path(baseModelDir, fileName))
  
  # command line update
  psnExecute <- executeUpdate(psnExecuteTemp, fileName, dirName)  
  
  # --- Add to run using nmproject
  mod7 <- nm(cmd = psnExecute, 
             run_in = baseModelDir)
  run(mod7, quiet=F)
} 

# ---------------
#  Run007+M3
# ---------------
# Not implemented yet


# ---------------
#  Run008
# ---------------
modelNo <- "008"

if(modelNo=="008"){ 
  
  # properties
  description <- "2 cmt with zero and first order abs, BSV on CL and V in block"
  basedOn <- "006" 
  
  # output and dir to run
  fileName   <- paste0("run", modelNo)
  dirName    <- paste0("dir_run", modelNo)
  
  # Select seed to use for NPDEs
  seed <- format(Sys.time(), "%y%m%d%H%M")
  
  # build nonmem control file
  run008 <- two_cmt %>% 
    # add parameters
    parameters(
      D1 = parameter(0.15, lower_bound=0,
                     comment = paste0("D1 ;", unitTime, ";")),
      KA = parameter(5, lower_bound=0,
                     comment = paste0("KA ;", unitKA, ";")),
      CL = parameter(140, lower_bound = 0.01,
                     comment=paste0("CL ;", unitCL, ";")),
      V2 = parameter(200, lower_bound = 0, 
                     comment=paste0("V2 ;",unitV, ";")),
      Q = parameter(15, lower_bound = 0, 
                    comment=paste0("Q ;",unitCL, ";")),
      V3 = parameter(250, lower_bound = 0, 
                     comment=paste0("V3 ;",unitV, ";"))) %>%
    hierarchies(b1 = block(0.1, 0.05, 0.1, 
                           param_names = c("CL", "V2"))) %>% 
    residual_error(PROP = 0.1)
  
  # tweak for adding tables and comments (temporary)
  parms <- names(run008$get_params())
  run008rend <- render(run008)
  
  # update tables
  run008rend <- cltFileUpdate(run008rend)
  run008rend <- add_comments(run008rend, refRun = basedOn,
                             description = description, author = analystName)
  
  # --- write file to cluster
  write(run008rend, file=file.path(baseModelDir, fileName))
  
  # command line update
  psnExecute <- executeUpdate(psnExecuteTemp, fileName, dirName)  
  
  # --- Add to run using nmproject
  mod8 <- nm(cmd = psnExecute, 
             run_in = baseModelDir)
  run(mod8, quiet=F)
} 

# ---------------
#  Run008+M3
# ---------------


# ---------------
#  Run009
# ---------------
modelNo <- "009"

if(modelNo=="009"){ 
  
  # properties
  description <- "2 cmt with lag time, zero and first order abs, BSV on CL and V in block"
  basedOn <- "008"
  
  # output and dir to run
  fileName   <- paste0("run", modelNo)
  dirName    <- paste0("dir_run", modelNo)
  
  # Select seed to use for NPDEs
  seed <- format(Sys.time(), "%y%m%d%H%M")
  
  run009 <- run008 %>% 
    parameters(ALAG1 = parameter(0.10, lower_bound=0,
                                 comment = paste0("ALAG;", unitTime, ";")))
  
  # tweak for adding tables and comments (temporary)
  parms <- names(run009$get_params())
  run009rend <- render(run009)
  
  # update tables
  run009rend <- cltFileUpdate(run009rend)
  run009rend <- add_comments(run009rend, refRun = basedOn,
                             description = description, author = analystName)
  
  # --- write file to cluster
  write(run009rend, file=file.path(baseModelDir, fileName))
  
  # command line update
  psnExecute <- executeUpdate(psnExecuteTemp, fileName, dirName)  
  
  # --- Add to run using nmproject
  mod9 <- nm(cmd = psnExecute, 
             run_in = baseModelDir)
  run(mod9, quiet=F)
} 

# ---------------
#  Run010
# ---------------
modelNo <- "010"

if(modelNo=="010"){ 
  
  # properties
  description <- "2 cmt with zero and first order abs, BSV on CL and V in block, BSV D1"
  basedOn <- "008"
  
  # output and dir to run
  fileName   <- paste0("run", modelNo)
  dirName    <- paste0("dir_run", modelNo)
  
  # Select seed to use for NPDEs
  seed <- format(Sys.time(), "%y%m%d%H%M")
  
  run010 <- run008 %>% 
    hierarchies(D1=0.1)
  
  # tweak for adding tables and comments (temporary)
  parms <- names(run010$get_params())
  run010rend <- render(run010)
  
  # update tables
  run010rend <- cltFileUpdate(run010rend)
  run010rend <- add_comments(run010rend, refRun = basedOn,
                             description = description, author = analystName)
  
  # --- write file to cluster
  write(run010rend, file=file.path(baseModelDir, fileName))
  
  # command line update
  psnExecute <- executeUpdate(psnExecuteTemp, fileName, dirName)  
  
  # --- Add to run using nmproject
  mod10 <- nm(cmd = psnExecute, 
              run_in = baseModelDir)
  run(mod10, quiet=F)
} 

# ------------------------------------------------------------------
#  3. Investigate different residual error models
# ------------------------------------------------------------------

# ---------------
#  Run011
# ---------------
modelNo <- "011"

if(modelNo=="011"){ 
  
  # properties
  description <- "2 cmt with zero and first order abs, BSV on CL and V in block and D1, prop and add RSV"
  basedOn <- "010"
  
  # output and dir to run
  fileName   <- paste0("run", modelNo)
  dirName    <- paste0("dir_run", modelNo)
  
  # Select seed to use for NPDEs
  seed <- format(Sys.time(), "%y%m%d%H%M")
  
  run011 <- run010 %>% 
    residual_error(ADD = 0.5)
  
  # tweak for adding tables and comments (temporary)
  parms <- names(run010$get_params())
  run011rend <- render(run011)
  
  # update tables
  run011rend <- cltFileUpdate(run011rend)
  
  # --- write file to cluster
  write(run011rend, file=file.path(baseModelDir, fileName))
  
  # command line update
  psnExecute <- executeUpdate(psnExecuteTemp, fileName, dirName)  
  
  # --- Add to run using nmproject
  mod11 <- nm(cmd = psnExecute, 
              run_in = baseModelDir)
  run(mod11, quiet=F)
} 

