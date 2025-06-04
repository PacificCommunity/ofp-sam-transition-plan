## momo demo on WCPO SKJ ctags
## 14/05/2025
## Tobias Mildenberger (tobm@aqua.dtu.dk)


## Load packages
require(momo)
require(lubridate)

## Download data if necessary
get.data <- function(file)
{
  dir.create("data", showWarnings=FALSE)
  destfile <- file.path("data", file)
  if (!file.exists(destfile)) {
    download.file(file.path("https://github.com/PacificCommunity",
                            "ofp-sam-transition-plan/releases/download",
                            "spatio-temporal-data", file), destfile)
  }
  destfile
}

## Load env data
mld <- readRDS(get.data("po_jra55np_1x30d_mld_1958_2022.RDS"))
t <- readRDS(get.data("po_jra55np_1x30d_T_L1_1958_2022.RDS"))
sst <- readRDS(get.data("po_jra55np_1x30d_sst_1958_2022.RDS"))
u <- readRDS(get.data("po_jra55np_1x30d_V_L1_1958_2022.RDS"))
v <- readRDS(get.data("po_jra55np_1x30d_U_L1_1958_2022.RDS"))

# Load ctags
dat0 <- read.csv(get.data("WCPO_SKJ_Reliable_Recoveries.csv"))

## Convert longitudes from [-180,180] to [0,360]
dat0$x0 <- ifelse(dat0$x0 < 0, dat0$x0 + 360, dat0$x0)
dat0$x1 <- ifelse(dat0$x1 < 0, dat0$x1 + 360, dat0$x1)

## Convert dates to decimal years
dates <- lubridate::dmy(dat0$t0)
dat0$t0 <- lubridate::decimal_date(dates)

dates <- lubridate::dmy(dat0$t1)
dat0$t1 <- lubridate::decimal_date(dates)

## Any tags with release time > recapture time?
tmp <- dat0[which(dat0$t0 > dat0$t1),]
dim(tmp)

## remove non recaptured tags (effort nedded to include non-recaptured)
dat0 <- dat0[which(!is.na(dat0$t1)),]


## limit ctags to range of environmental data
range(as.numeric(attributes(mld)$dimnames[[3]]))
dat0 <- dat0[which(dat0$t0 < 2023),]
dat0 <- dat0[which(dat0$t1 < 2023),]

head(dat0)

ctags <- prep.ctags(dat0,
                    names = c("t0","t1",
                              "x0","x1",
                              "y0","y1"),
                    speed.limit = 200)

plotmomo.ctags(ctags, plot.land = TRUE)

dim(ctags)

## time at liberty
ctags$tal <- ctags$t1 - ctags$t0
hist(ctags$tal, 50)
sum(ctags$tal < 1/52)

## Get dimensions of tags tod define grid
get.dim(ctags)

range(ctags$t0)
range(ctags$t1)

## manually select grid
if(FALSE){

    grid <- create.grid(c(110, 290),
                        c(-40, 50),
                        dxdy = c(5,5),
                        select = 2,
                        plot.land = TRUE)
    plotmomo.grid(grid, plot.land = TRUE)

    full.grid <- expand.grid(attributes(grid)$xcen,
                             attributes(grid)$ycen)

    idx <- match(paste0(grid$xygrid[,1],"_",grid$xygrid[,2]),
                 paste0(full.grid[,1],"_",full.grid[,2]))
    print(group.consecutive.ranges(idx))

}else{

    idx <- c(9:35,45:72,81:108,117:144,146:147,152:180,182:184,186,188:215,218:222,225:250,254:257,259:286,290:322,325:358,361:392,397:426,434:461,471:495,508,510:531,547:566,583:601,619:637)

    grid <- create.grid(c(110, 290),
                        c(-40, 50),
                        dxdy = c(5,5),
                        select = idx,
                        plot.land = TRUE)
    plotmomo.grid(grid, plot.land = TRUE)

}

env <- list(t = prep.env(t), mld = prep.env(mld)) ## sst = prep.env(sst))

str(env,1)

## plotmomo.env(env$sst[,,1:4], plot.land = TRUE,
##              xlab = "lon", ylab = "lat", bg = "white")

plotmomo.env(env$t[,,1:12], plot.land = TRUE,
             xlab = "lon", ylab = "lat", bg = "white")

plotmomo.env(env$mld[,,1:12], plot.land = TRUE,
             xlab = "lon", ylab = "lat", bg = "white")


## For now: subset tags
ctags2 <- ctags[which(ctags$tal > 1/12),]
hist(ctags$t0)

ctags2 <- ctags2[which(ctags2$t0 >= 2006),]
ctags2 <- ctags2[which(ctags2$t0 < 2007),]
dim(ctags2)

plotmomo.ctags(ctags2, plot.land = TRUE)

dat <- setup.momo.data(grid = grid,
                       env = env,
                       ctags = ctags2)

dat$knots.tax

## Release events
tmp <- get.release.events(dat,
                          grid = create.grid(dat$xrange, dat$yrange, c(0.5,0.5)),
                          time.cont = seq(dat$trange[1], dat$trange[2],
                                          1/(52*diff(dat$trange))))
dat$rel.events <- tmp$rel.events
nrow(tmp$rel.events)
dat$ctags$rel.event <- tmp$idx

## use default configurations
conf <- def.conf(dat)
conf$ienv$tax

conf$use.rel.events <- TRUE


## use default inital values
par <- def.par(dat, conf)


## Fit the model
fit <- fit.momo(dat, conf, par,
                verbose = TRUE)

## nlminb output
fit$opt

fit$dat$knots.tax

## Some plotting functions
plotmomo.pref(fit)
plotmomo.pref(fit, data.range = TRUE)

plotmomo.pref.spatial(fit,
                      select.y = 2006.8,
                      plot.land = TRUE)

plotmomo.dif(fit, cor = 0.5,
             col = 4, lwd = 2,
             plot.land = TRUE)

plotmomo.taxis(fit, cor = 0.01,
               average = TRUE,
               col = 4, lwd = 2,
               plot.land = TRUE)

plotmomo.ctags(fit, plot.land = TRUE)

plotmomo.grid(grid, plot.land = TRUE)


## Save fit (for reproducing graphs)
saveRDS(fit, file = paste0("fit_",format(Sys.time(), "%Y%m%d_%H%M%S"),".rds"))
