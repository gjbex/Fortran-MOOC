# Numerical data

## Question 1

Consider the following program.
~~~~fortran
program infty
    implicit none
    real :: x = 50.0
    integer :: i

    do i = 1, 10
        x = x*x
        print *, x
    end do
end program infty
~~~~
How many iterations print a value that is not infinite?
1. 2
1. 3
1. 4
1. 5
1. all


## Question 2

How can you check something went wrong with the numerical value in the following program?
~~~~fortran
program infty
    implicit none
    real :: x = 50.0
    integer :: i

    do i = 1, 10
        x = x*x
        print *, x
    end do
end program infty
~~~~
Use
1. `ieee_is_normal` [Indeed, this function can be used.[ [x]
1. `ieee_is_infinite` [No, this function doesn't exist.]
1. `ieee_is_finite` [Indeed, this function can be used.[ [x]
1. `ieee_is_nan` [No, infinity is not NaN.]


## Questions 3

To check whether any numerical exception occurred, you can use the function:
1. `ieee_exception` [No, this function does not exist.]
1. `ieee_get_flag` [Indeed.] [x]
1. `ieee_get_error` [No, this function does not exist.]
