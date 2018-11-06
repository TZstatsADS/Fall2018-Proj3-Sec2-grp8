############################################################
### Construct features and responses for training images ###
############################################################

### Authors: Group 8
### Project 3

### return a vector length of 8 for the 8 neighbor pixels
### input: pos: a row vector from sampled indexes in LR 
###        + LR_padded: a padded single channel LR image matrix
### output: a vector of (eight neighbor pixels - central pixel)
getNeighbor <- function(pos, LR_padded){
  x <- pos[1]
  y <- pos[2]
  neighbor <- as.vector(LR_padded[x:(x+2), y:(y+2)])
  neighbor <- neighbor - neighbor[5]
  return(neighbor[-5])
}

### return a vector length of 4 for corresponding 4 sub-pixels
### input: pos: a row vector from sampled indexes in LR 
###        + HR: a single channel HR image matrix
###        + LR: a single channel LR image matrix
### output: a vector of (four sub pixels in HR image - central pixel)
getSubPixel <- function(pos, HR, LR){
  x <- pos[1]
  y <- pos[2]
  sub_pixel <- as.vector(HR[(2*x-1):(2*x), (2*y-1):(2*y)])
  return(sub_pixel - LR[x, y])
}

feature <- function(LR_dir, HR_dir, n_points=1000){
  
  ### Construct process features for training images (LR/HR pairs)
  
  ### Input: a path for low-resolution images + a path for high-resolution images 
  ###        + number of points sampled from each LR image
  ### Output: an .RData file contains processed features and responses for the images
  
  ### load libraries
  library("EBImage")
  n_files <- length(list.files(LR_dir))
  #n_files <- 100
  ### store feature and responses
  featMat <- array(NA, c(n_files * n_points, 8, 3))
  labMat <- array(NA, c(n_files * n_points, 4, 3))
  
  ### read LR/HR image pairs
  for(i in 1:n_files){
    imgLR <- readImage(paste0(LR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    imgHR <- readImage(paste0(HR_dir,  "img_", sprintf("%04d", i), ".jpg"))
    
    ### step 1. sample n_points from imgLR
    # kep point detection (laplacian filtering)
    # laplace filter matrix
    la <- matrix(1, nc=3, nr=3)
    la[2,2] <- -8
    # colormode to grey
    greyLR <- channel(imgLR,mode = "grey")
    # filtering
    probLR <- as.vector(filter2(greyLR,la)@.Data)
    # positive probablity
    probLR <- probLR - min(probLR)
    sampled <- arrayInd(sample(length(imgLR@.Data[, , 1]), n_points,prob = probLR), dim(imgLR@.Data)[1:2])
    
    ### step 2. for each sampled point in imgLR,
    for (j in 1:3){
      
      ### step 2.1. save (the neighbor 8 pixels - central pixel) in featMat
      ###           tips: padding zeros for boundary points
      padded <- rbind(NA, cbind(NA, imgLR@.Data[, , j], NA), NA)
      featMat_j <- t(apply(sampled, 1, getNeighbor, LR_padded = padded))
      featMat_j[is.na(featMat_j)] <- 0
      featMat[((i-1)*n_points+1):(i*n_points), , j] <- featMat_j
      
      ### step 2.2. save the corresponding 4 sub-pixels of imgHR in labMat
      labMat[((i-1)*n_points+1):(i*n_points), , j] <- 
        t(apply(sampled, 1, getSubPixel, HR = imgHR@.Data[, , j], LR = imgLR@.Data[, , j]))
    }
    
  }
  return(list(feature = featMat, label = labMat))
}
