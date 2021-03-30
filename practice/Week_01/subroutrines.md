# Subroutines

## Question 1

Which of the following statements is correct?
1. A subroutine can not be used as part of an expression. [Indeed, you can only use them in a call statement] [x]
1. The only way to call a subroutine is in a call statement. [Indeed] [x]
1. Any subroutine can be rewritten as a function. [Indeed, although having multiple out arguments is somewhat unnatural] [x]
1. Functions and subroutines are interchangeable. [No, subroutines can not be part of an expression]
1. Any function can be rewritten as a subroutine with one more argument. [Indeed, the return value is added as an out argument] [x]



## Question 2

Consider the following program.

~~~~fortran
program p1
    implicit none
    integer :: a = 3, b = 5, x = 7, y = 12

    call sub(x, y)
    print *, a, b

contains

    subroutine sub(x, y)
        implicit none
        integer :: x, y, tmp
        tmp = x
        x = y
        y = tmp
    end subroutine sub
end program p1
~~~~

Which values will be printed?
1. `3 5` [Indeed, isn't this nice?] [x]
1. `5 3` [No, check it out]
1. `7 12`[No, check it out]
1. `12 7` [No, check it out]


## Question 3

Consider the following program.

~~~~fortran
program p1
    implicit none
    integer :: a = 3, b = 5, x = 7, y = 12

    call sub(x, y)
    print *, a, b

contains

    subroutine sub(x, y)
        implicit none
        integer :: x, y, tmp
        tmp = a
        a = b
        b = tmp
    end subroutine sub
end program p1
~~~~

Which values will be printed?
1. `3 5` [No, check it out]
1. `5 3` [Indeed, isn't this nice?] [x]
1. `7 12`[No, check it out]
1. `12 7` [No, check it out]

