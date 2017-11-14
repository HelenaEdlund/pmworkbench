#
# Temporary workaround to add comments to blueprint rendered character strings
#

nm_comments <- function(refRun=NA, description, author, 
                        date=NULL, version=NULL, label=NULL, structural=NULL, 
                        covariate=NULL, IIV=NULL, IOV=NULL, res=NULL, estimation=NULL){
  
  based   <- paste(";; 1. Based on: ", refRun)
  desr    <- paste(";; 2. Description: ", description)
  auth    <- paste(";; 3. Author: ", author)
  date    <- paste(";; 4. Date: ",date)
  ver     <- paste(";; 5. Version: ", version)
  lab     <- paste(";; 6. Label: ", label)
  strMod  <- paste(";; 7. Structural model: ", structural)
  covMod  <- paste(";; 8. Covariate model: ", covariate)
  IIV     <- paste(";; 9. Inter-individual variability: ", IIV)
  IOV     <- paste(";; 10. Inter-occasion variability: ",  IOV)
  res     <- paste(";; 11. Residual variability",res)
  Est     <- paste(";; 12. Estimation: ", estimation)
  
  comments <- paste(based, desr, auth, date, ver, lab,
                    strMod, covMod, IIV, IOV, res, Est, sep = "\n")
  
  return(comments)
}

add_comments <- function(cltfile, ...){
  
  comments <- nm_comments(...)
  
  cltfile <- paste(comments, cltfile, sep="\n\n\n")
  
  return(cltfile)
}
