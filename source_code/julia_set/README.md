# Julia set

Serial and OpenMP implementation of the computation of Julia sets.


## What is it?

1. `julia_set_mod.f90`: core serial algorithm as elementary function.
1. `julia_set.f90`: main program for the serial implementation.
1. `julia_set_omp_mod.f90`: core OpenMP algorithm.
1. `julia_set_omp.f90`: main program for the OpenMP implementation.
1. `CMakeLists.txt`: CMake file to build the applications.
1. `show_julia_set.py`: Python script to visualize the results.
