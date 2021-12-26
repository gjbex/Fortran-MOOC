# OpenACC

OpenACC is arguably the simplest way to use GPU acceleration in Fortran.


## What is it?

1. `diffusion_mod.f90`: module defining a 2D Laplace diffusion simulation
   as well as helper subroutines.
1. `diffusion.f90`: program to run the Laplace diffusion simulation.
1. `CMakeLists.txt`: CMake file to build the applications.

**Note:** this code will only compile if you have the NVIDIA HPC toolkit installed, and
run (on a GPU) if you have one in your system.


## How to build?

To define the target architecture, call cmake with
* `-DOpenACC_ACCEL_TARGET==host` to generate sequential code for CPU,
* `-DOpenACC_ACCEL_TARGET==multicore` to generate parallel code for CPU,
* `-DOpenACC_ACCEL_TARGET==tesla` to generate code for NVIDIA GPU.
