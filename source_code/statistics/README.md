# Statistics

Example code taken from the field of (simple) statistics to illustrate a number of
concepts.

## What is it?

1. `stats_mod.f90`: simple implementation of a user defined type to accumulate
   statistical information.
1. `descriptive_statistics.f90`: main program that reads data from standard input and
   computes the mean and standard deviation of the data.
1. `median_stats_mod.f90`: user defined type that can also be used to compute the
   median of data.  Illustrates dynamic memory allocation.
1. `quicksort_mod.f90`: quicksort and lampsort implementation, illustrates recursion
   and dynamic memory allocation.
1. `median_statistics.f90`: main program that reads data from standard input and
   computes the mean, median and standard deviation of the data.
1. `quicksort_test.f90`: main program to test the quicksort and lampsort algorithm
   on random data.
1. `CMakeLists.txt`: CMake file to build the applications.
1. `data1.txt`, `data2.txt`: small data files for testing purposes.
