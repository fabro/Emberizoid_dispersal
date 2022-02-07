#masterscript hwi-disp PGLSs
#we load de packages
library(caper)
library(geiger)
library(AICcmodavg)
library(phytools)
library(qpcR)
setwd("~/Documents/HWI-DISP_masterscript/PGLS/")
##load tree
etree<-read.tree("corrected_mcc.txt")#Barker et al 2015 MCC tree
radiation<-read.csv("emberizoidea_radiation.csv")#names and families of the Emberizoidea species
#create a vector for the families
families<-data.frame(as.character(radiation$scientific_name),as.character(radiation$family))
names(families)<-c("sp","family")
#load Emberizoidea HWI database without distances
hwicom<-read.csv("hwi_data_sub.csv",header=T)

#create a sub tree with only the tips that contain HWI data
obj1<-etree$tip.label[which(!is.na(match(etree$tip.label,hwicom$sp)))]
hwitree<-keep.tip(etree,obj1)

#se crea un objeto "comparative.data" para meter a la función pgls de caper
#create a comparatative.data object to run pgls
comp.hwi<-comparative.data(hwitree, hwicom, names.col="sp", vcv.dim=T, warn.dropped=F)

#run pgls
modellogarea<-pgls(log(area)~HWI,lambda = "ML",data = comp.hwi)#simple model where area is predicted by hwi
modellogareamig<-pgls(log(area)~HWI:migratory,lambda="ML",data=comp.hwi)#model where area is predicted by hwi, taking into account the migratory beheavior
migrantphyloaov<-phylANOVA(comp.hwi$phy,comp.hwi$data$migratory,comp.hwi$data$HWI,nsim = 1000,posthoc = T)#phylogenetic anova to account for the differences in wing shape between migratory and non-migratory beheavior
####calculate AIC for the models
modelsx<-list(modellogarea,modellogareamig)
slex<-AIC(modellogarea,modellogareamig)

AICscores<-c(1636.782, 1599.902)
#AICscores<-c(1644.911, 1602.1)
clem<-akaike.weights(AICscores)
aicw(AICscores)
##calculate phylogenetic signal for HWI
phylosignallambda<-phylosig(comp.hwi$phy,x = comp.hwi$data$HWI,method ="lambda",test=T )#using pagel's lambda
phylosignalk<-phylosig(comp.hwi$phy,x = comp.hwi$data$HWI,method ="K",test=T )#using blomberg's K
###calculating alpha and phylogenetic half life
hwidat<-comp.hwi$data$HWI
names(hwidat)<-comp.hwi$phy$tip.label
phylosignalOU<-fitContinuous(comp.hwi$phy,hwidat,model = "OU")
OUalpha<-phylosignalOU$opt$alpha
halflife<-log(2)/OUalpha
halflife
######using different models
phylosignalBM<-fitContinuous(comp.hwi$phy,hwidat,model = "BM")
phylosignalEB<-fitContinuous(comp.hwi$phy,hwidat,model = "EB")
#phylosignaltrend<-fitContinuous(comp.hwi$phy,hwidat,model = "trend")
#phylosignallam<-fitContinuous(comp.hwi$phy,hwidat,model = "lambda")
#phylosignalkappa<-fitContinuous(comp.hwi$phy,hwidat,model = "kapp")
#phylosignaldelta<-fitContinuous(comp.hwi$phy,hwidat,model = "delta")
#phylosignaldrift<-fitContinuous(comp.hwi$phy,hwidat,model = "drift")
phylosignalwhite<-fitContinuous(comp.hwi$phy,hwidat,model = "white")

#aicphylo<-c(phylosignalOU$opt$aicc,phylosignalBM$opt$aicc,phylosignalEB$opt$aicc,phylosignaltrend$opt$aicc,phylosignallam$opt$aicc,phylosignalkappa$opt$aicc,phylosignaldelta$opt$aicc,phylosignaldrift$opt$aicc,phylosignalwhite$opt$aicc)
#aicw(aicphylo)

aicx<-c(phylosignalOU$opt$aicc,phylosignalBM$opt$aicc,phylosignalEB$opt$aicc,phylosignalwhite$opt$aicc)
aicw(aicx)
######