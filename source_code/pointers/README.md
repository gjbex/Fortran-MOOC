# Pointers

Some code illustrations of pointers in Fortran, mainly to support the reading
material.  Applications of pointers to create interesting data types can be
found in other directories.


## What is it?

1. `swap.f90`: illustrates the performance benefit of using pointers over
   copying data for a kernel-like code.
1. `kernel.f90`: code used to illustrate basics of pointers.
1. `associations.f90`: program illustrating the associated intrinsic function.
1. `slices.f90`: illustrates how to associate a pointer with an array slice.
1, `benchmark.f90`: illustration of using a pointers to procedures.
1. `pointer_to_allocatable.f90`: illustration of some of the more perplexing
   aspects of allocatables and pointers.
1. `CMakeLists.txt`: CMake file to build the applications.
