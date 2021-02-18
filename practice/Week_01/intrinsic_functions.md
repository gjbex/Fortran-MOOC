# Intrinsic functions

## Question 1

Fortran has an intrinsic function to compute the error function, it is  called
1. `error_function` [Good guess, but no, check https://gcc.gnu.org/onlinedocs/gfortran/Intrinsic-Procedures.html]
1. `erf` [Correct.] [x]
1. `erfc` [Almost correct, this is the complementary error function.]
1. `error` [Good guess, but no, check https://gcc.gnu.org/onlinedocs/gfortran/Intrinsic-Procedures.html]


## Question 2

The function to strip white space from the end of a string is called
1. `strip` [No, that would be Python.]
1. `rtrim` [No, this is not a Fortran intrinsic function.]
1. `rstrip` [No, that would be Python]
1. `trim` [Indeed, this function removes trailing whitespace characters from a string.] [x]


## Question 3

The intrinsic function `sizeof` returns the size of its argument expressed in bytes.  Sounds nice, any thoughts?
1. You never need this function in a Fortran application. [Sometimes you need this functionality.]
1. It is a compiler-specific extension, and hence should be avoided in code that should be portable. [Indeed, it is a GNU extension.] [x]
1. The intrinsic function `size` can be used for the same purpose if you pass it an optional argument `unit='bytes'`. [No, check the documentation, `size` has no such optional argument.]


## Question 4

The intrinsic procedure `new_line` can be used to retrieve a new line character.  It takes a character as an argument.  The argument
1. will hold the new line character after the call to `new_line`. [No, check the documentation]
1. will determine the number of new line characters that are returned, i.e., as many as the length of the argument. [No, check the documentation.]
1. will determine the kind of the character value that is returned. [Indeed] [x]


## Question 5

In Fortran you can compute the base-10 logarithm of a real number `x` using
1. `log(x)` [No, that would be the natural logarithm.]
1. `log10(x)` [Indeed.] [x]
1. `log(x, base=10)` [That would be nice, but no, check the documentation.]
1. `log(x)/log(10)` [This would be less precise than using a specific intrinsic function, but it would work.] [x]
