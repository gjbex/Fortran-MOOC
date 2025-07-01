# Source code

This directory contains source code for exercises and
code examples used in videos and reading material.


## What is it?

1. `hello_fortran`: very simple Fortran programs.
1. `julia_set`: computation of the Julia set, illustrates
   use of complex number in Fortran, using command line
   arguments, using modules, using allocatable arrays.
   Both a sequential and OpenMP implementation are given.
1. `gcd`: computation of the greatest common divisor,
   used as illustration of indentation, use of while loop.
1. `leapyear`: check whether a year is a leap year,
   illustrates nested conditional statements.
1. `calculator`: simple command line calculator that
   implements addition, substraction and multiplication
   of floating point values, illustrates `select case`.
1. `distances`: compute Euclidian distences between points.
   Illustrates simple functions and reading from standard
   input.
1. `clamp`: clamp real number on standard input to values
   given on the command line, illustrates subroutines.
1. `call_by_semantics`: illustration of call-by-reference versus
   call-by-value semantics.
1. `recursion`: examples of recursive procedures.
1. `optional`: examples of optional arguments in Fortran procedures.
1. `exp_distr`: example of a function that uses a `save` attribute for its
   local variables.
1. `iterations`: code to illustrate Fortran iteration statements.
1. `sierpinski`: implementation to compute the Sierpinki gasket.
1. `ball_throw`: illustrate `exit` and preprocessor macros.
1. `config_parser`: illustration of `exit` and `cycle`, as well as an
   infinite loop.
1. `sum_values`: illustrates the use of `exit` and `cycle` as well as
   alternative.
1. `type_info`: illustrates the properties of integer and real kinds.
1. `cellular_automata`: implemention of cellular automata.
1. `strings`: some illustrations of using strings in Fortran.
1. `box_counting`: implementation of box counting to determine the
   Minskowski dimension of a 2D fractal, illustrates documentation
   using doxygen and documentation generation with CMake.
1. `computing_pi`: applications to compute pi.
1. `kaprekar`: application that computes the Kaprekar constant.
1. `particles`: application to illustrate user defined types.
1. `statistics`: applications to illustrate various concepts (recursion, dynamic
   memory management`).
1. `primes`: some exercises on prime numbers.
1. `quadrature`: some code to illustrate passing functions to funciotns as
   arguments.
1. `generics`: some illustrations of generic programming in Fortran.
1. `text_io`: some illustrations of formatted, sequential I/O.
1. `c_interoperability`: some illustrations of how to call C functions from
   Fortran.
1. `enumerator`: illustratoin of Fortran's enumerator type.
1. `buffon_needles`: Monte-Carlo simulation of Buffon's needle problem.
1. `statistics_oo`: illustration of object-oriented programming concepts.
1. `direct_access_io`: illustrations of how to do direct access I/O.
1. `reservoir_sampling`: illustration of using direct access I/O and
   read/write file access.
1. `linked_real_list`: illustration of using pointers to build data types, as
   well as generic programming using the C preprocessor..
1. `bit_manipulations`: illustrations of using bit-level operations.
1. `fibonacci`: implementations of the Fibonacci sequence illustrating
   memoization, save variables in procedures, arrays of procedures.
1. `ieee754`: illustration of IEEE intrinsic modules.
1. `pointers`: illustrations of pointers, basic concepts.
1. `io_performance`: experiments with different I/O modes with respect to
   performance.
1. `random_numbers`: illustrations of how to work with Fortran's pseudo random
   number generator.
1. `blas_lapack`: illustration of using the BLAS and Lapack libraries for
   matrix computations and linear algebra respectively.
1. `openmp`: illustration of using OPenMP for shared memory programming.
1. `mpi`: illustration of using MPI for shared and distributed
   computations.
1. `coarrays`: illustration of using coarrays for shared and distributed
   computations.
1. `logistic_map`: computing the logistic map using an elemental function.
1. `block_matrices`: illustration of using a forall statement to initizlize a
   block matrix.
1. `dynamic_libraries`: illustrates using dynamic libraries and executing system
   commands.
1. `towers_of_hanoi`: illustration of recursion on the Towers of Hanoi problem.
1. `f2py`: illustration of using f2py.
1. `trees`: using user-defined types and pointer to create data structures,
   also illustrates object-oriented programming and inheritance.
1. `hdf5`: using the HDF5 library to store and read data.
1. `neighbours`: simulation of a 2D growth process.
1. `precision`: single versus double versus mixed precsion arithmetic
   experiments.
1. `coins`: illustration of greedy versus dynamic programming.
1. `implicit_loops`: performance impact of implicit versus explicit loops.
1. `linking`: illustration of link-time optimizations.
1. `preprocessor`: illustration of how to use the preprocessor.
1. `openacc`: illustration of using OpenACC to offload computations to
   BPU.
1. `namelist`: illustration of using namelist I/O.
1. `CMakeLists.txt`: CMake file to build all applications.


## Building the code

The entire sample code can be build using the `CMakeLists.txt` CMake file in
directory.

```bash
$ mkdir build; cd build
$ cmake ..
$ make
```

Note:
1. Some projects depend on the Intel compiler and will be skipped when building
   with another compiler.
1. Some project will generate warnigns, but that is mainly on purpose to
   illustrate certain points.
