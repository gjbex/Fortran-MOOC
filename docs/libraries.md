# Libraries

Reinventing the wheel is typically not your best option.  Many libraries are
available that implement data structures and algorithms for scientific
computing.  Although it is very useful to understand the algorithms you are
using, perhaps even by implementing proof of concept, it shouldn't be your
choice for production code if a mature library is available.

In this section a number of libraries are mentioned that cover the
fundamentals of scientific computing.  Of course, there are many more out
there, so it pays off to do a thorough search before you embark on your
own development adventure.

Fast Fourier Transforms are important mathematical tools in many domains.
The [FFTW3](http://www.fftw.org/) library is an excellent implementation
that has Fortran bindings and can be for sequential, multi-threaded and
distributed code.

For linear algebra, BLAS and LAPACK have already been mentioned and
illustrated.  For distributed programming, you can consider
[BLACS](https://www.netlib.org/blacs/) (Basic Linear Algebra Communications
Subprograms) to distribute the storage of arrays over multiple processes.
MPI is used to implement the communication that is required.

[ScaLAPACK](http://www.netlib.org/scalapack/) (Scalable Linear Algebra PACKage),
the distributed extension of LAPACK uses BLACS under the hood to implement its
linear algebra algorithms.

The [PETSc](https://www.mcs.anl.gov/petsc/) (Portable, Extensible Toolkit for
Scientific Computing) library is intended to solve large partial differential
equations.  It uses MPI for communication, supports GPUs either through CUDA
or OpenCL as well as hybrid MPI-GPU.  It implements a wide range of linear and
non-linear solvers.

For eigenvalue problems at scale, [SLEPc](https://slepc.upv.es/) (Scalable
Library for Eigenvalue Problems Computations).  It is an extension of PETSc.
It can for instance be used to compute partial Singular Value Decompositions
(SVD).

[NetCDF](https://www.unidata.ucar.edu/software/netcdf/) (Network Common Data
Form) is used in some scientific domains as an alternative to HDF5.  It
has some advantages, e.e., it is easier to with spherical coordinate systems.
It uses HDF5 under the hood. It has a counterpart for parallel I/O,
[PnetCDF](https://parallel-netcdf.github.io/).

All the libraries listed above are open source software.  However,
commercial counterparts exist, and may be worth considering.  For
instance,   [Intel MKL](https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/onemkl.html#gs.zx8nvs)
(Math Kernel Library) implements BLAS, LAPACK, BLACS, ScaLAPACK and FFT
algorithms, as well as some interesting utility functions.

The commercial [NAG library](https://www.nag.com/content/nag-library) is a
huge collection of algorithms for scientific computing.
