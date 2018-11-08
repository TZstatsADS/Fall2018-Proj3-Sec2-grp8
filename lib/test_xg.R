######################################################
### Fit the regression model with testing data ###
######################################################

### Author: Chengliang Tang
### Project 3

getPredVec <- function(integer, modelList, dat_test) {
  fit_train <- modelList[[integer]]
  ### calculate column and channel
  c1 <- (integer-1) %% 4 + 1
  c2 <- (integer-c1) %/% 4 + 1
  featMat <- dat_test[, , c2]
  ### make predictions
  predVec <- predict(fit_train$fit, newdata=featMat)
  return(predVec)
}

test <- function(modelList, dat_test){
  
  ### Fit the classfication model with testing data
  
  ### Input: 
  ###  - the fitted classification model list using training data
  ###  - processed features from testing images 
  ### Output: training model specification
  
  ### load libraries
  library(xgboost)
  library(doMC)
  library(plyr)
  registerDoMC(2)
  
  predArr <- array(NA, c(dim(dat_test)[1], 4, 3))
  predVec <- list()
  predVec <- llply(as.list(1:12), getPredVec, modelList, dat_test,.parallel = T)
  for(i in 1:12) {
    c1 <- (i-1) %% 4 + 1
    c2 <- (i-c1) %/% 4 + 1
     predArr[, c1, c2] <- predVec[[i]]
  }
  
  return(as.numeric(predArr))
}

