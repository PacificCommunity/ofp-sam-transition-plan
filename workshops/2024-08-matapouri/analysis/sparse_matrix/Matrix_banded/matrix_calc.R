# Trial script to run large matrix calculations #
#
setwd("C:/Nick/I_Assessments/Pop\ dy\ modeling/MFCL/MFCL/next_gen_mod/workshop_aug2024/rTMB_matrixcalc/")
#
#
################################################################################
#
#             Non-Optimised matrix operation
#
rws <- 1000   # length
cls <- 1000   # age
#rws <- 10   # length
#cls <- 10   # age
valx <- 100
mx <- matrix(0,nrow=rws,ncol=cls)
#
# Set up a banded sparse matrix for population state
for(i in 1:rws){   # length
  for(j in 1:cls){ # age
    if(i>=(j-2) & i<=(j+2)) mx[i,j]=valx
  }
}
#mx
#
#
# Set up a banded sparse matrix for growth transition matrix
valt <- 0.1
rws2 <- rws  # start length
cls2 <- rws2  # destination length
tx <- matrix(0,nrow=rws2,ncol=cls2)
for(i in 1:rws2){   # start length
  for(j in 1:cls2){ # destination length
    if(j>=i & j<=(i+3)) tx[i,j]=valt
  }
}
#tx
#
# Simple R matrix multiplication
mx2 <- mx %*% tx

#
# - this is incorrect because it ignores lengths in each age class < start lengths
# - but does demonstrate the basic R matrix multiplication function
#
# Matrix by vector operation to transition fish at length in each age class
cls3 <- dim(mx)[2]   # age
mx3 <- mx
mx3[,] <- 0
for(j in 1:cls3){
  tmp <- mx[,j]
  mx3[,j] <- tmp %*% tx
}
#mx3
#
# Test repeating this operation very large number of times
nsim <- 10
start.time <- Sys.time()
for(i in 1:nsim){
  print(paste(" Simulation no.:  ",i,sep=""))
  
  cls4 <- dim(mx)[2]   # age
  mx4 <- mx
  mx4[,] <- 0
  for(j in 1:cls4){
    tmp <- mx[,j]      # vector of lengths within each age-class
    mx4[,j] <- tmp %*% tx
  }
}
end.time <- Sys.time()
run.time <- end.time - start.time
run.time
#Time difference of 24.10591 secs
#
################################################################################
#
#             Optimised matrix operation
# Test with sparse matrix repeating this operation very large number of times
#
library(RTMB)
library(Matrix)
nsim <- 10

# Declare objects as adsparse and advector
rws <- 1000   # length
cls <- 1000   # age
#rws <- 10   # length
#cls <- 10   # age
valx <- 100
# - optimised constructor
mxsp <- Matrix(0,nrow=rws,ncol = cls,sparse=TRUE)
#
# - non-optimised constructor
#mxsp <- matrix(0,nrow=rws,ncol = cls)
#
# Set up a banded sparse matrix for population state and populate
for(i in 1:rws){   # length
  for(j in 1:cls){ # age
    if(i>=(j-2) & i<=(j+2)) mxsp[i,j]=valx
  }
}
#head(mxsp)
#table(mxsp)

# Set up a banded sparse matrix for growth transition matrix
valt <- 0.1
rws2 <- rws  # start length
cls2 <- rws2  # destination length
# - optimised constructor
txsp <- Matrix(0,nrow=rws2,ncol=cls2,sparse = TRUE)
#
# - non-optimised constructor
#txsp <- matrix(0,nrow=rws2,ncol=cls2)

# - populate the matrix
for(i in 1:rws2){   # start length
  for(j in 1:cls2){ # destination length
    if(j>=i & j<=(i+3)) txsp[i,j]=valt
  }
}
#head(txsp)
#table(txsp)

start.time <- Sys.time()
for(i in 1:nsim){
  print(paste(" Simulation no.:  ",i,sep=""))
  cls4 <- dim(mxsp)[2]   # age
  mx4 <- mxsp
  mx4[,] <- 0
  for(j in 1:cls4){
    tmp <- mxsp[,j]      # vector of lengths within each age-class
    mx4[,j] <- txsp %*% tmp
  }
}
end.time <- Sys.time()
run.time <- end.time - start.time
run.time
# Time difference of 5.940471 secs

# Relative performance improvement
percent_reduction <- (24.10591-5.940471)/24.10591
# 0.7535679

