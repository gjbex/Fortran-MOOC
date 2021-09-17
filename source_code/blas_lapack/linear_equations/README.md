# Solving linear equations

Illustration of solving sets of linear equations.  The matrix and and
vector representing the equations are read from files.
Illustrates the use of assumed rank arguments and the select rank
statement.


## What is it?

1. `linalg_mod.f90`: module that defines a number of untility
   procedures to read and write matrices, and to generate
   random matrices.
1. `generate_array.f90`: program to generate random vectors
   and matrices.
1. `solve_equations.f90`: program to solve a set of equiations `Ax = b`
   where `A` and `b` are stored in text files.  LAPACK's `dgesv` is
   used to compute the solutions.
1. `A.txt`: 3 by 3 matrix.
1. `b.txt`: vector with 3 compoents.
1. `CMakeLists.txt`: CMake file to build the applications.
1. `solve.py`: Python script that uses numpy to check the results.
   
