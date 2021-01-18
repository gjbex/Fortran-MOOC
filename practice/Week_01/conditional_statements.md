# Conditoinal statements

## Question 1

The following statement is syntactically correct.
~~~~fortran
if x > 5 then
    x = x + 3
end if
~~~~
1. yes [Check the syntax again.]
1. no [Indeed, the parenthesis are missing.] [x]


## Question 2

The following statement is syntactically correct.
~~~~fortran
if (x > 5)
    x = x + 3
~~~~
1. yes [Check of a logical if-statement.]
1. no [A logical if-statement has to be on a single line.] [x]


## Question 3

The following statement is syntactically correct.
~~~~fortran
if (x > 5) then
    x = x + 3
end if
~~~~
1. yes [This is correct.] [x]
1. no [Have a look at the syntax again.]


## Question 4

If the value of `x` is 3 and the value of `y` is 2, which statement will be executed?
~~~~fortran
if (x > 5) then
if (y > 5) then
x = x + 3
else
x = x - 3
end if
end if
~~~~
1. `x = x + 3` [Not really, check again.]
1. `x = x - 3` [not really, check gain.]
1. neither `x = x + 3` nor `x = x - 3` [Indeed, since `x` is less than or equal to 5.] [x]
1. both `x = x + 3` and `x = 3 - 3` will be executed [That would be very strange since they and if-statements is a branching statement.]


## Question 5

The following statement is syntactically correct.
~~~~fortran
if (x > 5) then x = x + 3
~~~~
1. yes [Check of a logical if-statement.]
1. no [The syntax of logical and block if-statement are being mixed here.] [x]
