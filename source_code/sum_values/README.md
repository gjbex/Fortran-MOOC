# Sum values

Versions of the same application that either use a while statement or an infinite
loop, exit and cycle statements.

## What is it?

1. `sum_values.f90`: application that reads floating point values from standard
   input and writes the sum to standard output.  It ignores lines that can not be
   converted to `real`. Illustrates the use of an infinite loop, `exit` and `cycle`.
1. `sum_values_no_infinite.f90`: application that reads floating point values
   from standard input and writes the sum to standard output.  This version uses a
   conventional while statement only.
1. `CMakeLists.txt`: CMake file to build the applications.
