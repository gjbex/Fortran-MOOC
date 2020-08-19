# Direct access I/O

Fortran can handle record based I/O using direct access.  This code illustrates
the concept.


## What is it?

1. `direct_formatted_write.f90`: write a file in direct access mode, starting
   from the last record.
1. `direct_formatted_read.f90`: read the file generated, again starting from
   the last record.
1. `CMakeLists.txt`: CMake file to build the applications.
