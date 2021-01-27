# Scope

## Question 1

Consider the following program.
~~~~fortran
program scope_01
    implicit none
    integer :: x = 3 y = 5

    call compute(x)
    print *, x, y

contains

    subroutine compute(x)
        implicit none
        integer, intent(inout) :: x

        x = x*y
        y = x
    end subroutine compute

end program scope_01
~~~~
What happens?
1. This will not compile. [No, it Will.]
1. This will print '3    5'. [No, it doesn't, try it out.]
1. This will print '15    5'. [No, it doesn't, try it out.]
1. This will print '3    15'. [No, it doesn't, try it out.]
1. This will print '15    15'. [Indeed.] [x]


## Question 2

Consider the following program.
~~~~fortran
program xope_02
    implicit none
    integer :: i = 3, j = 5

    block
        integer :: j
        i = 2
        j = 7
        print *, i, j
    end block
    print *, i, j

end program xope_02
~~~~
What happens?
1. This will not compile. [No, it Will.]
1. This will print '2    7' and '3    5'. [No, it doesn't, try it out.]
1. This will print '2    7' and '2    5'. [Indeed.] [x]
1. This will print '2    7' and '2    7'. [No, it doesn't, try it out.]
