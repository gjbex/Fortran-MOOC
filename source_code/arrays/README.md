# Arrays

Several short Fortran programs to illustrate arrays.

## What is is?

1. `array_elements.f90`: illustrates how to use the value of and assign
   values to array elements by index.
1. `array_initialization.f90`: illustrates how to initialize arrays.
1. `array_arithmethic.f90`: illustrates scalar-array and array-array arithmetics.
1. `subarrays.f90`: illustrates index "slicing" of Fortran arrays.
1. `matrix.f90`: illustrates a 2D array.
1. `max_array.f90`: illustrates the optional arguments `dim` and `mask` for
   some of the intrinsic procedures that operate on arrays.
1. `trace.f90`: illustration of an assumed-shape function.
1. `copmute_factorial.f90`: illustration of an elemental function.
1. `linear_transform.f90`: illustraion of an elemental function with multiple
   arguments.
1. `identity.f90`: illustration of a function return an array.
1. `array_timings.f90`: illustration of performance difference between array
   expressions, nested do-loops, forall and do concurrent.
1. `normalize.f90`: normalize a matrix by broadcasting a la numpy.
1. `normalize_performance.f90`: performance test for normalization using
   `spread` versus other methods.
1. `allocate_from_source.f90`: illustrates allocating an array using source.
1. `large_arrays.f90`: simple program to illustrate runtime error when
   attempting to allocate an array that is too large.
1. `enlarge_array.f90`: illustration of growing an array by repeated
   allocations.
1. `double_deallocate.f90`: illustration that a double deallocation generates
   a runtime error.
1. `CMakeLists.txt`: CMake file to build the applications.
