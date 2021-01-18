# Subroutines

## Question 1

Can you rewrite the following subroutine as a function?
~~~~fortran
subroutine sub(y, x, a, b, c)
    intrinsic none
    real :: x, y, a, b, c

    y = a*x**2 + b*x + c
end subroutine
~~~~
1. No, there are too many arguments. [No, the number of arguments as such is not really relevant.]
1. Yes, the function signature would be `real function sub(x, a, b, c)`. [Indeed, only the argument `y` is modified.] [x]
1. Yes, the signature would be `real function sub(y, x, a, b, c)` [Although technically okay, it would be poor style since the intent is to return the value of `y` as the result of the function.] [x]
1. Yes, the function signature would be `function sub(x, a, b, c) result(y)`. [Yes, this is a good signature for the function.] [x]


## Question 2

Can you rewrite the following subroutine as a function?
~~~~fortran
subroutine sub(n)
    intrinsic none
    integer :: n, i

    do i = 1, n
        print *, n**2
    end do
end subroutine sub
~~~~
1. Yes, the signature would be `logical function sub(n)` and it would always return `.true.`. [Indeed, it is not really elegant, but it would be correct.] [x]
1. Yes, the signature of the function would be `void function sub(n)`. [No, there is no `void` type in Fortran.]
1. Yes, the signature would be `integer function sub(n)` and it would always return 1. [Indeed, it is not really elegant, but it would be correct.] [x]
1. Yes, the signature of the function would be `void function sub(n)`. [No, there is no `void` type in Fortran.]


## Question 3

Consider the following subroutine.  When you call it with arguments 3 and 5, what is the result?
~~~~fortran
subroutine sub(a, b)
    implicit none
    integer :: a, b
    a = 3*b
end subroutine sub
~~~~
1. The result will be that `a` has the value 15. [No, there is no variable `a` passed as an argument to the subroutine.]
1. You will get a runtime error. [Indeed, this will typically generate a segmentation fault.] [x]
1. You will get a compilation error. [No, this compiles just fine.]
1. The result will be that `a` has the value 3. [No, there is no variable `a` passed to the subroutine.]
