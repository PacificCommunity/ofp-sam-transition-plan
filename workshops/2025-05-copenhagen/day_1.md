Tobias has made public an early development version of a package that estimates:

- Movement
- Habitat preference

Nonlinear relationship between effort and F

IATTC SKJ study produced:
- Relative biomass index
- Absolute biomass index: one data point

## Data

In the data, we often see a large number of recaptures occurring in the first
month or so.

## Stock assessment

Mixing period, related to the large assessment regions and a quarterly time
scale. Probably not be a similar issue

Reporting rate

## Mildenberger-Nielsen model

Advection diffusion

An important component and assumption in the model is how movement is dictated
by the environment, such as SST.

One of the main innovations in this model is the calculation of derivatives
related to continuous tag movement and the discrete SST data.

Uses the Kalman filter.

We want to estimate movement and mortality from many tags in a large area

Using matrix exponential with movement, F, and M

Movement matrix by number of cells

Based on a paper by Thorson et al. (2021) Estimating fine-scale movement rates
and habitat preferences using multiple data sources

Fields are constructed from environmental inputs and splines

Archival tags are recaptured repeatedly

Differentiability is a challenge that was solved using local regression (after
considering splines or neural networks). The local regression achieves
differentiability by using iterative cosine functions.

Consider an environment variable such as SST, plotted as a discrete heatmap on x
and y (lat and lon). To produce a continuous heatmap that is differentiable, we
use local regression with regression R=1.

The modelling approach used for the IATTC SKJ study, archival tags were used to
estimate movement, while conventional tags were used to estimate stock size
trends.

Kalman filter:

```
true position     a0 -> a1 -> a2 -> an
observed position p0 -> p1 -> p2 -> pn
observation variance, successive algorithm
assumes linear system with normal errors
```

The Kalman filter gave comparable results to a matrix exponential approach, but
the Kalman filter was used because of the speed advantage.

Advection is alpha, diffusion is D

The biomass index that the model produces in the end has the same temporal
resolution as the catch and effort data, e.g. annual or quarterly. In the IATTC
study, the effort data were not considered reliable, which made the estimation
of biomass indices more difficult.

--------------------------------------------------------------------------------

SEAPODYM handles tags using the TAGEST approach by Sibert et al. (1998).

A key difference in how the Mildenberger-Nielsen model and SEAPODYM handle tags
is that SEAPODYM resolves the spatial dynamics of recaptured tags with an
advection-diffusion equation. The tags are analyzed in groups, while the
Mildenberger-Nielsen model keeps track of individual tags.

SEAPODYM is estimating the movement pattern of recovered tags only. This is
different from the DTU model, which attempts to estimate the movement pattern of
all fish, by considering how representative each tag and recovery is.
