########################
### Super-resolution ###
########################

### Project 3

getNeighbor <- function(pos, LR_padded){
  
  ### return a vector length of 8 for the 8 neighbor pixels
  ### input: pos: a row vector from sampled indexes in LR 
  ###        + LR_padded: a padded single channel LR image matrix
  ### output: a vector of (eight neighbor pixels - central pixel)
  
  x <- pos[1]
  y <- pos[2]
  neighbor <- as.vector(LR_padded[x:(x+2), y:(y+2)])
  neighbor <- neighbor - neighbor[5]
  return(neighbor[-5])
}

applySuperResolution <- function(file_num, LR_dir, HR_dir, modelList){
  imgLR <- readImage(paste0(LR_dir,  "img", "_", sprintf("%04d", file_num), ".jpg"))
  pathHR <- paste0(HR_dir,  "img", "_", sprintf("%04d", file_num), ".jpg")
  featMat <- array(NA, c(dim(imgLR)[1] * dim(imgLR)[2], 8, 3))
  
  ### step 1. for each pixel and each channel in imgLR:
  ###         save (the neighbor 8 pixels - central pixel) in featMat
  ###         tips: padding zeros for boundary points
  for (j in 1:3) {
    posMat <- arrayInd(1:length(imgLR@.Data[, , 1]), dim(imgLR@.Data)[1:2])
    padded <- rbind(NA, cbind(NA, imgLR@.Data[, , j], NA), NA)
    featMat_j <- t(apply(posMat, 1, getNeighbor, LR_padded = padded))
    featMat_j[is.na(featMat_j)] <- 0
    featMat[, , j] <- featMat_j
  }
  
  ### step 2. apply the modelList over featMat
  predMat <- test(modelList, featMat)
  predMat <- array(predMat,c(dim(featMat)[1], 4, 3))
  
  ### step 3. recover high-resolution from predMat and save in HR_dir
  imgHR <- array(NA, c(2 * dim(imgLR)[1], 2 * dim(imgLR)[2], 3))
  nr <- dim(predMat)[1]
  nc <- dim(imgLR)[2]
  
  for (j in 1:3) {
    center <- matrix(rep(as.vector(imgLR@.Data[ , , j]), 2), ncol = 2)
    imgHR[, ((1:nc)*2-1), j] <- matrix(as.vector(t(predMat[, 1:2, j]+center)), ncol = nc)
    imgHR[, ((1:nc)*2), j] <- matrix(as.vector(t(predMat[, 3:4, j]+center)), ncol = nc)
  }

  imgHR <- Image(imgHR, colormode = Color)
  writeImage(imgHR, files = pathHR)
}

superResolution <- function(LR_dir, HR_dir, modelList){
  
  ### Construct high-resolution images from low-resolution images with trained predictor
  ### Input: a path for low-resolution images + a path for high-resolution images 
  ###        + a list for predictors
  
  ### load libraries
  library(EBImage)
  n_files <- length(list.files(LR_dir))
  
  ### read LR/HR image pairs
  lapply(1:n_files, applySuperResolution, LR_dir=LR_dir, HR_dir=HR_dir, modelList=modelList)
}
