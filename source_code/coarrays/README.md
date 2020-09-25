# Coarrays

Coarrays are Fortran's native tool for distributed computations.  Here you'll
find a few simple exaples by way of illustration.


## What is it?

1. `coarrays.f90`: very simple example.


## Requirements

The CMake file is written for Intel compilers, use:
```bash
$ ccmake  -DCMAKE_Fortran_COMPILER=$(which ifort)  <src-dir>
```
