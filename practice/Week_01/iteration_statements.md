# Iteration statements

## Question 1

The following statement is syntactically correct.
~~~~fortran
while (i < 10) do
    x = f(x, i)
end do
~~~~
1. yes [Check the syntax again.]
1. no [Indeed, the parenthesis are missing.] [x]


## Question 2

The following statement is syntactically correct.
~~~~fortran
do (i < 10) while
    x = f(x, i)
end do
~~~~
1. yes [Check the syntax again.]
1. no [Indeed, the parenthesis are missing.] [x]


## Question 3

The following statement is syntactically correct.
~~~~fortran
do i = 1:N
    x = f(x, i)
end do
~~~~
1. yes [Check the syntax again.]
1. no [Indeed, the parenthesis are missing.] [x]


## Question 4

The following statement is syntactically correct.
~~~~fortran
do i = 1, N
    x = f(x, i)
end do
~~~~
1. yes [Indeed, this syntax if correct.] [x]
1. no [Check the syntax gain.]


## Question 5

The following statement is syntactically correct.
~~~~fortran
do i = 1, N &
    x = f(x, i)
~~~~
1. yes [Check the syntax again.]
1. no [Indeed, the parenthesis are missing.] [x]
