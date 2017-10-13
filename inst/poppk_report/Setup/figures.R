###################################################
# figures.R
# 
# Author: Helena Edlund
# Created on: 2017-07-26
# Last modified on: 
# Purpose: Produce all project related figures contained in the report
# Dependencies: environmentPrep.R
###################################################

# -------------------------------------------------
# Goodness of fit for base model
# -------------------------------------------------
grid.arrange(
  ggplot(baseModelConcData, aes(y=DV, x=PRED)) +
    geom_hline(aes(yintercept=0), linetype="dashed", colour="darkgray") +
    geom_abline(slope=1, intercept=0) +
    geom_point(shape=1, size = 3, alpha=0.4) +
    geom_smooth(method="loess") +
    coord_cartesian(xlim=c(minConc,maxConc), ylim=c(minConc,maxConc)) +
    labs(y="ln(Observed)", x="ln(Population prediction)") +
    settings,
  
  ggplot(baseModelConcData, aes(y=DV, x=IPRED)) +
    geom_hline(aes(yintercept=0), linetype="dashed", colour="darkgray") +
    geom_abline(slope=1, intercept=0) +
    geom_point(shape=1, size = 3, alpha=0.4) +
    geom_smooth(method="loess") +
    coord_cartesian(xlim=c(minConc,maxConc), ylim=c(minConc,maxConc)) +
    labs(y="Observed", x="Individual prediction") +
    settings,
  
  ggplot(baseModelConcData, aes(y=CWRES, x=TAPD)) +
    geom_hline(aes(yintercept=0), color="darkgray") +
    geom_point(shape=1, size = 3, alpha=0.4) +
    geom_smooth(method="loess") +
    coord_cartesian(ylim=c(-maxCWRES,maxCWRES)) +
    scale_y_continuous(breaks=seq(from=-20, to=20, by=2)) +
    labs(y="CWRES", x="Time after dose") +
    settings,
  
  ggplot(baseModelConcData, aes(y=CWRES, x=PRED)) +
    geom_point(shape=1, size = 3, alpha=0.4) +
    geom_hline(aes(yintercept=0)) +
    geom_smooth(method="loess") +
    coord_cartesian(ylim=c(-maxCWRES,maxCWRES)) +
    scale_y_continuous(breaks=seq(from=-20, to=20, by=2)) +
    labs(y="CWRES", x="ln(Population prediction)") +
    settings,
  nrow=2)

# -------------------------------------------------
# ETA versus covariates for base model
# -------------------------------------------------
baseModelBaseline <- baseModelConcData[!duplicated(baseModelConcData$ID),]

p <-
  ggduo(baseModelBaseline,
        c('AGE','BWT','BHT','BEGFR','BBILI','BAST'),
        c('ETA3',"ETA4"),
        types = list(continuous = scatterWithSmooth),
        columnLabelsX = c('AGE','BWT','BHT','BEGFR','BBILI','BAST'),
        columnLabelsY = c("Random effect of CL/F",'Random effect of Vc/F'))
print(p, leftWidthProportion = 0.35)

p <-
  ggduo(baseModelBaseline ,
        c('SEXM','RACEL1','ETHNIC','HEALTHGPL','ECOG','DOSE','HEPATICL','ARA'),
        c('ETA3',"ETA4"),
        types = list(comboVertical = myBoxplot),
        columnLabelsX = c('SEX','RACE','ETHNIC','HEALTHGP','ECOG','DOSE','HEPATIC','ARA'),
        columnLabelsY = c("Random effect of CL/F",'Random effect of Vc/F'))
print(p, leftWidthProportion = 0.35, bottomHeightProportion = 0.65)

# -------------------------------------------------
# Parameter distributions for base model
# -------------------------------------------------
grid.arrange(
  ggplot(baseModelBaseline) +
    geom_histogram(aes(x=CL), fill="#737373", colour="#525252", size = 1,bins = 30) +
    labs(x='EBE of CL/F', y='Count') + settings,
  ggplot(baseModelBaseline) +
    geom_histogram(aes(ETA3), fill="#737373", colour="#525252", size = 1,bins = 30) +
    # stat_function(fun = dnorm, args = list(sd = sqrt(0.237)), size = 1, linetype = 2) +
    labs(x='Random effect of CL/F', y='Count') + settings,
  
  ggplot(baseModelBaseline) +
    geom_histogram(aes(x=V2), fill="#737373", colour="#525252", size = 1,bins = 30) +
    labs(x='EBE of Vc/F', y='Count') + settings,
  
  ggplot(baseModelBaseline) +
    geom_histogram(aes(ETA4), fill="#737373", colour="#525252", size = 1,bins = 30) +
    # stat_function(fun = dnorm, args = list(sd = sqrt(0.237)), size = 1, linetype = 2) +
    labs(x='Random effect of Vc/F', y='Count') + settings,
  nrow=2)

