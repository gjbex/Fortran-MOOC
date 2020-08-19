# Resesrvoir sampling

Reservoir sampling is a useful randomized algorithm to get a representative
of a population of unknown size that is presented as a data stream.


## What is it?

1. `utilities_mod.f90`: implementation of Fisher-Yates shuffliig algorithm
   on an array.
1. `test_permutations.f90`: program to test the Fisher-Yates algorithm.
1. ``create_data.f90`: program to create a data file using direct access I/O.
1. `shuffle_data.f90`: program that shuffles the values in a data file,
   illustrating read/write access and direct access I/O.
1. `CMakeLists.txt`: CMake file to build the applications.
