# C interoperability

Programs to illustrate interoperability between Fortran and C.

## What is it?

1. `functions.c`: C functions to be called from a Fortran program.
1. `use_c_funcs.f90`: Fortran program that calls C functions.
1. `functions_mod.f90`: functions to be called from a C program.
1. `use_fortran_funcs.c`: C program that calls Fortran functions.
1. `gsl_sort.f90`: Fortran program that uses one of the GSL's sort functions.
1. `gsl_quad.f90`: Fortran program that uses the GSL's integration functions.
1. `CMakeLists.txt`: CMake file to build the applications.
