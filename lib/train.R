###########################################################
### Train a classification model with training features ###
###########################################################

### Project 3

getModel <- function(integer, dat_train, label_train, n.trees, shrink) {
  c1 <- (integer-1) %% 4 + 1
  c2 <- (integer-c1) %/% 4 + 1
  featMat <- dat_train[, , c2]
  labMat <- label_train[, c1, c2]
  fit_gbm <- gbm.fit(x = featMat, y = labMat,
                     n.trees = n.trees,
                     shrinkage = shrink,
                     distribution = "gaussian",
                     interaction.depth = 1, 
                     bag.fraction = 0.5,
                     keep.data = FALSE,
                     verbose = FALSE)
  best_iter <- gbm.perf(fit_gbm, method = "OOB", plot.it = FALSE)
  return(list(fit = fit_gbm, shrink = shrink, iter = best_iter))
}


train <- function(dat_train, label_train, par=NULL){
  
  ### Train a Gradient Boosting Model (GBM) using processed features from training images
  
  ### Input: 
  ###  -  features from LR images 
  ###  -  responses from HR images
  ### Output: a list for trained models
  
  ### load libraries
  library(gbm)
  library(plyr)
  library(doMC)
  
  registerDoMC(2) # or however many cores you have access to
  ### creat model list
  modelList <- list()
  
  ### train with gradient boosting model
  if(is.null(par)){
    n.trees <- 100
    shrink <- 0.001
  } else {
    n.trees <- par$n.trees
    shrink <- par$shrink
  }
  
  ### the dimension of response array is * x 4 x 3, which requires 12 classifiers
  ### this part can be parallelized
  modelList <- llply(as.list(1:12),.fun = getModel, dat_train, label_train, n.trees, shrink, .parallel = T)
  
  return(modelList)
}
