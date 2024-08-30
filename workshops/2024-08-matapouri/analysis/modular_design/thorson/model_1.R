library(RTMB)

nll = function(p){
  getAll(p)
  -1 * sum(dnorm(Y, mean=mu, sd=sd, log=TRUE))
}

run = function(mean=0, sigma=1){
  environment(nll) <- environment()
  Y = rnorm(100, mean=0, sd=sigma)
  obj = MakeADFun( func=nll,
                   parameters = list('mu'=0, 'sd'=1) )
  opt = nlminb( start=obj$par,
                objective = obj$fn,
                gradient = obj$gr )
  return(opt)
}

# Fails with `Y` generated in a function
out = run()

# Works with `Y` in global environment
Y = rnorm(100)
run()
