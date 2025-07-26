1. What assessment software do you use for tuna and billfish assessments? If
   possible, can you indicate which software is used for which stock?

Historically the SBT stock assessment was coded in ADMB

However, over the past three years this code has been moved over to TMB and more
recently RTMB

--------------------------------------------------------------------------------

2. Are these software adequate for your current needs?

Yes, the software should be adequate for current needs but it can be altered
relatively quickly if anything comes up during next years' stock assessments

--------------------------------------------------------------------------------

3. Do you think they will still be adequate in 10 years? If not, what are the
   likely main inadequacies?

Yes I suspect that this software will still be adequate in 10 years

The new model is coded in RTMB and tailored to the SBT case and data
availability

It is unique but tactical in nature -- meaning that although the code is
specific to the current needs of SBT stock assessment, RTMB allows modifications
to be made to the code in minimal time

For example, a team of 5 people working for 5 days managed to port the code over
from TMB to RTMB, compare the new model to outputs from the ADMB model, address
issues during MCMC mixing caused by time varying selectivity specification
(moving from subjective penalised smoothers to more defensible 2D AR1
selectivity), defining a more appropriate CPUE-weighted length composition (and
associated selectivity) to be associated with a CPUE series, and more

This type of adaptability and progress would have been impossible in generalised
software platforms

--------------------------------------------------------------------------------

4. How important is explicit regional structure for the assessment and
   management of tuna and billfish stocks for your RFMO?

We don't track spatial structure explicitly

Rather we use the "areas-as-fleets" approach

The SBT current model has six separate fleets which have been identified by gear
and geographic area

--------------------------------------------------------------------------------

5. Are tagging data important for any of your assessments? If so, which
   assessments?

Yes, tagging data are important in SBT stock assessments, specifically for the
estimation of natural mortality parameters

--------------------------------------------------------------------------------

6. Given that Stock Synthesis is entering a sunset phase, do you have a strategy
   or plans in place for a post Stock Synthesis era? If yes, can you provide a
   brief description of your strategy or plans?

I've never used SS in my life and I intend to keep it that way

My personal opinion is that bespoke is better

However, I could be convinced
that semi-generalised models are an OK second choice

In my experience, fully generalised models are overrated because they become
outdated quickly, are much slower to run (often precluding Bayesian inference),
and often require the user to mold their fishery/data to the model rather than
the other way around

--------------------------------------------------------------------------------

7. How closely do you follow ongoing FIMS developments? Are you directly
   involved in discussions or experimental development?

FIMS looks like a nightmare

I intend to stay out of it

A colleague (J. Ianelli) follows the developments and notes that the expertise
and intentions are excellent, but that software by committee seems very tedious
and poorly adaptive

--------------------------------------------------------------------------------

8. Do you have any ongoing development work on improving existing stock
   assessment software or developing new software? If yes, can you provide a
   brief description?

The three year project to develop the SBT stock assessment is in its final
stages and the project is due for completion by the end of this calendar year

Next year we will be using the RTMB model for the first time as the main
operating model for SBT

Being the first year the model is actually being used there may be some
development early next year if any features are desired by those doing the stock
assessment

--------------------------------------------------------------------------------

9. Would you be willing to work collaboratively on the evaluation and/or
   development of software tailored for tuna assessments? If yes, is it likely
   that resources or scientist time might be available for this?

Yes I would be willing to work collaboratively, particularly on the development
of software tailored for tuna stock assessments

If RTMB is the platform of choice then I suspect that a lot of code from the SBT
model can simply be ported over

I also have a hefty code base for the semi-generalised New Zealand rock lobster
(CRA) stock assessment model that was recently coded in RTMB and much of that
code may be useful also

This model is semi-generalised in that it will serve as the main stock
assessment for at least eight New Zealand rock lobster stocks (but is capable of
dealing with other length-based stocks)

Furthermore, after coding the SBT and CRA stock assessment models in RTMB I have
a few ideas about model structure now too (what is and is not possible,
input/output workflow, etc.)

I have no idea about resources

CCSBT may be willing to cover some of my time

New Zealand may or may not be interested in covering some of my time also

--------------------------------------------------------------------------------

10. Would your team be interested in attending an online CAPAM workshop focusing
    on current and future development of new stock assessment platforms to meet
    the needs of future tuna assessments?

Sure, but in person would be better

It is amazing how much more progress can be achieved during in person meetings
(our technical meeting in Seattle this year is a perfect example)
