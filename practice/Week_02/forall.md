# Forall statement

## Question 1

Consider the following fragment of code.

~~~~fortran
integer, dimension(9, 9) :: data = 0
integer :: i, j
...
forall (i = size(data, 1):1:-1, j = -1:1)
    data(i, i + j) = 1
end forall
~~~~
What will happen?
1. `data` is initialized as a band matrix with a width of 3 [Indeed, but that's not all.] [x]
1. this code may crash [Indeed, the array boundaries are not respected.] [x]
1. `data` is initialized to a band matrix with a width of 3 along the minor diagonal. [No, check the indices carefully.]
1. All off-diagonal elements of `data` will be set to 1. [No, check the indices carefully.]


## Question 2

Consider the following code fragment.

~~~~fortran
integer, dimension(9, 9) :: data = 0
integer :: i, j
...
forall (i = 1:size(data, 1), j = i:size(data, 2))
    data(i, j) = 1
end forall
~~~~
What will happen?
1. This will initialize all elements of the array `data` above and including the major diagonal. [No, not quite.]
1. This will not compile. [Indeed, indices can not depend on one another.] [x]
1. This will initialize all elements of the array `data` below and including the major diagonal. [No, not quite.]
1. This will crash due to an index that is out of bounds. [No, try it out.]


## Question 3

Consider the following code fragment.

~~~~fortran
integer, dimension(5, 5) :: data = 0
integer :: i, j
...
forall (i = 1:size(data, 1), j = 1:size(data, 2), mod(i + j, 2) /= 0)
    data(i, j) = 1
end forall
~~~~
How many elements of `data` will be equal to 1?
1. 0 [No, try it out.]
1. 13 [No, check the mask expression.]
1. 12 [Indeed.] [x]
1. 25 [No, check the mask expression.]
