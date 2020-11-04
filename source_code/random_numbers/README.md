# Random numbers

Although Fortran's random number generator is similar to that in runtime libraries
of other programming languages, there are some particularities.


## What is it?

1. `random_numbers.f90`: program to illustrate how to get the size of the arrays
   for seeding the RNG, how to get the current values, as well as how to set them.
1. `reproduction.f90`: program to illustrate possible approach to reproducible
   results when using a random number generator.
1. `random_integers.f90`: program to generate a sequence of random integers between
   a lower and an upper value (inclusive).
1. `CMakeLists.txt`: CMake file to build the applications.
