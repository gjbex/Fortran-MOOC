# Profiling

## Question 1

Which of the following statements is correct?

1. In Austria you are required by law to run a profiler on your application before you start tweaking your code to improve performance. [No, but it would better be true in any country]
1. `gprof` will show y9u the time spent in each line of your source code. [No, that is unfortunately not the case]
1. `grpof` will give you the number of times a procedure is called during the execution of your application. [Indeed, that is one of the things that is recorded] [x]
1. The profile will depend on the optimization level used to build the application. [Indeed, procedures may be inlined at higher levels of optimization, and hence "disappear" from the profile"] [x]


## Question 2

Which of the following applications are profilers you can use for Fortran applications?

1. ArmForge DDT [No, that's a debugger]
1. valgrind [Indeed, callgrind is a profiler] [x]
1. Scalasca [Indeed, this is a profiler for parallel applications] [x]
1. Tau [Indeed, a profiler for parallel applications] [x]


## Question 3

Which of the following applications are profilers you can use for Fortran applications?

1. It is possible to measure the number of cache misses using some profilers. [Indeed, callgrind for instance] [x]
1. You can use the results of a profiler to have the compiler optimize better. {indeed, this is called profile guided optimization, and, e.g., GCC can do that] [x]
1. Some profilers cause a lot of overhead. [Indeed, so you have to pick the one you require for a particular task carefully] [x]
1. The profile of two subsequent runs of a deterministic application will be identical. [No, you will likely see variation on the timings of procedures]
