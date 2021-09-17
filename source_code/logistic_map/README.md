# Logistic map

Computing the logistic map using an elemental function on two arrays.


## What is it?

1. `logistic_map.f90`: program to compute the logistic map (note that
   a compile time warning is generated).
1. `logistic_map_2.f90`: program to compute the logistic map using dynamic memory
   allocation and meshgrid.
1. `meshgrid_mod.f90`: module that implements MATLAB/numpy's meshgrid function.
1. `plot_map.sh`: Bash script that uses gnuplot to visualize the data.
1. `logistic_function.f90`: program to iterate the logistic map
   starting from an initial value of x and given value of r.
1. `plot_curve.sh`: Bash script that uses gnuplot to visualize the
   x values over iterations. 
1. `CMakeLists.txt`: CMake file to build the applications.
