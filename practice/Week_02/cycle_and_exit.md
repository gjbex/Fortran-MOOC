# Cycle and exit

## Question 1

Consider the following fragment of code, where the variable `i` is declared as an integer.
~~~~fortran
do i = 1, 10
    if (mod(i, 3) == 0 .and. mod(i, 2) == 0) exit
end do
~~~~
What is the value of `i` after the do-statement?
1. 11 [No, try it out.]
1. 10 [No, try it out.]
1. 6 [Indeed.] [x]
1. 3 [No, try it out.]
1. 2 [No, try it out.]


## Question 2

Consider the following fragment of code, where the variable `i` is declared as an integer.
~~~~fortran
do i = 1, 10
    if (mod(i, 3) == 0) cycle
    print *, i
end do
~~~~
Which sequence of number will be printed?
1. 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 [No, try it out.]
1. 1, 2, 4, 5, 7, 8, 10 [Indeed, iterations for `i` divisible by 3 are skipped.] [x]
1. 1, 2 [No, this is `cycle`, not `exit`.]


## Question 3

Consider the following fragment of code, where the variables `i` and `j` are declared as an integer.
~~~~fortran
i = 5
j = 4
outer: do while (i >= 0)
    inner: do while (j >= 0)
        j = j - 1
        if (mod(j, 2) == 0) cycle outer
        if (mod(j, 3) == 0) exit
        print *, i, j
    end do inner
    i = i - 1
end do outer
~~~~
Which lines will be printed by this code fragment?
1. "4 3", "3 2", "2 1", "1 0" [No, try it out.]
1. "4 2", "4 0" [No, try it out.]
1. "4 1", "4 -1" [Indeed.] [x]
1. "4 3", "4 1" [No, try it out.]
