# SPC-DTU Workshop

**Copenhagen, 12-16 May 2025**

Anders Nielsen, Arni Magnusson, Colin Millar, Inna Senina, Joe Scutt Phillips, Mark Maunder, Rujia Bi, Tobias Mildenberger

Group photo

## 1. Objective

Explore the possibility of applying the Mildenberger-Nielsen spatio-temporal tagging model to SPC tagging data. The end product of such an analysis could be a region-specific abundance index that can be incorporated in a tuna stock assessment. The workshop will focus on skipjack tuna in the western and central Pacific Ocean.

## 2. Agenda

The 5-day workshop was spent discussion the current methodologies employed for analysing tagging data by both SPC and the team at DTU Aqua/IATTC, comparing them conceptually and how they are similar/different, describing and exploring the available data in the WCPO for such analyses, and discussing a workplan for implementing spatiotemporal models using WCPO tagging data into the future.

**Day One**
- Current use of tagging data in WCPO tuna stock assessments, their influence and uncertainties in abundance indices
- Overview of the Mildenberger-Nielsen spatiotemporal tagging model
- Overview of SEAPODYM, with a focus on its integration of tagging data

**Day Two**
- Overview of data issues, quality and use in WCPO/EPO
- Discussion on differences between advection-diffusion movement models
- Development of proposed models for a WCPO application of the Mildenberger-Nielsen model

**Day Three**
- Overview of momo R-package and use
- Data selection and preparation for proposed models
- Preliminary work on simplified model using WCPO data

**Day Four**
- Continued preliminary model development
- Presentation of IATTC models and results

**Day Five**
- Preliminary model results
- Wrap up and next steps

## 3. Presentations

## 4. Activities

**Model demonstration**

Tobias demonstrated the `momo` package, walking through the vignette example.

## 5. Outcomes

**Data discussion**

**Model discussion**

**Brief comparison of the DTU model and SEAPODYM**

The DTU model `momo` takes the starting point from the model suggested in Thorson et al. (2021), where advection, taxis, and diffusion are defined via environmental fields. Preference splines are estimated, and the preference field's value at each point in the spatial domain is expressed as the sum of the splines evaluated at that point. The taxis is defined as the gradient of the preference field. Similarly, a field is defined for the diffusion. The movement model can be solved via different numerical approximations, where one is the matrix exponential. Another is the Kalman filter --- the latter is faster, but will not be a good approximation if the probability distribution of an individual's final location is not well approximated by a 2D Gaussian (think equal probability of going left or right around an island).

Tags are returned from the fishery, so if the probability of recapture is uneven w.r.t. the environmental indices, then this recapture probability needs to be accounted for. An observed recapture should be weighted higher if it is returned from an area with low recapture probability, because it is representative of more unrecaptured tag histories than a tag recaptured from an area with high recapture probability. Fishing effort measures can be used to inform about the probability of recapture.

Using both recaptured and not recaptured tags, it is also possible to estimate fishing mortality and natural mortality. For all tags the likelihood of their catch history are computed (conditioned on their path), and added to the total objective function. The likelihood of the catch histories are computed via step-wise application of the catch and survival equation.

As a separate step, after the movement pattern has been estimated, it is possible to produce a biomass estimate. Two approaches have been explored:
1. If the estimation of natural mortality M and spatial fishing mortality is considered reliable, then for each catch cell, it is possible to isolate N in the catch equation (in each cell where catch is available).
2. If only the estimated movement pattern is considered reliable, then it is possible to apply a Peterson-inspired estimator in each cell using the fraction of tagged fish out of the total catch. Both of these two methods require a subsequent spatial smoothing of the cell-specific N estimates to estimate the total biomass in an area.        

The model is optimized by maximum likelihood estimation, where the probability of seeing all tag histories is optimized.

**Future development of the DTU model**

The current version of the R package allows for the estimation of habitat
preference functions and movement patterns based on archival and conventional
tagging data with and without effort information. It does not yet include, the
length-structured tagging model or biomass model. There are a number of
important improvements to the DTU model, some of which are particularly relevant
for the application to WCPO tagging data.

Tagging model (only)

- Implement boundaries (islands)
- Further R package development (speed up MakeADFun)
- Habitat preference functions by length classes
- Extended and unscented Kalman filter and other PDE solvers
- Better environmental fields with depth integration (e.g. prey fields from SEAPODYM)
- Explore archival SKJ tags (from Japanese colleagues)
- Account for uncertainty of recapture time and location of tags
- Effort scenarios and effort creep scenarios and its effect on habitat
  suitability and movement patterns
- Explore options of including FADs as effort indicator or attractors
- Explore suitability of geographical fields to inform habitats
- Extend simulation-estimation framework


Biomass model (and tagging model)

- Combine ideas of both biomass models (Peterson-inspired and effort biomass
  model)
- Integrate biomass and movement model
- Extend to length-structured population model


**General work plan**
A series of modelling exercises were discussed and proposed for a potential application of the momo package for WCPO skipjack tuna. These were designed to be somewhat incremental in their complexity, permit meaningful comparisons with existing advection-diffusion movement models (i.e. SEAPODYM, those estimated for IATTC), and explore the possibility for providing absolute or relative indices of abundance/fishing mortality.

| Model         | Objective         | Tagging Data      | Environmental Data        | Fisheries Data        |
|:---           |:---               |---:               |---:                       |---:                   |
|SEAPODYMomo    |Comparison of estimated env preferences and H|SEAPODYM Dataset (Grouped WCPO & EPO Recaps)|Temp & Currents from L1 Epipelagic layer, MLD and SST|None|
|SEAPODYMomo WCPO|Same as above but using all recaptures|All Reliable WCPO Recaptures|As above|None|
|Momo WCPO|Estimate "Full" Momo model providing F and abundance indices|All WCPO Tags (including unreported)|As above|Effort data|
|Momo WCPO Peterson-type|Estimate movement model for absolute abundance estimates|All Reliable WCPO Recaptures (archival?)|To be examined (preferably JRA55-nm family) |Catch|


## 6. Recommendations

**Funding the research**

**Future workshops**

## 7. Website

**Presentations**

**Data**

**Software**
