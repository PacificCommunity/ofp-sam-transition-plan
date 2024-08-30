In RTMB, models can use the plain `matrix` object and RTMB will use sparse
matrix computations.

The first benchmark in `script.R` indicates that when 25% of the matrix contains
non-zero values, the `Matrix` package can perform matrix multiplication in 25%
of the original time (3x faster) that it would take using plain `matrix`
objects. In other words, the `Matrix` package works very well for multiplying
sparse matrices.

The second benchmark in `script.R` indicates that when an RTMB objective
function multiplies plain `matrix` objects, it takes around 50% of the original
time (2x faster). In other words, RTMB employs automatic sparse matrix
multiplication even though the model code uses plain `matrix` objects.
