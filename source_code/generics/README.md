# Generics

Fortran allows a level of generic programming, the code in this directory
illustrates this.

## What is it?

1. `swap_mod.f90`: module that defines a generic procedure to swap the
   values of eitehr real or integer arguments.
1. `swap_test.f90`: program to illustrate `swap`.
1. `CMakeLists.txt`: CMake file to build the applications.