# -------------------------------------------------
# Individual fits for base model
# -------------------------------------------------
## Select 10 best and 10 worst fit based on CWRES.
largestCWRES <-
  ddply(baseModelConcData[baseModelConcData$ID !=446,],  # ID 446 has only 1 conc
        .(ID), summarize,
        maxCWRES = max(abs(CWRES), na.rm=T))
largestCWRES <- largestCWRES[order(largestCWRES$maxCWRES),]

best <- head(largestCWRES, n = 12)$ID
worst <- tail(largestCWRES, n = 12)$ID

bestConcData <- baseModelConcData[baseModelConcData$ID %in% best, ]
worstConcData <- baseModelConcData[baseModelConcData$ID %in% worst, ]
# Remove one sparse occasion on a different dosing regimen.
# 2 rich profiles at 200 mg BID ans since plot facets on regimen the sparse
# gets a separate plot area. Does not add much to the figure so excluded.
worstConcData <-
  worstConcData[!(worstConcData$ID==337 & worstConcData$Regimen=="100 mg BID"),]

ggplot(data=bestConcData[!is.na(bestConcData$OCC),],
       aes(x=TAPD, y=DV, colour=factor(OCC), group=ID.OCC)) +
  # observed, rich
  geom_point(aes(shape=factor(BLQ)), size=2.5) +
  scale_shape_manual(values=c(1,4)) + guides(shape="none") +
  
  # population prediction, rich
  geom_line(aes(x=TAPD, y=PRED, group=ID.OCC), colour="#575757",
            linetype="solid", inherit.aes = F, size=1) +
  
  # individual prediction, rich
  geom_line(aes(x=TAPD, y=IPRED, colour=factor(OCC), group=ID.OCC),
            linetype="longdash", size=1) +
  
  # observed, sparse
  geom_point(data=bestConcData[is.na(bestConcData$OCC),],
             aes(y=DV, x=TAPD), size=2.5, shape=1, col="#575757") +
  # predicted, sparse
  geom_point(data=bestConcData[is.na(bestConcData$OCC),],
             aes(y=IPRED, x=TAPD), size=2.5, shape=2, col="#575757") +
  # lloq
  geom_hline(aes(yintercept=log(1)), linetype="dashed") +
  # settings
  coord_cartesian(xlim=c(0,12), ylim=c(0,8)) +
  scale_x_continuous(breaks=c(0,2,4,6,8,10,12)) +
  scale_colour_brewer(palette="Dark2") +
  guides(colour="none") +
  facet_wrap(~ID+Regimen, ncol=3, labeller="label_both") +
  labs(x="Time after dose (h)", y = "log(Concentration)") + theme_bw() +
  settings







# -------------------------------------------------
# Forest plot for the parameter level
# -------------------------------------------------
forrest <-
  covParameters[covParameters$par %in% covPar[!covPar %in% c("EGFR_CL","DOSE_CL")],
                c("par","estimate","SE")]
forrest$strPar <- gsub("(.*)_","", forrest$par)
forrest$strPar <- factor(forrest$strPar, levels = c("CL", "V"), labels = c("CL/F", "Vc/F"))

forrest$par <- gsub("_.*","",  forrest$par)

# estimates and intervals
forrest$estimate <- forrest$estimate+1
forrest$lCI <- forrest$estimate - 1.96*forrest$SE + 1
forrest$uCI <- forrest$estimate + 1.96*forrest$SE + 1

CL <- covParameters$estimate[covParameters$par=="CL"]
V <- covParameters$estimate[covParameters$par=="Vc"]
EGFR <- covParameters$estimate[covParameters$par=="EGFR_CL"]
DOSE <- covParameters$estimate[covParameters$par=="DOSE_CL"]

fEGFR <- data.frame(par="EGFR", estimate=1, SE=NA, strPar="CL/F",
                    lCI = (CL*(30/75.3)^EGFR)/CL,   # min = 29.95
                    uCI = (CL*(170/75.3)^EGFR)/CL)  # max = 280.9 but likely an outlier. next is 168.7

fDOSE <- data.frame(par="Dose", estimate=1, SE=NA, strPar="CL/F",
                    lCI = (CL*(15/100)^DOSE)/CL,
                    uCI = (CL*(400/100)^DOSE)/CL)
