# Buffon's needles

What is the probability that when you drop a needle on a sheet of lined paper
the needle will cross one of the lines?  The length of the needles is less than
the distance between the lines.

See [this Meidum article](https://medium.com/towards-artificial-intelligence/monte-carlo-simulation-an-in-depth-tutorial-with-python-bcf6eb7856c8) for a description.


## What is it?

1. `buffon_needles.f90`: Fortran implementation to compute the probability
   using a Monte-Carlo simulation.
1. `CMakeLists.txt`: CMake file to build the applications.
