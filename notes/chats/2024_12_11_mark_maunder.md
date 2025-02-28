# Chat About Next Tuna Stock Assessment Software

Online meeting, 11 December 2024

Arni Magnusson, Mark Maunder

## 1 Simulation study

The scoping project for the next tuna stock assessment platform involves the
design of a simulation study that could guide the ongoing and future development
of software platforms. One key design decision is whether it's important to
implement software platforms so that model population have an explicit age and
length structure.

Therefore, the main objective of a simulation study would be to evaluate the
potential importance and usefulness of stock assessment models having an
explicit age and length structure. There is, however, a considerable risk in any
simulation study that the results can be difficult to interpret and use as a
guidance for model configuration and development.

One idea for this simulation study would be to use an agent-based operating
model that is quite different from existing stock assessment software platforms.
This would give all estimation models an equal chance to perform well, rather
than giving an advantage to the estimation models that most resemble the
operating model.

Another idea would be to design the simulation study using Gadget as both the
operating and estimation model. Gadget is a widely used software platform that
offers explicit age and length structure in the population. Using the same
platform to implement the operating and estimation models could more precisely
measure the benefit of explicit age and length structure. Relevant questions to
explore initially include:

- Can Gadget simulate observed tagging data?

- Can Gadget implement an estimation model that has a simple age structured
  population model?

## 2 Analysis of Tags in MULTIFAN-CL Uses Parallel Populations

It is possible that tags in Stock Synthesis also uses parallel populations. We
could follow up with the Stock Synthesis development team and discuss the
current (and possible future) implementation of how tags are analyzed in Stock
Synthesis.

## 3 External Analysis of Tags

IATTC used the Mildenberger-Nielsen spatiotemporal tagging model for the 2024
skipjack tuna (SKJ) assessment in the Eastern Pacific Ocean (EPO). This analysis
of tags, conducted outside of the assessment model, produces absolute biomass
indices that are then incorporated as data into Stock Synthesis. The method is
based on advection-diffusion and the Peterson estimator.

This analytical approach successfully allowed IATTC to efficiently utilize the
tagging data in their 2024 SKJ EPO assessment. Mark recommends considering using
the Mildenberger-Nielsen spatiotemporal tagging model to analyze the tagging
data for SPC tuna assessments. By conducting the tagging data analysis outside
of the assessment model and incorporating the results as biomass indices into
the assessment model, it becomes unnecessary for the stock assessment software
to include an explicit tagging data module.
