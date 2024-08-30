This benchmark indicates that when 25% of the matrix contains non-zero values,
the `Matrix` package can perform matrix multiplication in 25% of the original
time (3x faster) that it would take using plain `matrix` objects. In other
words, the `Matrix` package works very well for multiplying sparse matrices.
