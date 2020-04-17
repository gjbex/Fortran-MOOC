# Type info

Illustrates the properties of various basic data types in Fortran.

## What is it?

1. `type_info.f90`: application that shows the result of `huge`, `range` and `digits`
   for the integer and real kinds, as well as `tiny`, `epsilon`, `precision`,
   `minexponent` and `maxexponent` for the real kinds.
1. `type_conversion.f90`: type conversion from larger to smaller kknds for `integer`
   and `real`.
1. `sqrt2.f90`: illustration of floating point versus real numbers, i.e., round-off
   errors and comparisons.
1. `CMakeLists.txt`: CMake file to build the applications.
