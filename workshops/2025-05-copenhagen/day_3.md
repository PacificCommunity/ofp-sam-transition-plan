The momo model

https://github.com/tokami/momo

No biomass or length comps

Documentation

Homepage     https://tokami.github.io/momo/
Get started  https://tokami.github.io/momo/articles/momo.html
Manuscript   https://tokami.github.io/momo/articles/tutorial.html

One manuscript is a simulation, where we know the true values and use an
operating model that adds noise to produce an observed dataset. We then apply
the estimation model and evaluate the estimation performance, based on the
estimation accuracy for key parameters.

Another manuscript focuses on the likelihood, comparing observed and expected
recaptures.

The simulated data are based on a certain number of conventional and archival
tag (nc=400, na=20).

```
library(momo)

## Simulate a small tagging data set
sim <- sim.momo()

## Fit momo to the simulated data
fit <- fit.momo(sim)

## Plot simulated data and model predictions
plotmomo.compare(sim = sim, fit = fit)
```

---

## Discussion with Mark

**1. Usefulness of SKJ effort data**

Freeschooling (unassociated) purse seine data might be useful

Another approach could be to use the effort from the CPUE analysis, based on
purse seine (areas 6-8) and pole and line

**2. Prey data layer**

SEAPODYM model studies have produced a prey data layer, based on oceanographical
and biological estimates. Movement is probably more dictated by prey than by
temperature.

**3. Comparison of DTU model and SEAPODYM**

DTU model considers each tag separately, using Kalman filter

SEAPODYM considers tags grouped, treated as a density, using only recaptured
tags

**4. Extending the DTU model to be a full stock assessment model**

