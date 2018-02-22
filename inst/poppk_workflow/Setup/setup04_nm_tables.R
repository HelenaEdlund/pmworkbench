# ------------------------------------------------------------------
#  Temporary workaround for blueprint
# ------------------------------------------------------------------


# ------------------------------------------------------------------
#  Specify items to request in nonmem output tables
# ------------------------------------------------------------------
nm_tab <- list(
  all      = "ID TIME TAPD",
  cat_cov  = "SEXM RACE ETHNIC BRENAL DOSE FREQ OCC COHORT STUDYID",
  cont_cov = "AGE BWT BBMI BHT BEGFR BSCR",
  eval     = "DV LNDV AMT PRED RES WRES IPRED IRESI IWRESI CWRES NPDE",
  other    = "EVID MDV CMT BLQ")

## clt file and bash file update functions 
# (parms and seed defined globally for each run)
cltfile_update <- 
  function(cltfile, run=model_no, p=parms, s=seed, 
           nm_vars=nm_tab, 
           est_method="CONDITIONAL INTER", cov=T){
    
    # Add estimation
    est <- paste0("$EST METHOD=", est_method ,
                  " NOABORT MAXEVAL=9999 MSFO=MSF", run,"\n\n\n")
    
    cltfile <- paste(cltfile, est)
    
    if(cov){
      cltfile <- paste(cltfile, "$COV", "\n\n\n")
    }
    
    # Add table
    par <- paste(p, collapse = " ")
    tab <- paste("$TABLE", 
                 paste(unlist(nm_vars), collapse = " "), 
                 par,
                 "NOAPPEND ONEHEADER NOPRINT",
                 paste0("FILE=tab", model_no), 
                 paste0("ESAMPLE=1000 SEED=", s), # seed needed for npde
                 collapse= " ")
    cltfile <- paste(cltfile, tab)
    
    return(cltfile)
  }

# ------------------------------------------------------------------
#  Default psn execute and update function
# ------------------------------------------------------------------
psn_execute_template <- 
  "execute filename.mod -directory=dirname -threads=1"

execute_update <- function(template, file=filename, dir=dir_name){
  line <- str_replace(template, "filename.mod", file)
  line <- str_replace(line, "dirname", dir)
  # filename and dirname set globally for each run
  return(line)
}

