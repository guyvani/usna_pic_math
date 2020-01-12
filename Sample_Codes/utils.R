##################################################################################################################
#Author: Guy-vanie M. Miakonkana
#Purpose: data processing functions 
#Date created: 09/29/2016
#Date last modified: 09/29/2016
# General Instructions: Don't this. It's used by 02_read_data.R 
##################################################################################################################


################################################Data cleaning function##############################################
cleanvars<-function(dst, yvar, idvar, rows.out, vars.out, miss){
    require(caret)
    if (!is.data.frame(ds)) stop("ds must be a data frame")
    if (!is.character(yvar)) stop("yvar must be a character") 
    if (!is.character(idvar)) stop("idvar must be a character") 
    names(ds)<-tolower(names(ds))
    variables<-names(ds)
    vars.out<-tolower(vars.out)
    badrows<-rows.out
    duprows<-which(duplicated(ds))
    badrows<-union(badrows,duprows)
    dupids<-which(duplicated(ds[,idvar]))
    badrows<-union(badrows, dupids)
    missingyvar<-which(is.na(ds[,yvar]))
    badrows<-union(badrows, missingyvar)
    allmissrow<-which(apply(ds,1, function(x) sum(is.na(x))==ncol(ds[, !(names(ds) %in% c(yvar, idvar))])))
    badrows<-union(badrows, allmissrow)
    goodid<-setdiff(1:nrow(ds),badrows)
    ignore<-vars.out
    response<-yvar 
    id<-idvar 
    ignore<-union(ignore, id)
    ignore<-union(ignore, yvar)
    predictors<-setdiff(variables, ignore)
    constants<-names(which(sapply(ds[goodid,predictors], function(x) {length(unique(x))==1})))
    ignore<-union(ignore, constants)
    predictors<-setdiff(predictors, ignore)
    ids<-names(which(sapply(ds[goodid,predictors], function(x) length(unique(x))>=0.9999*nrow(ds[goodid,]))))
    ignore<-union(ignore, ids)
    predictors<-setdiff(predictors, ignore)
    mostmiss<-names(which(sapply(ds[goodid,predictors], function(x) sum(is.na(x))>=0.5*nrow(ds[goodid,]))))
    ignore<-union(ignore, mostmiss)
    predictors<-setdiff(predictors, ignore)
    allcharmiss<-names(which(sapply(ds[goodid,predictors], function(x) sum(x %in% miss)>=0.5*nrow(ds[goodid,]))))
    ignore<-union(ignore,  allcharmiss)
    predictors<-setdiff(predictors, ignore)
        
    charvars<-names(which(sapply(ds[goodid,predictors], function(x) class(x)=="character" ))) 
    charids<-names(which(sapply(ds[goodid,charvars], function(x) 100*max(prop.table(table(x)))< 0.001  ) ))
    charvars<-setdiff(charvars,charids)
    ignore<-union(ignore, charids)
    predictors<-setdiff(predictors, ignore)
    numvars<-setdiff(predictors, charvars)
    intvars<-names(which(sapply(ds[goodid,numvars], function(x) class(x)=="integer" )))
    intcharvars<-names(which(sapply(ds[goodid, intvars], function(x) length(unique(x)) <= 2 ))) 
    numvars<-setdiff(numvars,intcharvars)
    charvars<-union(charvars,intcharvars)
    manylvls<-names(which(sapply(ds[goodid, charvars], function(x) length(unique(x)) > 20 )))
    charvars<-setdiff(charvars,manylvls)
    ignore<-union(ignore, manylvls)
    predictors<-setdiff(predictors, ignore)
    ds[,charvars]<-sapply(ds[,charvars], as.character) 
    
    duprows<-which(duplicated(ds[goodid, union(predictors,yvar)]))
    badrows<-union(badrows, duprows)
    outclean<-list(xvars=predictors, yvar=yvar, idvar=idvar,badrows=badrows,ignore=ignore)
}


###########################################transform predictors ##########################
treat.missings <- function (a, pattern){
    a<-ifelse(a %in% pattern, NA, a)
    missing <- is.na(a) 
 
    n.missing <- sum(missing)
    a.obs <- a[!missing]
    imputed <- a
    
    if (!is.character(a)){
        imputed[missing] <- median(a.obs)
    } else {
        imputed[missing] <- "missing"
    }
    return (imputed)
}