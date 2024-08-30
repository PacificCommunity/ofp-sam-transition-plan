rm(list = ls())
gc()
library(RTMB)

source("glam.r")
source("check_convergence.r")
source("run_glam.r")
source("run_retro.r")
source("run_peel.r")


## Load data ####
load("WF_sim_data.Rdata")
# summary(data)

## Run RTMB ####
# initial parameters
pars = list(log_sig = -2,
    log_M = data$log_M_init,
    log_q_trap = -5,
    log_q_gill = -5,
    log_q_trap_dev = numeric(data$n_years - 1),
    log_q_gill_dev = numeric(data$n_years - 1),
    log_sel_trap_p1 = 6.06,
    log_sel_trap_p2 = -2.9,
    log_sel_gill_p1 = -2.1,
    log_sel_gill_p2 = 1.82,
    log_sel_trap_dev = numeric(data$n_years - 1),
    log_sel_gill_dev = numeric(data$n_years - 1),
    log_pop_init = rep(9, data$n_ages - 5),
    log_recr_init = 12,
    log_recr_avg = 12,
    log_recr_dev = numeric(data$n_years - 1),
    acor = 0.5)

# fixed_names = c("log_M")
fixed_names = NULL
res = run_glam(nlminb_control = list(
                      eval.max = 1e4,
                      iter.max = 1e4,
                      trace = 0
                    ),
                    hessian_run = FALSE,
                    run_newton = TRUE,
                    n_newton = 3,
                    fixed_names = fixed_names)

check = res$check
check$convergence
check$message
check$max_gradient
check$whichbad_params # should be NULL if there are no issues
check$whichbad_eigen # should be NULL if there are no issues
report = res$report$out
sdrep = res$sdrep


## Run Retrospective Analysis ####
retro_res = run_retro(n_peel = 10) # takes a bit of time to run
retro_report = lapply(retro_res, function(x) x$report)
peel_years = lapply(retro_res, function(x) x$peel_years)
# plot
ramp = colorRamp(c("#ee8804", "purple4"))
col_vec = rgb(ramp(seq(0, 1, length = 10)), max = 255)

# SSB retro
ssb = lapply(1:length(retro_report), function(x) retro_report[[x]]$sp_biomass)
range_ssb = range(unlist(ssb))
# pdf(file = "retro_SSB.pdf", width = 6, height = 5)
    par(mar = c(4.5, 4.5, 1, 6))
    plot(data$years, seq(0, range_ssb[2], length.out = data$n_years),
        type = "n", ylim = range_ssb, ylab = "Spawning Biomass",
        xlab = "Years", xaxt = "n")
    axis(1, at = seq(1985, 2020, 5))
    for(y in 1:length(ssb)) lines(peel_years[[y]], ssb[[y]], col = col_vec[y])
# dev.off()

