# f2py

It is fairly straightforward to use Fortran procedures from Python using f2py.


## What is it?

1. `code_generation.ipynb`: Jupyter notebook that creates Fortran functions
   representing random polynomials, writes them to a file and uses f2py to make
   them accessible from Python.
1. `matrix_mod.f90`: Fortran module that defines a subroutine that expects a double
   precision 2-dimensional array.
1. `matrix_test.f90`: Fortran program to test the Fortran module procedures.
1. `CMakeLists.txt`: CMake file to build the applications.
1. `matrices.ipynb`: Jupyter notebook that uses the `matrix_mod.f90` module via f2py.
