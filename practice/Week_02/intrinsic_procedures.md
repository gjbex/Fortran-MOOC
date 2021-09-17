# Intrinsic procedures for arrays

## Question 1

Consider an array declared and initialized as `integer, dimension(3, 4) :: data = reshape([ (i, i=1, 12) ], [3, 4])`, what is the result of the function call `sum(data, dim=2)`?
1. the scalar value 78 [No, check the semantics of the second argument.]
1. an array with elements 22, 26, 30 [Indeed, the row-wise sum is computed.] [x]
1. an array with elements 6, 15, 24, 33 [No, check the semantics of the second argument.]


## Question 2

You can count the number of strictly positive elements in a real array `data` using
1. `count(mask=data > 0)` [Indeed.] [x]
1. `count(data, mask=(x(i), i=1, size(x)))1` [No, this will give you a compile error.]
1. `count(data, data > 0)` [No, this will give you a compile error.]
1. `count(data > 0)` [Indeed.] [x]


#W Question 3

Consider an array declared and initialized as `integer, dimension(3, 4) :: data = reshape([ (i, i=1, 12) ], [3, 4])`, what is the result of the function call `maxloc(data, dim=1, mask=mod(data, 2) == 0)`?
1. an array with values 2, 6, 8, 11 [No, check the documentation on `maxloc`.]
1. an array with values 10, 8, 12 [No, check the semantics of the optional `dim` argument.]
1. an array with values 2, 3, 2, 3 [Indeed, don't you love `dim` and `mask`?] [x]
1. an array with values 4, 3, 4 [No, check the semantics of the optional `dim` argument.]
