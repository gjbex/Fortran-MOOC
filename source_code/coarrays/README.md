# Coarrays

Coarrays are Fortran's native tool for distributed computations.  Here you'll
find a few simple exaples by way of illustration.


## What is it?

1. `coarrays.f90`: very simple example.
1. `compute_pi.f90`: program that computes pi by using the ration of the area
   of a circle versus that of a square.
1.  `cmake/Modules/FindCoarray.cmake`: CMake file to find Fortran Coarray options.
1. `CMakeLists.txt`: CMake file to build the applications.


## Requirements

The CMake file is written for Intel compilers, use:
```bash
$ ccmake  -DCMAKE_Fortran_COMPILER=$(which ifort)  <src-dir>
```


## Running

The number of images can be limited at compile time, or at runtime using the
`FOR_COARRAY_NUM_IMAGES1 environment variable, e.g., for Bash
```bash
$ export FOR_COARRAY_NUM_IMAGES=4
```
