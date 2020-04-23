# Computing pi

A few applications that compute pi.

## What is it?

1. `compute_pi.f90`: pi is computed by computing the quadrature of the function
   `sqrt(1 - x**2)` over the interval [0, 1].
1. `compute_pi_omp.f90`: pi is computed by computing the quadrature of the function
   `sqrt(1 - x**2)` over the interval [0, 1].  Uses OpenMP for parallelization.
1. `CMakeLists.txt`: CMake file to build the applications.
