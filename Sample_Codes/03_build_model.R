##################################################################################################################
#Author: Guy-vanie M. Miakonkana
#Purpose: build model 
#Date created: 09/29/2016
#Date last modified: 09/29/2016
# General Instructions: should not make any modifications here, unless processed data is named differently
##################################################################################################################
rm(list=ls(all=TRUE))

#Install and load packages
wants <- c("car", "readr", "caTools",  "caret", "Hmisc", "nnet", 
           "xgboost","glmnet", "Matrix","gbm","kernlab", "neuralnet",
           "earth","mboost", "randomForest", "party", "pROC", "lubridate")
#has <- wants %in% rownames(installed.packages())
#if(any(!has)) install.packages(wants[!has])
lapply(wants, require, character.only = TRUE)


#get data loction
ddir<-paste(getwd(), "/data", sep="")
dname<-"procsddata.RData"
dpath<-paste(ddir,dname, sep="/" )

load(dpath)
#load("/home/guyvanie/Desktop/sbu/data/procsddata.RData")

#training/test split
myseed<-123
set.seed(myseed)
train<- as.vector(createDataPartition(ds[,response], p = .80, list = FALSE))
train<-intersect(rs, train)
test <- setdiff(rs,train)
#sum(sort(union(train, test))!=sort(rs)) 

#model building
mymetric<-'ROC'
set.seed(myseed)
myControl1 <- trainControl(method = 'cv',
                           number = 2,
                           repeats =1,
                           savePredictions=TRUE,
                           classProbs = TRUE,
                           sampling = "up",
                           summaryFunction = twoClassSummary
)

set.seed(myseed)
myControl2<-myControl1
myControl2$sampling<-"down"

gbmGrid <-  expand.grid(interaction.depth =2:5, 
                        n.trees = c(100,250,600), 
                        shrinkage = 0.1,
                        n.minobsinnode = 100
)
#try gbm
set.seed(myseed)
model1<-train(x=ds[train,predictors], y=factor(ds[train,response]), method='gbm', trControl=myControl1, tuneGrid = gbmGrid, metric=mymetric)

set.seed(myseed)
model2 <- train(x=ds[train,predictors], y=factor(ds[train,response]), method='gbm', trControl=myControl2, tuneGrid = gbmGrid, metric=mymetric)

all.models <- list(model1, model2)
names(all.models) <- sapply(all.models, function(x) x$method)
models.pred <- data.frame(sapply(all.models, function(x){predict(x, ds[,predictors], type='raw')}))

pred<-ifelse(models.pred[,1]=='Yes' & models.pred[,2]=='Yes', 'Yes', 'No')
pred.table<-data.frame(ds[,union(ids,response)], pred)
names(pred.table)<-c(c(ids, "reported"), "predicted")

sink(paste(getwd(), "/confusion_matrix.txt", sep=""))
print("###Training")
table(pred.table[train,'predicted'], pred.table[train,'reported'])
print("###Test")
table(pred.table[test,'predicted'], pred.table[test,'reported'])
print("###All")
table(pred.table[,'predicted'], pred.table[,'reported'])
sink()

filename<-"Diabetes_Status.csv"
filename<-paste(getwd(), "/output", "/", filename, sep="")
#filename<-paste(getwd(), "/Desktop", "/", filename, sep="")
write.table(pred.table,filename,append=FALSE,sep=",",na="NA",dec=".",row.names=FALSE,col.names=TRUE)

