###########################################################
### Train a classification model with training features ###
###########################################################

### Project 3

getModel <- function(integer, dat_train, label_train, depth, min.weight) {
  ### Train a Gradient Boosting Model (XGBoost)
  
  ### Input: 
  ###  -  an integer in 1:12
  ###  -  features from LR images 
  ###  -  responses from HR images
  ###  -  parameters
  ### Output: a list for trained models    
  c1 <- (integer-1) %% 4 + 1
  c2 <- (integer-c1) %/% 4 + 1
  featMat <- dat_train[, , c2]
  labMat <- label_train[, c1, c2]
  dtrain <- xgb.DMatrix(featMat, label=labMat)
  fit_xg <- xgboost(dtrain,
                    max_depth = depth,
                    min_child_weight = min.weight,
                    subsample = 0.5,
                    nrounds = 200,
                    verbose = 0)
  return(list(fit = fit_xg))
}


train <- function(dat_train, label_train, par=NULL){
  
  ### Train a Gradient Boosting Model (GBM) using processed features from training images
  
  ### Input: 
  ###  -  features from LR images 
  ###  -  responses from HR images
  ### Output: a list for trained models
  
  ### load libraries
  library(xgboost)
  library(plyr)
  library(doMC)
  
  registerDoMC(2) # or however many cores you have access to
  ### creat model list
  modelList <- list()
  
  ### train with gradient boosting model
  if(is.null(par)){
    depth <- 1
    min.weight <- 1
  } else {
    depth <- par$depth
    min.weight <- par$min.weight
  }
  
  ### the dimension of response array is * x 4 x 3, which requires 12 classifiers
  ### this part can be parallelized
  modelList <- llply(as.list(1:12),.fun = getModel, dat_train, label_train, depth, min.weight, .parallel = T)
  
  return(modelList)
}
