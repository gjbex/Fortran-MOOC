# Fibonacci

Several implementation of the Fibonacci sequence to illustrate
various concepts.

The skip-ahead implementation is based on the second property of the
Fibonacci sequence presented in the article
["Two fascinating properties of the Fibonacci sequence"](https://medium.com/cantors-paradise/two-fascinating-properties-of-the-fibonacci-sequence-8cf0f66aca95).

The memoization implementation illustrates caching results and using save
variables in a non-trivial way.

The closed-form formula is explained in the article
["A closed form of the Fibonacci sequence"](http://mathonline.wikidot.com/a-closed-form-of-the-fibonacci-sequence).
This implementation illustrates the use of save variables in procedures in a
trivial way.  Note that this implementation will only yield correct results
for arguments less than 76.

Note that here F(0) = 0, while it is sometimes defined as F(0) = 1.  There is
no fundamental difference.


## What is it?

1. `fib_mod.f90`:  five implementations of the Fibonacci sequence.
1. `fibonacci_verify.f90`: program that verifies the various implementations.
1. `fibonacci_skewed.f90`: program that times vairous implementations of the
   Fibonacci sequence, subsequent function calls are in order, favoring
   the memoization implementation.
1. `fibonacci.f90`: program that times various implementations of the
   Fibonacci sequence using random input values.
1. `CMakeLists.txt`: CMake file to build the applications.
