# Iteratoin statements

All programming languages have iteration statements, and so does Fortran.  It has two,
the do statement intended to execute a block of statements a number of times, and
a while statement to exectute a block of statements for as long as a logical expression
evaluates to true.

## do statement

The do statement will repeat a block of statements a number of times.  As a very
simple example, consider the following program that computes the factorial function
for a number of integers.  The general from is given below.

~~~~
do <variable> = <start>, <end>, <step>
    <statements>
end do
~~~~

The `<variable>` has to be of type `integer`, while `<start>`, `<end>` and `<step>`
should be integer expressions.  The `do` and `end do` bracket the `<statements>`
hat will be repeated.  In the first iteration, `<variable>` will have the value
`<start>`, in the second iteration its value will be `<start>` + `<step>` and
so on till the last iteration where its value will be equal to
`<end>` - mod(`<end>`, `<step>`).

  * If `<step>` is zero, the program will crash.
  * If `<step>` is positive and `<start>` > `<end>`, then the do statement is not
    executed.  Similarly, it will also not be executed if `<step>` is negative, and
    `<start>` < `<end>`.
  * Otherwise, the number of iterations is (`<end>` - `<start>` + `<step>`)/`<step>`.

Here, the expression *m*/*n* denotes the integer division.

When the do statement terminates, the value of `<variable>` is
`<start>` + `<step>` \* number of iterations.

The step needs not to be specified, and in that case will have the default value 1.

~~~~
do <variable> = <start>, <end>
    <statements>
end do
~~~~

In the code below, there is a do statement in the program, and another in the
factorial function.

~~~~fortran
program do_factorials
    implicit none
    integer, parameter :: MAX_N = 10
    integer :: i

    do i = 1, MAX_N
        print *, i, factorial(i)
    end do

contains

    function factorial(n) result(fac)
        implicit none
        integer, intent(in) :: n
        integer :: fac
        integer :: i

        fac = 1
        do i = 2, n
            fac = fac*i
        end do
    end function factorial

end program do_factorials
~~~~

The do statement in the factorial function will only be executed when its argument
`n` is larger than 1.

Note that the number of iterations is fixed once the do statement starts executing.
The exrepssions for `<start>`, `<end>` and `<step>` are evaluated once.  If they
would contain varaibles that are changed in the `<statements>` of the loop, that will
not change the number of iterations.

Also note that modifying the iteration variable `<variable>` by a statement in
`<statemens>` is forbidden.  The compiler will report an error.  As a consequence,
when you nest do statements, they should have a different iteration variable.


## while statement

Fortran's second iteration statement is a while statement.  Its general form is given
below.

~~~~
do while (<logical expression>)
    <statements>
end do
~~~~

Before the start of each iteration, `<logical expression>` is evaluated.  If it
evaluates to true, `<statements>` are executed, if it evaluates to false, the
iteration statement ends.

The function below computes the greatest common divisor of two integer values. It
will keep iterating as long as `a` is not equal to `b`, computing and assigning new
values to `a` or `b` in each iteration.

~~~~fortran
integer function gcd(a, b)
    implicit none
    integer, value :: a, b
    integer :: x, y

    do while (a /= b)
        if (a > b) then
            a = a - b
        else if (b > a) then
            b = b - a
        end if
    end do
    gcd = a
end function gcd
~~~~


## Equivalence of do and while statements versus semantics

In fact, any do statement can be converted to a while statement.  The general form
of the do statement is given below.

~~~~
do <variable> = <start>, <end>, <step>
    <statements>
end do
~~~~

The equivalent while loop would be the follownig.

~~~~
<variable> = <start>
do while (<variable> <= <end>)
    <statements>
    <variable> = <variable> + <step>
end do
~~~~

Obviously, the do statement conveys your intentions much better than the while
statement.


## exit and cycle


## Infinite loops
