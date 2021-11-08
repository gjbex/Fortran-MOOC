# Alignment

The compiler will optimize the layout of data in memory, which is called
alighment.  Here are some code samples to experiment with this using
GDB and the `&` operator.

## What is it?

1. `alignment_udf.f90`: experiment whether `sequence` in user defined
   types influences alignment.
1. `CMakeLists.txt`: CMake file to build the applications.
