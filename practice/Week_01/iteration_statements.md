# Iteration statements

## Question 1

The following statement is syntactically correct.

~~~~fortran
while (i < 10) do
    x = f(x, i)
end do
~~~~
1. yes [Check the syntax again.]
1. no [Indeed, this looks fine, but it isn't, check the syntax.] [x]


## Question 2

The following statement is syntactically correct.

~~~~fortran
do (i < 10) while
    x = f(x, i)
end do
~~~~
1. yes [This is indeed correct.] [x]
1. no [Are you sure this is not correct?]


## Question 3

The following statement is syntactically correct.

~~~~fortran
do i = 1:N
    x = f(x, i)
end do
~~~~
1. yes [Check the syntax again.]
1. no [Indeed, this is not how the lower and upper limit are specified.] [x]


## Question 4

The following statement is syntactically correct.

~~~~fortran
do i = 1, N
    x = f(x, i)
end do
~~~~
1. yes [Indeed, this syntax if correct.] [x]
1. no [Check the syntax again.]


## Question 5

The following statement is syntactically correct.

~~~~fortran
do i = 1, N &
    x = f(x, i)
~~~~
1. yes [Check the syntax again, there is no such form of the do-loop.]
1. no [Indeed, this will not compile.] [x]


## Question 6

How many iteration will be executed by the iteration statement below?

~~~~fortran
do i = 1, 5, 3
    print *, i
end do
~~~~
1. 5 [No, try it out.]
1. 2 [Indeed, for `i = 1` and `i = 4`.] [x]
1. 1 [No, try it out.]
1. 3 [No, try it out.]


## Question 7

How many iteration will be executed by the iteration statement below?

~~~~fortran
do i = 5, 5, 2
    print *, i
end do
~~~~
1. 5 [No, try it out.]
1. 2 [No, try it out.]
1. 1 [Indeed, for `i = 5`.] [x]
1. 0 [No, try it out.]


## Question 8

How many iteration will be executed by the iteration statement below?

~~~~fortran
do i = 5, 3
    print *, i
end do
~~~~
1. 5 [No, try it out.]
1. 3 [No, try it out.]
1. 0 [Indeed, no iterations are executed.] [x]
1. You get a compilation error [No, try it out.]