# allometric scaling
fBWCL   <- data.frame(par="BW", estimate=1, SE=NA, strPar="CL/F",
                      lCI = (CL*(50/70)^0.75)/CL,   # min in male patients
                      uCI = (CL*(140/70)^0.75)/CL)  # max in male patients

fBWV   <- data.frame(par="BW", estimate=1, SE=NA, strPar="Vc/F",
                     lCI = (V*(50/70)^1)/V,
                     uCI = (V*(140/70)^1)/V)

forrest <- rbind(forrest, fEGFR, fDOSE, fBWCL, fBWV)

forrest$par <-
  factor(forrest$par,
         levels = rev(c("ECOGHV","Dose","EGFR","ARA","SEX","RACEB","RACEO","HEP","BW")),
         labels = rev(c("Health group: HV","Dose: 400-15","eGFR: 30-170",
                        "Acid Reducing Agent",
                        "Sex: Female",
                        "Race: Black","Race: Other",
                        "Hepatic: Mild/Moderate",
                        "Body Weight: 50-140")))

parImpact <- # printed in section below
  ggplot(forrest, aes(estimate, par)) +
  geom_rect(xmin = 0.8, ymin = -Inf, xmax= 1.25, ymax = Inf, fill="lightgray") +
  geom_point(size=4, shape=18) +
  geom_errorbarh(aes(xmax = uCI, xmin = lCI), height = 0.3) +
  geom_vline(xintercept = 1, linetype = "longdash") +
  theme_bw() + facet_wrap(~strPar) +
  scale_x_continuous(breaks = seq(from=0, to=5, by=0.5)) +
  labs(x="Change in parameter relative to population estimate", y="") +
  theme(axis.title = element_text(size=12),
        axis.text = element_text(size=12),
        strip.text = element_text(size=10),
        legend.title = element_blank(),
        legend.text = element_text(size=12),
        legend.margin = unit(0.1, "in"),
        legend.key.size = unit(0.5, "in"),
        legend.position = "bottom",
        legend.box = "horizontal",
        panel.margin = unit(1.2, "lines"))



# ----------------------------------------------
# Exposure by covariate
# ----------------------------------------------

# function to get numbers in boxes for graphics below
getNAUC <- function(x){
  return(c(y = -200, label = length(x)))
}
getNCmax <- function(x){
  return(c(y = -40, label = length(x)))
}
theme_set(theme_bw())

res <- 300

## function to divide data into 4 groups base on quartiles 
# quartiles <- function(cov) {
#   breaks <- quantile(cov, p=c(0.25,0.5,0.75))
#   data <- data.frame(cov=cov, grouping=NA)
#   data$grouping[data$cov < breaks[1]] <- "0-24.9"
#   data$grouping[data$cov >= breaks[1] & data$cov < breaks[2]] <- "25-49.9"
#   data$grouping[data$cov >= breaks[2] & data$cov < breaks[3]] <- "50-74.9"
#   data$grouping[data$cov >= breaks[3]] <- "75-100"
#   
#   data$grouping <- factor(data$grouping, levels=c("0-24.9","25-49.9","50-74.9","75-100"))
#   return(data$grouping)
# }

### --------- Create missing lumped categories ---------------
# Hepatic
exposureData$HEPATICL[exposureData$HEPATIC == "Normal"] <- "Normal"
exposureData$HEPATICL[exposureData$HEPATIC %in% c("Mild", "Moderate")] <- "Mild/Moderate"
exposureData$HEPATICL <- factor(exposureData$HEPATICL, levels = c("Normal","Mild/Moderate")) # NCI criteria

## Race: white, black, other
exposureData$RACEL[!is.na(exposureData$RACE) & exposureData$RACE == "White"] <- "White"
exposureData$RACEL[!is.na(exposureData$RACE) & exposureData$RACE == "Black/African American"] <- "Black/African American"
exposureData$RACEL[!is.na(exposureData$RACE) & !exposureData$RACE %in% c("White","Black/African American")] <- "Other"
exposureData$RACEL <- factor(exposureData$RACEL, levels=c("White", "Black/African American", "Other"))

# ECOGL
exposureData$ECOGL[exposureData$ECOG %in% c("HV")] <- "HV" # Healty volunteers
exposureData$ECOGL[exposureData$ECOG %in% c("0","1")] <- "ECOG: 0/1" # Healty volunteers
exposureData$ECOGL[exposureData$ECOG %in% c("2","3")] <- "ECOG: 2/3" # Healty volunteers
exposureData$ECOGL <- factor(exposureData$ECOGL,
                             levels=c("HV","ECOG: 0/1","ECOG: 2/3"))
