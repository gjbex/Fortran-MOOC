# BLAS and Lapack

BLAS and Lapack are two libraries for matrix computations and linear algebra
that are widely used in scientific computing.  Here you'll find some
illustrations of their use.


## What is it?

1. `init_mod.f90`: module containing initialization procedures common to all
   applications.
1. `no_blas_probabilities.f90`: program that doesn't use BLAS or Lapack at all
   as performance baseline.
1. `blas_probabilities.f90`: implementation of `no_blas_probabilities.f90` that
   uses BLAS calls.
1. `normalize.f90`: simple program with some BLAS calls.
1. `copy.f90`: program to explore the arguments of level 1 BLAS
   `scopy` calls.
1. `dot.f90`: program to explore the arguments of level 1 `sdot`
   calls.
1. `ddot_timing.f90`: program to time difference between `ddot` and a loop-based
   implementation.
1. `gemv.f90`: program to illustrate matrix-vector product.
1. `gemv_vs_trmv.f90`: program to time `sgemv` versus `strmv` for triangular
   matrices.
1. `CMakeLists.txt`: CMake file to build the applications.
1. `blas95`: illustration of using the BLAS95 interfaces.
