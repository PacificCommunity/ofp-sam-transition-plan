Hey Arni,

Some thoughts on key needs of this platform from me:

1. It will be important for it to have some analogue of the r4ss package i.e., functions create and read the input/output, key diagnostic and plotting routines
2. Spatial stock assessment options (i.e. more than two areas, more complicated options for movement)
3. Improved format for the I/O
4. A statistical suggestion: opt for a platform with the capability of RCM (https://openmse.com/tutorial-rcm/).  You’re probably aware, but this samples from priors, and for each sample estimates R0 etc.. In this way we can include all the uncertainty with steepness, M, and other life-history parameters in the determination of stock status.  Since SS and any other platforms using ADMB rely on be able to invert the hessian to get the covariance matrix to do MCMC, any time a parameters is not estimable then its uncertainty is often (if not usually) fixed. The result of this is that the quantities of greatest management importance (i.e. those that determine FMSY) are not well represented in the assessment
5. Related to 4 above, allow for easy useability/import of the assessment model into OM
6. A plan for continued support for the above in the future

That's all from me for now. I thought it might be helpful to have it in writing in advance of our call later.

And one more thing: I saw the US give a presentation developing a new platform for assessment at the 2022 ICES meeting. Presumably, it would be good to coordinate with that?

Nathan