# ARAL
exposureData$ARAL[exposureData$ARA %in% c("Yes","Both","Yes*")] <- "Yes"
exposureData$ARAL[exposureData$ARA == "No"] <- "No"
exposureData$ARAL <- factor(exposureData$ARAL, levels=c("No","Yes"))

#------------------- 100 mg BID AUC24hr,ss vs covariates ----------------------
# Cont
png(filename = paste(resCovModelDir,"predAUCCmaxvsAge.png", sep="/"),
    width=10, height=4.5, units = "in", res=res)
grid.arrange(
  ggplot(exposureData, aes(y=AUC24hss, x=AGE)) + geom_point(shape=1) +
    labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"), x="Age (years)"), 
  ggplot(exposureData, aes(y=Cmaxss, x=AGE)) + geom_point(shape=1) +
    labs(y=expression("C"["max,ss"]~"(ng/mL)"), x="Age (years)"),
  nrow=1)
dev.off()

png(filename = paste(resCovModelDir,"predAUCCmaxvsBWT.png", sep="/"),
    width=10, height=4.5, units = "in", res=res)
grid.arrange(
  ggplot(exposureData, aes(y=AUC24hss, x=BWT)) + geom_point(shape=1) + 
    labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"), x="Body weight (kg)"),
  ggplot(exposureData, aes(y=Cmaxss, x=BWT)) + geom_point(shape=1) + 
    labs(y=expression("C"["max,ss"]~"(ng/mL)"), x="Body weight (kg)"),
  nrow=1)
dev.off()

png(filename = paste(resCovModelDir,"predAUCCmaxvseGFR.png", sep="/"),
    width=10, height=4.5, units = "in", res=res)
grid.arrange(
  ggplot(exposureData, aes(y=AUC24hss, x=BEGFR)) + geom_point(shape=1)+ 
    labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"),
         x=expression("eGFR (mL/min/1.73m"^2~")")),
  ggplot(exposureData, aes(y=Cmaxss, x=BEGFR)) + geom_point(shape=1)+ 
    labs(y=expression("C"["max,ss"]~"(ng/mL)"),
         x=expression("eGFR (mL/min/1.73m"^2~")")),
  nrow=1)
dev.off()

# Cat
png(filename = paste(resCovModelDir,"predAUCCmaxvsSex.png", sep="/"),
    width=10, height=4.5, units = "in", res=res)
grid.arrange(
  ggplot(exposureData, aes(y=AUC24hss, x=SEXM)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNAUC, geom = "label") +   
    labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"), x="Sex") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  ggplot(exposureData, aes(y=Cmaxss, x=SEXM)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNCmax, geom = "label") +   
    labs(y=expression("C"["max,ss"]~"(ng/mL)"), x="Sex") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  nrow=1)
dev.off()

# FemalesAUC <- quantile(exposureData$AUC24hss[exposureData$SEXM=="Female"], p=c(0.25,0.5,0.75))
# MalesAUC <- quantile(exposureData$AUC24hss[exposureData$SEXM=="Male"], p=c(0.25,0.5,0.75))
# FemalesCmax <- quantile(exposureData$Cmaxss[exposureData$SEXM=="Female"], p=c(0.25,0.5,0.75))
# MalesCmax <- quantile(exposureData$Cmaxss[exposureData$SEXM=="Male"], p=c(0.25,0.5,0.75))

png(filename = paste(resCovModelDir,"predAUCCmaxvsRENAL.png", sep="/"),
    width=10, height=4.5, units = "in", res=res)
grid.arrange(
  ggplot(exposureData, aes(y=AUC24hss, x=RENAL)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNAUC, geom = "label") +   
    labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"), x="Renal impairment") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  ggplot(exposureData, aes(y=Cmaxss, x=RENAL)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNCmax, geom = "label") +   
    labs(y=expression("C"["max,ss"]~"(ng/mL)"), x="Renal impairment") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  nrow=1)
dev.off()

png(filename = paste(resCovModelDir,"predAUCCmaxvsHEPATIC.png", sep="/"),
    width=10, height=4.5, units = "in", res=res)
grid.arrange(
  ggplot(exposureData, aes(y=AUC24hss, x=HEPATIC)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNAUC, geom = "label") +   
    labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"), x="Hepatic impairment") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  ggplot(exposureData, aes(y=Cmaxss, x=HEPATIC)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNCmax, geom = "label") +   
    labs(y=expression("C"["max,ss"]~"(ng/mL)"), x="Hepatic impairment") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  nrow=1)
