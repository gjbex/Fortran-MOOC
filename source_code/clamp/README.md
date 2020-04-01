# Clamp

Application that reads real numbers from standard input
and "clamps" them between two values given on the command
line, writing the resulting number to standard output.

## What is it?

1. `clamp.f90`: implementation of the application to clamp
   real values, illustrates subroutine with `inout`
   argument.
1. `CMakeLists.txt`: CMake file to build the application.
1. `data.txt`: data file to test the application.

## How to use?

The  application can be called with zero, one or two
arguments.  When called without arguments, the values will
be clamped between -1.0 and +1.0.  When called with a
single argument, e.g., 5.0, the values will be clamped
between -5.0 and 5.0.  Finally when called with two
arguments, e.g., 0.0 and 2.0, the values will be clamped
between 0.0 and 2.0.

```bash
$ ./clamp.exe 0.0 2.0 < data.txt
````
