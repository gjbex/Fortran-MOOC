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
1. `CMakeLists.txt`: CMake file to build the applications.