dev.off()

png(filename = paste(resCovModelDir,"predAUCCmaxvsHEPATICL.png", sep="/"),
    width=10, height=4.5, units = "in", res=res)
grid.arrange(
  ggplot(exposureData, aes(y=AUC24hss, x=HEPATICL)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNAUC, geom = "label") +   
    labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"), x="Hepatic impairment") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  ggplot(exposureData, aes(y=Cmaxss, x=HEPATICL)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNCmax, geom = "label") +   
    labs(y=expression("C"["max,ss"]~"(ng/mL)"), x="Hepatic impairment") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  nrow=1)
dev.off()

png(filename = paste(resCovModelDir,"predAUCCmaxvsRACE.png", sep="/"),
    width=10, height=4.5, units = "in", res=res)
grid.arrange(
  ggplot(exposureData, aes(y=AUC24hss, x=RACE)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNAUC, geom = "label") +   
    labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"), x="Race") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  ggplot(exposureData, aes(y=Cmaxss, x=RACE)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNCmax, geom = "label") +   
    labs(y=expression("C"["max,ss"]~"(ng/mL)"), x="Race") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  nrow=1)
dev.off()

png(filename = paste(resCovModelDir,"predAUCCmaxvsRACEL.png", sep="/"),
    width=10, height=4.5, units = "in", res=res)
grid.arrange(
  ggplot(exposureData, aes(y=AUC24hss, x=RACEL)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNAUC, geom = "label") +   
    labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"), x="Race") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  ggplot(exposureData, aes(y=Cmaxss, x=RACEL)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNCmax, geom = "label") +   
    labs(y=expression("C"["max,ss"]~"(ng/mL)"), x="Race") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  nrow=1)
dev.off()

png(filename = paste(resCovModelDir,"predAUCCmaxvsEthnicity.png", sep="/"),
    width=10, height=4.5, units = "in", res=res)
grid.arrange(
  ggplot(exposureData, aes(y=AUC24hss, x=ETHNIC)) + 
    geom_boxplot(fill="#a0a0a0",outlier.shape = 1) +
    stat_summary(fun.data = getNAUC, geom = "label") +   
    labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"), x="Ethnicity") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  ggplot(exposureData, aes(y=Cmaxss, x=ETHNIC)) + 
    geom_boxplot(fill="#a0a0a0",outlier.shape = 1) +
    stat_summary(fun.data = getNCmax, geom = "label") +   
    labs(y=expression("C"["max,ss"]~"(ng/mL)"), x="Ethnicity") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  nrow=1)
dev.off()

png(filename = paste(resCovModelDir,"predAUCCmaxvsARA.png", sep="/"),
    width=10, height=4.5, units = "in", res=res)
grid.arrange(
  ggplot(exposureData, aes(y=AUC24hss, x=ARAL)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNAUC, geom = "label") +   
    labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"), x="Acid reducing agent") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  ggplot(exposureData, aes(y=Cmaxss, x=ARAL)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNCmax, geom = "label") +   
    labs(y=expression("C"["max,ss"]~"(ng/mL)"), x="Acid reducing agent") + 
    theme(axis.text.x = element_text(angle = 45, hjust=1)),
  nrow=1)
dev.off()

png(filename = paste(resCovModelDir,"predAUCCmaxvsECOG.png", sep="/"),
    width=10, height=4.5, units = "in", res=res)
grid.arrange(
  ggplot(exposureData, aes(y=AUC24hss, x=ECOG)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNAUC, geom = "label") +   
    labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"), x="ECOG performance status"),
  ggplot(exposureData, aes(y=Cmaxss, x=ECOG)) + 
    geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
    stat_summary(fun.data = getNCmax, geom = "label") +   
    labs(y=expression("C"["max,ss"]~"(ng/mL)"), x="ECOG performance status"),
  nrow=1)
dev.off()

# ggplot(exposureData, aes(y=AUC24hss, x=DOSE)) +
#   geom_boxplot(fill="#a0a0a0", outlier.shape = 1) +
#   stat_summary(fun.data = getNAUC, geom = "label") +
#   geom_hline(aes(yintercept = median(exposureData$iAUC100mgBID)), linetype="dashed") +
#   labs(y=expression("AUC"["24h,ss"]~"(ng/mL*h)"), x="Dose") +
#   theme(axis.text.x = element_text(angle = 45, hjust=1))

