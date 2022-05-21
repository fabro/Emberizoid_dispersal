###Distance masterscript
library(phyloregion)
library(rgdal)
library(phytools)
library(raster)
library(caper)
library(letsR)
#####upload data
setwd("~/Distance")
hwicom<-read.table("hwi_data_sub.txt",header=T,sep="\t")
etree<-read.tree("corrected_mcc.txt")
head(hwicom)
####upload maps
#embena<-readOGR(dsn = "~/iMac/Bird maps/",layer = "nomax")
embemaps<-readOGR(dsn = "~/Documents/HWI-DISP_masterscript/Distance/Emberizo maps/",layer = "Emberizo_birds")

###select migrants
hwimigrants<-hwicom[which(hwicom$migratory=="Migrant"),]
hwimigrants
###extract the names and modify them to match with the maps
migrantnames<-hwimigrants$sp
migrantnamesn<-gsub("_"," ",migrantnames)
migrantnamesn<-as.character(migrantnamesn)
migrantnamesn
#keep distributions
embemapsM<-embemaps
#keeping the breeding ranges
embemapsM1<-embemapsM[which(embemapsM$SEASONAL==2),]
#wintering range
embemapsM2<-embemapsM[which(embemapsM$SEASONAL==3),]
###we calculate mid points for both ranges using letsR
#We create PAMs for the migrants where embemapsM1 are breeding ranges and EmbemapsM2 are the wintering ranges
pamx<-lets.presab(embemapsM1)
pamz<-lets.presab(embemapsM2)
###we calculate the midpoints using the pams
midpointsx<-lets.midpoint(pamx)
midpointsz<-lets.midpoint(pamz)
#we create two data frames with the mid points and the species for both ranges
migrantnamesmid<-as.character(migrantnamesn)
wintermid<-merge(migrantnamesmid,midpointsz,by.y="Species",all.y=F);names(wintermid)<-c("sp","x","y")
breedmid<-merge(migrantnamesmid,midpointsx,by.y="Species",all.y=F);names(breedmid)<-c("sp","x","y")
#calculate geodesic distance between ranges
library("geodist")
distances_mid<-data.frame()
for(i in 1:length(breedmid$sp)){
  win<-wintermid[which(wintermid$sp==as.character(breedmid$sp[i])),]
  bre<-breedmid[i,]
  brecor<-data.frame(bre$x,bre$y)
  wincor<-data.frame(win$x,win$y)
  #ran<-rbind(bre,win)
  #ran2<-data.frame(ran$x,ran$y);names(ran2)<-c("x","y")
  print(i)
  dis<-geodist(brecor,wincor,measure="geodesic",paired=T)
  d1<-data.frame(breedmid$sp[i],dis)
  distances_mid<-rbind(distances_mid,d1)
}
names(distances_mid)<-c("sp","distances_mid")
#we change back the names to match the phylogeny
distancesnames<-gsub(" ","_",distances_mid$sp)
#calculate the distances so they're in km
distanceskm<-distances_mid$distances_mid/1000
#assamble a data.frame with the distances in km and names that match the phylogenies
distances_mid<-data.frame(distancesnames,distanceskm)
names(distances_mid)<-c("sp","distances_mid")
###we bind the distance database with the main database
hwimigrants_mid<-merge(hwimigrants,distances_mid,by="sp")

#summary(lm(log(distances_mid)~HWI,data=hwimigrants_mid))
#summary(lm(distances_mid~HWI,data=hwimigrants_mid))
#or you can upload the table ready:
hwimigrants_mid<-read.table("~/Documents/HWI-DISP_masterscript/Data/hwi_distance_sub.txt",sep="\t",header=T)
####Calculating the distance~HWI PGLS
#create a sub tree with only the tips that are migratory species
obj1<-etree$tip.label[which(!is.na(match(etree$tip.label,hwimigrants_mid$sp)))]
hwitree<-keep.tip(etree,obj1)

#create a comparatative.data object to run pgls
comp.hwi2<-comparative.data(hwitree, hwimigrants_mid, names.col="sp", vcv.dim=T, warn.dropped=F)
#
modeldistance<-pgls(distances_mid~HWI,lambda = "ML",data = comp.hwi2)#simple model where the geodesic migration distance is predicted by HWI
summary(modeldistance)

plot(comp.hwi2$data$HWI,comp.hwi2$data$distances_mid)
abline(modeldistance,col="red")
#write.table(comp.hwi$data,"hwi_distance_sub.txt",row.names = F,sep="\t")
