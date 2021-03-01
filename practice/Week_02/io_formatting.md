# I/O formatting

## Question 1

Which of the following formatting strings are correct and will display the following declaration `real :: x = 2.0/3.0`?
1. `'(E10.3)'` [Indeed.] [x]
1. `'(E5.3)'` [No, this will print asterisks.]
1. `'(F5.3)'` [Indeed.] [x]
1. `'(F5)'` [No, this will not compile.]
1. `'(F.3)'` [No, this will not compile.]


## Question 2

Consider the following program.

~~~~fortran
program powers
    implicit none
    integer :: i

    do i = 1, 16
        print '(I3)', 2**i
    end do
end program powers
~~~~
Which is the largest value that is printed?
1. 65536 [No, try it out.]
3. 1024 [No, try it out.]
4. 512 [Indeed.][x]
5. 64 [No, try it out.]


## Question 3

Consider the following code fragment:

~~~~fortran
print '(2F4.1)', 1.0/3.0, 2.0**16
~~~~
What will be printed?  (Spaces are represented by `_`)
1. `_0.3****` [Indeed.] [x]
1. `_0.3_65536.0` [No, try it out.]
1. `********` [No, try it out.]
1. `_0.3_6.5E04` [No, try it out.]
