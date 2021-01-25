# Elemental procedures

## Question 1

Consider the following function, is it a valid elemental function?  An array will be passed to the function as the `x` argument.
~~~~fortran
elemental function f(x, a, b) result(y)
    implicit none
    real :: x, a, b, y

    x = x + b
    y = a*x
end function f
~~~~
1. Yes, this would work fine. [No, this is not going to work, check all conditions.]
1. No, the value of the argument `x` should not be changed. [Indeed.] [x]
1. No, the arguments `a` and `b` must have their intent declared. [Indeed.] [x]
1. No, the result of the function should be x as well. [No, check the semantics of functions.]


## Question 2

Consider the following function, is it a valid elemental function?  An array will be passed to the function as the `x` argument.
~~~~fortran
elemental function scale(x, aggregate) result(y)
    implicit none
    real, value :: x
    real, intent(inout) :: aggregate 

    y = x**2 + x + 1.0
    aggregate = aggregate + y
end function scale
~~~~
1. No, all the arguments of the function should have intent `in` or be value arguments. [Indeed, aggregate can not have intent `inout`.] [x]
1. No, an elemental function can have only a single argument. [No, elemental procedures can have multiple arguments.]
1. Yes, this would work fine. [No, it doesn't check again.]
1. No, `x` should be declared as an array. [No, that's the point of elemental procedures.]


## Question 3

Consider the following function, is it a valid elemental function?  When `data` is an array declared and initialized as `integer, dimension(5) :: data = [ (i, i=1, size(data)) ]` and if the function is called as `scale(data, 5, mod(data, 2) /= 0)`, what will be returned?
~~~~fortran
elemental function scale(x, factor, cond) result(y)
    implicit none
    integer, intent(in) :: x, factor
    logical, intent(in) :: cond
    integer :: y

    if (cond) then
        y = factor*x
    else
        y = x
    end if
end function scale
~~~~
1. This will not compile since the elemental function is called with two arrays as arguments. [No, you can call an elemental function with multiple arguments that are arrays.]
1. The result is an array with element 5, 2, 15, 4, 25 [Indeed.] [x]
1. This will result in a segmentation fault. [No, it will run just fine.]
