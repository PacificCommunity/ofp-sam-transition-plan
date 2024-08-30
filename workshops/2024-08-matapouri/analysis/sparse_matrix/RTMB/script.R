library(Matrix)
library(RTMB)

nrow <- 1000
ncol <- 1000
vals <- sample(c(0,0,0,500), nrow*ncol, TRUE)
m0 <- matrix(vals, nrow, ncol)
m1 <- Matrix(vals, nrow, ncol)
system.time(for(i in 1:10) sum(m0 %*% m0) / 1e12)
system.time(for(i in 1:10) sum(m1 %*% m1) / 1e12)

source("recdata.R")

par <- list(logRmax=0, logS50=0, logSigma=0)
par <- unlist(par)

f <- function(par)
{
  Rmax <- exp(par[["logRmax"]])
  S50 <- exp(par[["logS50"]])
  sigma <- exp(par[["logSigma"]])

  S <- recdata$S
  R <- recdata$R

  Rhat <- Rmax * S / (S + S50)
  nll <- -sum(dnorm(log(R), log(Rhat), sigma, TRUE))

  nrow <- 1000
  ncol <- 1000
  vals <- sample(c(0,0,0,Rmax), nrow*ncol, TRUE)
  m0 <- matrix(vals, nrow, ncol)
  stuff <- sum(m0 %*% m0) / 1e12

  nll <- nll + stuff
  nll
}

obj <- MakeADFun(f, par)

system.time(opt <- nlminb(obj$par, obj$fn, obj$gr))
sum(opt$evaluations) * system.time(sum(m0 %*% m0) / 1e12)
system.time(print(nlminb(par, f)))
