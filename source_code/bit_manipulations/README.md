# Bit manipulations

Sometimes it is quite useful to operate on values at the level of individual
bits.  Fortran allows you to do that fairly easily.  This directory contains
some examples.

A nice collection of bit-level algorithms is
[maintained by Sean Eron Anderson](https://graphics.stanford.edu/~seander/bithacks.html).

## What is it?

1. `create_lookup_table.f90`: program to create bit count lookup table data.
1. `bitmanip_mod.F90`: module defining bit operations.
1. `bitcount.f90`: program to benchmark bit counting implementations.
1. `bit_operations.f90`: application with some simple illustrations of
   bit-wise operations.
1. `CMakeLists.txt`: CMake file to build the applications.
