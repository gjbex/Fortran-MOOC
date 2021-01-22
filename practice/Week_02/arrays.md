# Arrays

## Question 1

The function to retrieve the number of elements of an array is
1. `length` [No, there is no intrinsic function with that name.]
1. `len` [No, this is a function to determine the length of a string.]
1. `size` [Indeed, this returns the number of elements of an N-dimensional array.] [x]
1. `sizeof` [No, this is not a standard intrinsic procedure, and it returns the size in bytes.]


## Question 2

For a two-dimensional array `A`, `size(A, 2)` returns
1. the number of columns [Indeed.] [x]
1. the number of rows [No, check the documentation.]
1. the number of elements for which `kind=2` [No, check the documentation.]


## Question 3

Consider the two arrays declared as follows
~~~~fortran
real, dimension(3) :: x
real, dimension(3, 3) :: A
~~~~
The expression `A*x`
1. will be evaluated as the matrix-vector product of `A` and `x` [No, that is not what will happen.]
1. will result in a broadcast of `x` over the columns of `A`, i.e., each column of `A` is multiplied element-wise with `x` [No, that would work in numpy, but not in Fortran.]
1. will result in a compiler error [Indeed, the dimensions should match.] [x]
1. will result in a segmentation fault at runtime [No, it doesn't.]
