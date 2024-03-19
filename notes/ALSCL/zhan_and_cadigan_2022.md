# ALSCL

**An age- and length-structured statistical catch-at-length model for
hard-to-age fisheries stocks**

Fan Zhang and Noel G. Cadigan. 2022. Fish and Fisheries 23(5):1121-1135

## ABSTRACT

Age-structured catch-at-length models (ACL) include Stock Synthesis and MFCL

When survey data are of high quality, a model based only on survey data can
provide good estimation of population dynamics

This paper introduces an age- and length-structured statistical catch-at-length
(ALSCL) model that estimates age-based dynamics from survey catch-at-length data

ALSCL can include length-dependent mortality and growth within a cohort by
tracking the population by time, age, and length

Simulations of yellowtail flounder and bigeye tuna demonstrate that ALSCL
outperforms ACL by providing more accurate estimates of age-based population
dynamics when length-dependent processes are important

Application to female yellowtail flounder on the Grand Bank off Newfoundland
using survey catch-at-length, weight-at-length, and maturity-at-length data

## 2 METHODS

### 2.1 MODEL STRUCTURE

Population dynamics, where l is length, a is age, t is time, and G is the Growth
transition matrix:

```
n[l|a,t] = G (n[l|a-1,t-1] * exp(-Z[l|t-1]))                         Eq. 1
```

The growth transition matrix is an LxL stochastic matrix, with each column
summing to tone, that changes the cohort length distribution over time:

```
    /             \
    |  p11 . p1L  |
G = |   .  .  .   |                                                  Eq. 3
    |  pL1 . pLL  |
    \             /
```

Growth follows a reparametrized von Bertalanffy function (Millar and Notthingham
2019), overcoming the problems that can arise when length bins are greater than
Linf

```
                      delta[max]
mu[x] = ---------------------------------------                      Eq. 6
         1 + exp(-log(19) * (x-L50)/(L95-L50))
```

Fishing mortality is length-dependent and is stochastic and correlated across
lengths and time steps, where log(F[l,t]) has a multivariate normal (MVN)
distribution with a common mean for all l and t (mu[F]) and a separable
covariance matrix Sigma[F],

```
Cov(Sigma[F,l,t], Sigma[F,l-i,t-j]) = f(sigma[F], phi[L], phi[T])    Eq. 7
```

where phi[L] is length autocorrelation and phi[T] is time autocorrelation

The F parameters to estimate are: mu[F], sigma[F], phi[L], and phi[T]

For simplicity, we assume that M is known and constant as 0.2

Recruitment is also stochastic and follows a first-order autoregressive process
AR(1),

```
r[t] = rbar * exp(eps[t])                                            Eq. 8
```

where rbar is the median recruitment and eps[t] is MVN with mean 0 and AR(1)
covariance with correlation phi[r]

The initial population follows an age-dependent stochastic equilibrium
distribution:

```
n[a,1] = r[1] * exp(-Zinit * (a-1)) * exp(eps[a]), a = 1, ..., A    Eq. 11
```

### 2.2 PARAMETER ESTIMATION

ALSCL only estimates trends in relative stock size, but it does provide absolute
estimates of F.

### 2.3 SIMULATION STUDY

Biology, fishing selectivity, and fishing mortality/growth within cohort:

OM | Biology             | Selectivity | Mortality and growth
-- | ------------------- | ----------- | --------------------
1  | Yellowtail flounder | Flat        | Length-dependent
2  | Yellowtail flounder | Asymptotic  | Length-dependent
3  | Yellowtail flounder | Dome shape  | Length-dependent
4  | Bigeye tuna         | Flat        | Length-dependent
5  | Bigeye tuna         | Asymptotic  | Length-dependent
6  | Bigeye tuna         | Dome shape  | Length-dependent
7  | Yellowtail flounder | Flat        | Age-dependent
8  | Yellowtail flounder | Asymptotic  | Age-dependent
9  | Yellowtail flounder | Dome shape  | Age-dependent
10 | Bigeye tuna         | Flat        | Age-dependent
11 | Bigeye tuna         | Asymptotic  | Age-dependent
12 | Bigeye tuna         | Dome shape  | Age-dependent

## 3 RESULTS

### 3.1 SIMULATION STUDY

ALSCL outperformed ACL for all operating models with length-dependent
selectivity, regardless of the species or patterns of fishing selectivity at
length.

Figure 3. Mean absolute relative errors for Rec, SSB, B, N, vbk, and Linf.

Figure 4. Mean relative bias for Rec, SSB, B, N, vbk, and Linf.

Figure 5. Mean absolute relative errors for numbers at age 1, ..., 9+.

Figure 6. Mean relative bias for numbers at age 1, ..., 9+.

### 3.2 CASE STUDY

Female yellowtail flounder on grand Bank off Newfoundland between 1996 and 2017.

Figure 7. Estimated Rec, N, SSB, B, growth curve, and annual Fbar.

Figure 8. Estimated numbers at age 1, ..., 9+.

## NOTES

### REPOSITORY

https://github.com/Linbojun99/ACL

### QUESTIONS

- Do the simulated datasets include commercial catch?
- Do the operating models estimate the shape of the selectivity curve?
