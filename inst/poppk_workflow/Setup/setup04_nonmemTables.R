# ------------------------------------------------------------------
#  Temporary wrokaround for blueprint
# ------------------------------------------------------------------



# ------------------------------------------------------------------
#  Specify items to request in nonmem output tables
# ------------------------------------------------------------------
allTab     <- "ID TIME TAPD"
catCovTab  <- "SEXM RACE ETHNIC BRENAL DOSE FREQ OCC COHORT STUDYID"
contCovTab <- "AGE BWT BBMI BHT BEGFR BSCR"
evalTab    <- "DV LNDV AMT PRED RES WRES IPRED IRESI IWRESI CWRES NPDE"
otherTab   <- "EVID MDV CMT BLQ"

## clt file and bash file update functions 
cltFileUpdate <- 
  function(cltfile, estMethod="CONDITIONAL INTER", cov=T, run=modelNo){ 
    
    # allTab, evalTab, parameters, contCovTab, catCovTab and seed defined globally
    
    # Add estimation
    est <- paste0("$EST METHOD=",estMethod ,
                  " NOABORT MAXEVAL=9999 MSFO=MSF", run,"\n\n\n")
    
    cltfile <- paste(cltfile, est)
    
    if(cov){
      cltfile <- paste(cltfile, "$COV", "\n\n\n")
    }
    
    # Add table
    par <- paste(parms, collapse = " ")
    tab <- paste("$TABLE", allTab, evalTab,
                 otherTab, par, contCovTab, catCovTab,
                 "NOAPPEND ONEHEADER NOPRINT",
                 paste0("FILE=tab", modelNo), 
                 paste0("ESAMPLE=1000 SEED=", seed), # seed needed for npde
                 collapse= " ")
    cltfile <- paste(cltfile, tab)
    
    return(cltfile)
  }

# ------------------------------------------------------------------
#  Default psn execute and update function
# ------------------------------------------------------------------
psnExecuteTemp <- 
  "execute FileName.mod -directory=DirName -threads=1"

executeUpdate <- function(template, file=fileName, dir=dirName){
  line <- str_replace(template, "FileName.mod", file)
  line <- str_replace(line, "DirName", dir)
  # fileName and dirName set globally for each run
  return(line)
}

