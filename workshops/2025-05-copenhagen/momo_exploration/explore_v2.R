## momo demo on WCPO SKJ ctags
## 14/05/2025
## Tobias Mildenberger (tobm@aqua.dtu.dk)


use.currents <- TRUE
use.mld <- FALSE


## Load packages
require(momo)
require(lubridate)
require(sf)


## Load env data
mld <- readRDS("EPO Spatiotemporal Model/po_jra55np_1x30d_mld_1958_2022.RDS")
t <- readRDS("EPO Spatiotemporal Model/po_jra55np_1x30d_T_L1_1958_2022.RDS")
sst <- readRDS("EPO Spatiotemporal Model/po_jra55np_1x30d_sst_1958_2022.RDS")
u <- readRDS("EPO Spatiotemporal Model/po_jra55np_1x30d_V_L1_1958_2022.RDS")
v <- readRDS("EPO Spatiotemporal Model/po_jra55np_1x30d_U_L1_1958_2022.RDS")


# Load ctags
dat0 <- read.csv("EPO Spatiotemporal Model/WCPO_SKJ_Reliable_Recoveries.csv")

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
                        dxdy = c(10,10),
                        select = 2,
                        plot.land = TRUE)
    plotmomo.grid(grid, plot.land = TRUE)

    full.grid <- expand.grid(attributes(grid)$xcen,
                             attributes(grid)$ycen)

    idx <- match(paste0(grid$xygrid[,1],"_",grid$xygrid[,2]),
                 paste0(full.grid[,1],"_",full.grid[,2]))
    print(momo:::group.consecutive.ranges(idx))

}else{

    ## for dxdy = c(5,5)
    ## idx <- c(9:35,45:72,81:108,117:144,146:147,152:180,182:184,186,188:215,218:222,225:250,254:257,259:286,290:322,325:358,361:392,397:426,434:461,471:495,508,510:531,547:566,583:601,619:637)

    ## for dxdy = c(10,10)
    idx <- c(5:18,23:36,40:54,56:71,73:89,91:106,110:122,128:139,148:157)

    grid <- create.grid(c(110, 290),
                        c(-40, 50),
                        dxdy = c(10,10),
                        ## dxdy = c(5,5),
                        select = idx,
                        plot.land = TRUE)
    plotmomo.grid(grid, plot.land = TRUE)

}


## Define fine boundary layer
grid.bound <- create.grid(c(110, 290),
                          c(-40, 50),
                          dxdy = c(0.5,0.5),
                          plot.land = TRUE)
plotmomo.grid(grid.bound, plot.land = TRUE,
              labels = FALSE)

world_map <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE),
                      crs = 4326)
world_map <- st_make_valid(world_map)
pts_sf <- st_as_sf(grid.bound$xygrid, coords = c("x", "y"),
                   crs = st_crs(world_map))
on_land <- st_within(pts_sf, world_map, sparse = FALSE)
ind_land <- apply(on_land, 1, any)

bound <- grid.bound$celltable
bound[cbind(grid.bound$igrid[,1],grid.bound$igrid[,2])] <- 1
bound[cbind(grid.bound$igrid[ind_land,1],
            grid.bound$igrid[ind_land,2])] <- -1
grid.bound$celltable <- bound


env <- list(t = prep.env(t))

if (use.currents) {
    env <- c(env, list(u = prep.env(u), v = prep.env(v)))
}


if (use.mld) {
        env <- c(env, list(mld = prep.env(mld)))
}

plotmomo.env(env[[1]][,,1:12], plot.land = FALSE,
             xlab = "lon", ylab = "lat", bg = "white")


## For now: subset tags
ctags2 <- ctags[which(ctags$tal > 1/365),]
hist(ctags$t0)
range(ctags$t0)

ctags2 <- ctags2[which((ctags2$t0 >= 2006 & ctags2$t0 < 2011)),]

ctags2 <- ctags2[which(ctags2$x0 > 134),]
nrow(ctags2)

plotmomo.grid(grid, keep.gpar = TRUE, plot.land = TRUE)

plotmomo.env(env[[1]], select = 1:2, keep.gpar = TRUE, plot.land = TRUE)
points(150.337, -4.609)

## Check: any release or recapture locations on land?
world_map <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE),
                      crs = 4326)
world_map <- st_make_valid(world_map)
pts_sf <- st_as_sf(ctags2, coords = c("x0", "y0"),
                   crs = st_crs(world_map))
on_land <- st_within(pts_sf, world_map, sparse = FALSE)
ind_land <- apply(on_land, 1, any)

ind <- which(ind_land)
if(length(ind) > 0){
    writeLines(paste0(length(ind), " release location on land! Removing them."))
    ctags2 <- ctags2[-ind,]
}

