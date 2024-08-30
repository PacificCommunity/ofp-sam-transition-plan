library(Matrix)

set.seed(1)

nrow <- 1000
ncol <- 1000

vals <- sample(c(0,0,0,100), nrow*ncol, TRUE)

m0 <- matrix(vals, nrow, ncol)
m1 <- Matrix(vals, nrow, ncol, sparse=FALSE)
m2 <- Matrix(vals, nrow, ncol, sparse=TRUE)

class(m0)
class(m1)
class(m2)

system.time(m0 %*% m0)
system.time(m1 %*% m1)
system.time(m2 %*% m2)
