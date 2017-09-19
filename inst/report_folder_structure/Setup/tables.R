###################################################
# tables.R
# 
# Author: Helena Edlund
# Created on: 2017-07-26
# Last modified on: 
# Purpose: Produce all project related tables contained in the report
# Dependencies: environmentPrep.R
###################################################

####################################################################################
#
# Exposure summary tables by covariates
#
####################################################################################

covList <- c("SEXM","RENAL","HEPATICL","RACEL","ETHNIC","ARAL","ECOG")

# Summarize categorical groups
CovSummary <- mySummary(covList, summarizeCat, exposureData)
CovSummary$Characteristic <- as.character(CovSummary$Characteristic)

# Add exposure 
for(i in 1:length(covList)){
  
  temp1 <- 
    ddply(exposureData, covList[i],
          plyr::summarise, 
          AUC24h = paste0(signif(median(AUC24hss), digits=4)," [", 
                          signif(quantile(AUC24hss, p = 0.025), digits=4), "-", 
                          signif(quantile(AUC24hss, p = 0.975), digits=4), "]"),
          Cmax = paste0(signif(median(Cmaxss), digits=4)," [", 
                        signif(quantile(Cmaxss, p = 0.025), digits=4), "-", 
                        signif(quantile(Cmaxss, p = 0.975), digits=4), "]")) 
  
  temp1$Characteristic <- covList[i]
  names(temp1)[1] <- "Category"
  
  if(i == 1){
    temp2 <- temp1
  } else { 
    temp2 <- rbind(temp2, temp1)
  }
}
temp2$Category <- as.character(temp2$Category)
temp2$Category[is.na(temp2$Category)] <- "Missing"

# Merge
ExposureByCategory <- 
  dplyr::left_join(CovSummary, temp2, by=c("Characteristic", "Category"))

ExposureByCategory <- 
  ExposureByCategory[,!(colnames(ExposureByCategory)=="Percent")]

write.csv(ExposureByCategory,
          file = paste(resCovModelDir, paste0("exposureByCatTab_", deliveryDate,".csv"), sep = "/"), 
          row.names = F)


# --------------------------------
# Organ impairment listings
# --------------------------------

# remove duplicated IDs, take the PK values without ARA
ids <- exposureData[duplicated(exposureData$NMSEQSID),"NMSEQSID"]

forListings <- 
  exposureData[!(exposureData$NMSEQSID %in% ids & exposureData$ARAL=="Yes"), ]

colsToIncludeRenal <-
  c("OSTUDYID","NMSEQSID","OSID",
    "RENAL","BCRCL","BEGFR",
    "HEPATIC","BAST","BALT","BBILI",
    "AUC24hss","Cmaxss")
colHeadersRenal <- 
  c("Study","ID","OSID",
    "RenalImpairment","CrCL","eGFR",
    "HepaticImpairment","AST","ALT","Bilirubin",
    "PredictedAUC24hss","PredictedCmaxss")

colsToIncludeHepatic <- 
  c("OSTUDYID","NMSEQSID","OSID",
    "HEPATIC","BAST","BALT","BBILI",
    "RENAL","BCRCL","BEGFR",
    "AUC24hss","Cmaxss")
colHeadersHepatic <- 
  c("Study","ID","OSID",
    "HepaticImpairment","AST","ALT","Bilirubin",
    "RenalImpairment","CrCL","eGFR",
    "PredictedAUC24hss","PredictedCmaxss")

# ------------ Renal tab ------------------
forListingsRenal <- 
  forListings[forListings$RENAL != "Normal",]

## round to 4 significant digits
forListingsRenal$BCRCL <- signif(forListingsRenal$BCRCL, digits=4)
forListingsRenal$BEGFR <- signif(forListingsRenal$BEGFR, digits=4)
forListingsRenal$BBILI <- signif(forListingsRenal$BBILI, digits=4)

forListingsRenal <- forListingsRenal[ , colsToIncludeRenal]
names(forListingsRenal) <- colHeadersRenal

# Sort by study, impariment status and ID
forListingsRenal <- 
  forListingsRenal[order(forListingsRenal$Study,forListingsRenal$RenalImpairment,forListingsRenal$ID),]

write.csv(forListingsRenal, file = paste(resCovModelDir, "renalImparimentListing.csv",sep="/"), 
          quote = F, row.names = F)

# ------------ Hepatic tab ------------------
forListingsHepatic <- 
  forListings[forListings$HEPATIC != "Normal" & !is.na(forListings$HEPATIC),]

## round to 4 significant digits
forListingsHepatic$BCRCL <- signif(forListingsHepatic$BCRCL, digits=4)
forListingsHepatic$BEGFR <- signif(forListingsHepatic$BEGFR, digits=4)
forListingsHepatic$BBILI <- signif(forListingsHepatic$BBILI, digits=4)

forListingsHepatic<- forListingsHepatic[,colsToIncludeHepatic]
names(forListingsHepatic) <- colHeadersHepatic

# Sort by study, impariment status and ID
forListingsHepatic <- 
  forListingsHepatic[order(forListingsHepatic$Study,forListingsHepatic$HepaticImpairment, forListingsHepatic$ID),]

write.csv(forListingsHepatic, file = paste(resCovModelDir, "hepaticImparimentListing.csv",sep="/"), 
          quote = F, row.names = F)