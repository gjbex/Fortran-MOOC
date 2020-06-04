# Compiler issues

As all software, compilers have their own quirks and peculiarities.


## GCC gfortran

The observations below are for gfortran 10.1.x.

1. The `sequence` statement in user defined types has no effect, the compiler keeps
   aligning.
1. Parameterized user defined types are not fully supported.  Type name mangling
   seems to be different per compilation unit (at least across `program` and `module`).
