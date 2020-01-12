##################################################################################################################
#Author: Guy-vanie M. Miakonkana
#Purpose: read and process data 
#Date created: 09/29/2016
#Date last modified: 09/29/2016
# General Instructions: should not make ann modifications here, unless folders an  data were  name differently
#################################################################################################################
rm(list=ls(all=TRUE))

source(paste(getwd(), "/utils.R", sep=""))
#source("/home/guyvanie/Desktop/sbu/utils.R")

#get data loction
ddir<-paste(getwd(), "/data", sep="")
dname<-"rawdata.csv"
dpath<-paste(ddir,dname, sep="/" )

###read data
missings<-c(NA,"NA","N/A", "", " ",".","?",
            "Not asked or Missing",
            "Don\x92t know/Not sure/Refused/Missing",
            "Missing","Don\x92t know/Not sure"
            )

exclude.vars<-c("STATE","GEsOSTR","DENSTR", "PREALL","REPNUM","REPDEPTH","FMONTH",
                "IDATE","IMONTH","IDAY","IYEAR","DISPCODE", "EDUCA","EMPLOY1",
                "INCOME2","SEX","PREGNANT","BLIND")

ds<-read.csv(file=dpath, header=TRUE, stringsAsFactors=FALSE, na.strings = missings)
#ds<-read.csv(file="/home/guyvanie/Desktop/sbu/data/rawdata.csv", header=TRUE,
#             stringsAsFactors=FALSE,na.strings = missings)


ds<-ds[,!(names(ds) %in% exclude.vars)]
names(ds)<-tolower(names(ds))
response<-"diabete3"    

###process response
y<-gsub("Yes but female told only during pregnancy","Yes", ds[,response])
y<-gsub("No pre-diabetes or borderline diabetes","No", y)
y<-ifelse( !(y %in% c("Yes","No")), "unknown", y)
ds[,response]<-y
rm(y)
exclude.rows<-which(ds[,response]== "unknown")

###determine keys - eg:policy/customer number 
ids<-names(which(sapply(ds, function(x) length(unique(x))==nrow(ds))))
ids<-setdiff(ids,response)

#filter variables
exclude.vars<-tolower(exclude.vars)
cleanout<-cleanvars(dst=ds, yvar=response, idvar=ids, rows.out=exclude.rows, vars.out=exclude.vars, miss=missings)
predictors<-cleanout$xvars

charvars<-names(which(sapply(ds[,predictors], function(x) class(x)=="character" )))
numvars<-setdiff(predictors,charvars)
badrows<-union(cleanout$badrows,exclude.rows)
rs<-setdiff(1:nrow(ds), badrows)

#Roughly impute missing values                                  
for(j in predictors){ 
    ds[,j]<-treat.missings(ds[,j], missings)
}

# Characters to factors
for(j in predictors) {
       if (class(ds[,j])=="character"){
        levels <- unique(ds[,j])
        z <- as.integer(factor(ds[,j], levels=levels))
        ds[,j]<-factor(z,levels=unique(z) )
    }
}
rm(z)



# center numerics
for(j in numvars) {
      ds[,j] <- ds[,j] - round(mean(ds[,j]))
    }


#save processed data 
ddir<-paste(getwd(), "/data", sep="")
dname<-"procsddata.RData"
pdpath<-paste(ddir,dname, sep="/" )

ds<-ds[,union(union(ids,response),predictors)]
save(ds, rs, predictors, charvars,numvars, response, ids, file=pdpath)
#save(ds, rs, predictors, charvars,numvars, file="/home/guyvanie/Desktop/sbu/data/procsddata.RData")

