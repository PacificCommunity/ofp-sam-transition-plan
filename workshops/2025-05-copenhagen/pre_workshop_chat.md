# Initial online meeting, 21 Jan 2025

Anders Nielsen, Arni Magnusson, Joe Scutt Phillips, John Hampton, Tobias Mildenberger

--------------------------------------------------------------------------------

- Project with IATTC, analyzing SKJ tags in EPO
- Jim Thorson's matrix exponential was too slow
- Tried Kalman filter
- Both archival tags and traditional tags
- Smooth field of advection and diffusion
- Represent environmental field with something smooth and differentiable
- Asked Kasper and he added `interpol2d()` that sets a smoothing radius
- Smoothing radius of 1 is no smoothing
- Inna Senina has used kernel smoothing for a similar purpose
- Seapodym uses tags only to estimate movement

--------------------------------------------------------------------------------

- Anders would prefer to have the tagging analysis within the assessment model
- Big assumption that movement is dictated by environmental conditions
- Absolute biomass index based on Peterson method
- In addition to the purposes of the stock assessment, this is valuable research
- Demographic parameters
- Movement parameters
- Length-specific fishing mortalities
- Tag mixing
- Reporting rates
- Depends on effort data that is important for biomass estimation
- SPC has decent effort data from SKJ fisheries
- Free school and FAD associated fisheries
- SPC has 100 thousand recaptures, 1 or 2 orders of magnitude more data than EPO
- M and F are length-structured
- No size- or age-dependent movement

--------------------------------------------------------------------------------

- Tobias has developed an RTMB package that will facilitate the work
- He is currently writing a vignette that uses simulated data

**Next steps**

- Draft a work plan for the first workshop

- The vignette can serve as a basis for a work plan, demonstrating the types of data that will be used in the analysis and their format
