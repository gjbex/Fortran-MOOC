# Array of user defined type elements

Application that computes the center of mass of a system of randomly
initialized particles.


## What is it?

1. `particles_mod.f90`: module that defines particles and functions
   to work with them.
1. `particles_array_mod.f90`: module that defines particles and functions
   to work with them, coordinates are represented by an array.
1. `particles.f90`: main program that initializes particles randomly
   and computes the center of mass.
1. `CMakeLists.txt`: CMake file to build the applications.
