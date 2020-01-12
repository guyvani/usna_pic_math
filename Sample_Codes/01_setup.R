##################################################################################################################
#Author: Guy-vanie M. Miakonkana
#Purpose: set up folders structure for the project 
#Date created: 09/29/2016
#Date last modified: 09/29/2016
# General Instructions: replace the datalocation by the appropriate data location on your local file system
##################################################################################################################

rm(list=ls())

#replace with the appropriate data location
datalocation<-"/home/guyvanie/Downloads/GoodHealthCo-20160921/SBU_example_Surveydata_2014.csv"  
 
#create folders 
for (i in c("data", "analysis", "output")){  
    if (!is.element(i, unlist(dir(getwd()))))
        {
          dir.create(paste(getwd(), i, sep="/"))
    }
 }

#copy raw data   
system( paste("cp -f ",datalocation," ", getwd(),"/data/rawdata.csv", sep="") )

#delete source raw data
#system(paste("rm ",datalocation, sep=""))

#create readme file
if (!file.exists(paste(getwd(), "/readme.txt", sep="")))
    { 
     file.create(paste(getwd(), "/readme.txt", sep=""))
   }



   