pts_sf <- st_as_sf(ctags2, coords = c("x1", "y1"),
                   crs = st_crs(world_map))
on_land <- st_within(pts_sf, world_map, sparse = FALSE)
ind_land <- apply(on_land, 1, any)

ind <- which(ind_land)
if(length(ind) > 0){
    writeLines(paste0(length(ind), " recapture location on land! Removing them."))
    ctags2 <- ctags2[-ind,]
}

dim(ctags2)

plotmomo.ctags(ctags2, plot.land = TRUE)

dat <- setup.momo.data(grid = grid,
                       env = env,
                       ctags = ctags2,
                       boundary.grid = grid.bound)


dat$knots.tax <- matrix(c(24, 26 ,28), 3, 1)

if (use.currents) {
    dat$knots.tax <- cbind(dat$knots.tax,
                           matrix(rep(0, 6), 3, 2))
}

if (use.mld) {
    dat$knots.tax <- cbind(dat$knots.tax,
                           matrix(c(25, 50 ,75), 3, 1))
}

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

if (use.currents) {
    ## advection indices
    conf$ienv$adv.x[2,] <- conf$ienv$tax[2,]
    conf$ienv$adv.y[3,] <- conf$ienv$tax[3,]
    conf$ienv$tax[2:3,] <- 0
    conf$ienv$dif[2:nrow(conf$ienv$dif),] <- 0
}

conf$use.rel.events <- TRUE


## use default inital values
par <- def.par(dat, conf)

if (use.currents) {
    par$gamma[par$gamma != 1] <-  1
}


map <- def.map(dat, conf, par)

if (use.currents) {
    if (use.mld) {
        map$alpha <- factor(c(NA, 1, 2, rep(NA, 6), NA, 3, 4))
    }else{
        map$alpha <- factor(c(NA, 1, 2, rep(NA, length(par$alpha) - 3)))
    }
    map$gamma <- factor(rep(NA,length(par$gamma)))
}else if (use.mld) {
    map$alpha <- factor(c(NA, 1, 2, NA, 3, 4))
}


## Fit the model
fit <- fit.momo(dat, conf, par, map,
                do.sdreport = TRUE,
                do.report = TRUE,
                verbose = TRUE)

## Some plotting functions
plotmomo.pref(fit)

plotmomo.pref(fit, select = 1,
              data.range = TRUE, ylim = c(-100, 100))

plotmomo.pref.spatial(fit, select = 1,
                      select.y = 2015,
                      plot.land = TRUE)

plotmomo.dif(fit, cor = 0.5,
             col = 4, lwd = 2,
             plot.land = TRUE)

plotmomo.taxis(fit, cor = 1,
               average = TRUE,
               col = 4, lwd = 2,
               plot.land = TRUE)

plotmomo.ctags(fit, plot.land = TRUE)

plotmomo.grid(grid, plot.land = TRUE)


## Save fit (for reproducing graphs)
saveRDS(fit, file = paste0("fit_",format(Sys.time(), "%Y%m%d_%H%M%S"),".rds"))

dev.off()

## custom
png("spatial_habitat_pref.png", res = 120, width = 1900, height = 800)
years <- as.numeric(attributes(fit$dat$env[[1]])$dimnames[[3]])
## indi <- which(floor(years) == 2006)
indi <- c(which(floor(years) == 2013)[seq(2,12,3)],
          which(floor(years) == 2014)[seq(2,12,3)])
par(mfrow = c(2,4), mar = c(2,2,2,2), oma = c(2,2,1,1))
for(i in 1:length(indi)){
    plotmomo.pref.spatial(fit, select = 1,
                          select.y = years[indi[i]],
                          xlab = "",
                          ylab = "",
                          keep.gpar = TRUE,
                          plot.land = TRUE)
}
dev.off()


png("combi_plot.png", res = 120, width = 1400, height = 1200)
par(mfrow = c(2,2))
plotmomo.grid(grid, plot.land = TRUE, keep.gpar = TRUE,
              plot.grid = FALSE,
              labels = FALSE, main = "Mark-recpature tags")
plotmomo.ctags(fit, plot.land = FALSE, keep.gpar = TRUE, add = TRUE,
               col = adjustcolor("darkorange",0.5))
plotmomo.pref(fit, select = 1,
              main = "Temperature",
              data.range = TRUE, ylim = c(-100, 100),
              keep.gpar = TRUE)
plotmomo.dif(fit, cor = 0.1,
             main = "Diffusion",
             col = 4, lwd = 2,
             plot.land = TRUE, keep.gpar = TRUE)
plotmomo.taxis(fit, cor = 0.1,
               average = TRUE,
               main = "Average taxis (2006-2014)",
               col = 4, lwd = 2,
               plot.land = TRUE, keep.gpar = TRUE)
dev.off()
