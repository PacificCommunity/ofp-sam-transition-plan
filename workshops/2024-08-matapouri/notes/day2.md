## Upcoming simulation study, comparing existing platforms

Gadget has the ability to simulate an age-length structured population, but it
would be beneficial to use an operating model that is different from any of the
estimation models

Craig's ABM is based on SPM, a previous NIWA operating model developed by
Alistair Dunn for CCAMLR studies of toothfish

Like Gadget, Craig's ABM has the ability to simulate an age-length structured
model

SPM was used in the IOTC YFT simulation study

SPM and ABM are related to Casal2

## Chat with Jeremy McKenzie

Operating model, agent-based model (ABM)

In an individual-based model, each agent is one fish, while in an agent-based
model, each agent is a collection of fish

Developed by Craig Marsh

Additional features could be implemented

Upcoming simulation study, comparing MULTIFAN-CL and alternative stock
assessment platforms (Stock Synthesis, Gadget, Casal)

The population has length, age, and time dimensions

Tags pose a challenge in an agent-based model, since tag releases and recaptures
occur at a smaller scale

You can keep track of the number of real tags that is contained in an agent,
e.g., one agent that consists of 1000 fish might contain 1 tag, and another
agent that also consists of 1000 fish might contain 3 tags

---

Richard Bian (NIWA Auckland, great coder) and Jeremy McKenzie (NIWA Auckland)

Alistair and Scott are the Casal and SPM experts

---

Casal1 input files/templates:
- Population file - initial parameters, selectivity type, time steps
- Estimation file - which parameters will be estimated, observed data
- Control file - other settings

---

Craig's ABM was used in his Ph.D. thesis and also in a Ministry project looking
at time-varying R0 (climate change productivity shift) for Snapper-8 on the NZ
west coast, using Stock Synthesis as an estimation model that allows a regime
shift

NZ FAR report documents the Ministry project simulation study

## Project outcome

The best outcome for SPC would be to migrate MFCL assessments to stock
assessment software that has the following characteristics:

1. Estimation performance should be good, especially in terms of bias, both
   based on self-simulation and fitting to data simulated by a more complex
   operating model

2. Model features should make good use of all available data and allow the
   modelling of processes that are important for each stock

3. User interface and model complexity should allow a recently hired scientist
   to conduct an assessment with relative ease and confidence, being able to
   understand the model and ensure the quality of the assessment

4. User support should be strong, both on-site and in the general scientific
   community

5. Beneficial if other tuna RFMOs use the same stock assessment software
