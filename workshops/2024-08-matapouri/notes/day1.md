# Notes from Matapouri 2024

## Reasons we are interested in integrated age-length structure

Punt et al. (2020) list this is their first recommendation.

1. Spatial heterogeneity in biological processes, particularly growth

Two regions with different growth curves.

Genetic and environment: individual growth depends on where they were born and
where they live.

Fish cannot shrink when moving to a slow-growing region.

The solution is an integrated age-length structured model.

2. Cohort-specific fishing effects

Fast-growing individuals are fished harder when they are young.

In a fishery that has dome-shaped selectivity, the cohort will run the gauntlet
and at older ages, the slow-growing individuals are still being fished, while
the older are not subject to fishing anymore.

---

## Questions regarding Gadget

1. Has Gadget demonstrated the performance gain of sparse matrix detection and
   parallel processing?

2. Does Gadget estimate the length-based growth function, including Linf and
   variation?

3. Are tagged fish handled as separate tagged populations?

---

## Simulation study

By running a simulation study, we compare the run time of different software,
their relative accuracy, and the feature shortcomings.

Jeremy McKenzie has written an individual-based operating model that could be
used as an operating model to compare MFCL, Gadget, and other other software.

---

## Questions regarding Casal

1. Are tagged fish handled as separate tagged populations?

---

## Tagging module

Each release group represents a 'parallel' tagged population.

Dynamic processes are same as for untagged population, incl. movement.

For a tagged population, recruitment is the release event.

Tag releases are length-specific, transformed to age-specific via the estimated
growth function.

Mixing period is specified for assumed random mixing of tagged population.

Grouping of recaptures: specified fisheries for which recaptures are aggregated.

Pooling of tagged populations after a certain maximum number of periods at
liberty, accumulating older fish from all release groups.

Reporting rates can be release group-specific and fishery-specific, estimated or
assumed, can be shared between fisheries. Global upper bound, priors based on
seeding experiments, time-varying rates.

## Peterson equation

    n[1] * n[2]
N = -----------
         m

where N is population size, n[1] is the release sample, n[2] is the number of
fish examined for tags (sample size), and m is the number of recaptures.

Rearrange to:

 m     n[1]
---- = ----
n[2]    N

MFCL uses negative binomial likelihood, rather than Poisson used in Stock
Synthesis.

## Mixing period

If the mixing period functionality would not exist in MFCL, one could preprocess
the tagging data.

     |.
Ntag | ..
     |   ..........
     +-------------
           Time

100 fish were released at t[0], but after the mixing period of two quarters they
were equivalent of 25 released at t[2], because of recaptures and natural
mortalities.

The likelihood includes the fate of the 25 effective releases.

It would be difficult to encapsulate these dynamics by preprocessing the data if
M is estimated, because the 75 deaths were partly caused by natural mortalities.

## Predicting tag recaptures

        F
R = X * - * (1-exp-Z) * N[tagged]
        Z

where F is fishery-specific

## Tag likelihood

Negative binomial, estimating overdispersion

## Discussion

Mainly informing migration. Also M, especially for skipjack.
