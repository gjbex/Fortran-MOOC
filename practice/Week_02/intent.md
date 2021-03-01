# Intent

## Question 1

Consider the following subroutine, what is the most appropriate intent for the argument `err`?

~~~~fortran
subroutine compute(x, y, a, b, err)
    implicit none
    real :: x, y, a, b
    integer :: err

    err = .true.
    if (x > 0.0) then
        y = y + a*x + b
        err = .false.
    end if
end subroutine compute
~~~~
1. `in` [No, there is an assignment to `err`.]
1. `out` [Yes, indeed, there is an assignment to `err`, but its value is not used.] [x]
1. `inout` [No, although it would work, `err`'s value is not used.]


## Question 2

Consider the following subroutine, what is the most appropriate intent for the argument `x`?

~~~~fortran
subroutine compute(x, y, a, b, err)
    implicit none
    real :: x, y, a, b
    integer :: err

    err = .true.
    if (x > 0.0) then
        y = y + a*x + b
        err = .false.
    end if
end subroutine compute
~~~~
1. `in` [Indeed, the value of `x` is used, but the argument is not assigned to.] [x]
1. `out` [No, the value of `x` is used, and the argument is not assigned to.]
1. `inout` [No, although it would work, `x` is never assigned to.]


## Question 3

Consider the following subroutine, what is the most appropriate intent for the argument `y`?

~~~~fortran
subroutine compute(x, y, a, b, err)
    implicit none
    real :: x, y, a, b
    integer :: err

    err = .true.
    if (x > 0.0) then
        y = y + a*x + b
        err = .false.
    end if
end subroutine compute
~~~~
1. `in` [No, although the value of `y` is used, it is also assigned to.]
1. `out` [No, the value of `y` is used.]
1. `inout` [Indeed, the value of `y` is used, and it is assigned to.] [x]

## Question 4

Which of the following statements is correct?
1. When you declare and array argument as intent `in`, you can not assign to the array, but you can modify individual elements [No, try it out.]
1. When you don't specify an intent, the default is `in` [No, try it out.]
1. Specifying the intent will help the compiler catch potential bugs. [Indeed.] [x]
1. Declaring a `value` argument is synonymous to intent `in`. [No, you can assign to an argument that was declared `value`.]
