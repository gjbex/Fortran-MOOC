# Neighbours

Simulation of a growth process in two dimensions.  The sites are arranged on a
regular 2D grid with integer coordinates. An empty site can only be occupied
when there is a neighbouring site that is already occupied.  The probability of
a site being occupied is
* twice as large if it has two neighbours,
* trice as large if it has three neighbours,
* four times as large if it has four enighbours.

Taking into account these probabilities, every site can be selected.  The
initial situation has a single site occupied at (0, 0).

The quantity of interest is the "hairiness", i.e., the number of edges
with a free site, divided by the number of occupied sites.


## What is it?

1. `map_mod.f90`: user defined type to represent the configuration of the
sites.
1. `neighbours.f90`: program unit to drive the simulation.
1. `CMakeLists.txt`: CMake file to build the applications.
