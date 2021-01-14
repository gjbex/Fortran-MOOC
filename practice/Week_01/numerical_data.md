# Numerical data

## Question 1

Fortran has dedicated types for
1. real numbers [Indeed, single and double, and sometimes quadrupel precision.] [x]
1. positive integers [Not really, unlike, e.g., C or C++, there is no unsigned integer in Fortran.]
1. rational numbers [Fortran has no rational number type.]
1. binary numbers [Although all data is ultimately stored in a binary representation, there is no specific type for that.]


## Question 2

A double precision floating point value in Fortran is stored using
1. 4 bytes [Not enough bits, I'm afraid.]
1. 8 bytes [Correct.] [x]
1. 12 bytes [There is no numeric type that uses 12 bytes, why?]
1. 16 bytes [That would be quadruple precision.]


## Question 3

Assuming we are using GCC 10.x, which of the following is correct?
1. `real :: x = 1.0/0.0` results in a compile time error. [Indeed, the compiler will catch this, experiment how you can deceive it.] [x]
1. `real :: x = sqrt(-1.0)` results in a runtime error. [This will be caught by the compiler, try to deceive it.]
1. For `real :: x = 1/3` , `x` will have the value 0.33333... [No, this is an integer division.]
1. If `x` and `y` are declared `real`, then `x = exp(27); y = exp(x)` will result in `y` having the value `NaN`. [No, this would evaluate to Infinity.]
