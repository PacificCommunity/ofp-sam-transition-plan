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

## 6. Recommendations

**Funding the research**

**Future workshops**

## 7. Website

**Presentations**

**Data**

**Software**
