# Iteration statements

All programming languages have iteration statements, and so does Fortran.  It has two,
the do statement intended to execute a block of statements a number of times, and
a while statement to execute a block of statements for as long as a logical expression
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
should be integer expressions.  The `do` and `end do` delimit the `<statements>`
that will be repeated.  In the first iteration, `<variable>` will have the value
`<start>`, in the second iteration its value will be `<start>` + `<step>` and
so on till the last iteration.

  * If `<step>` is zero, the program will crash.
  * If `<step>` is positive and `<start>` > `<end>`, then the do statement is not
    executed.  Similarly, it will also not be executed if `<step>` is negative, and
    `<start>` < `<end>`.
  * Otherwise, the number of iterations is `<nr_iter>` = (`<end>` - `<start>` + `<step>`)/`<step>`.

In the last iteration, `<variable>` will have the value
`<start>` + (`<nr_iter>` - 1)\*`<step>`, and after the execution of the do
statement `<variable>` will have the value `<start>` + `<nr_iter>`\*`<step>`.

Here, the expression $$m/n$$ denotes the integer division.


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
The expressions for `<start>`, `<end>` and `<step>` are evaluated once.  If they
would contain variables that are changed in the `<statements>` of the loop, that will
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

The equivalent while loop would be the following.

~~~~
<variable> = <start>
do while (<variable> <= <end>)
    <statements>
    <variable> = <variable> + <step>
end do
~~~~

Here, we assume that `<step>` is positive.  A similar equivalence can be defined
for negative values of `<step>`.

Obviously, the do statement conveys your intentions much better than the while
statement.


## Infinite loops, exit and cycle

Implementing an infinite loop, i.e., a loop statement that never terminates is quite
easy in Fortran.

~~~~
do
    <statements>
end do
~~~~

The `<statements>` will continue to be executed unless there is a stop or an exit
statement in `<statements>`.  You might ask why anyone would want to program an
infinite loop on purpose.  A few scenarios come to mind:

  * programs that handle streams of data, e.g., parsers;
  * programs that handle events, e.g., network services.

Although their functionality can be accomplished using a while statement, it is often
quite cumbersome.  You should realize that this is a contentious statement that many
will not agree with.

Infinite loops raise the obvious question whether you can still exit them without
terminating the application by the operating system.  There are two options, depending
on what you want to accomplish that will terminate any iteration statement:

  * the stop statement would terminate the execution of the program, and
  * the exit statement would terminate the execution of the do statement, and
    continue executing the next statement.

The following program illustrates both an infinite loop, and the use of an exit
statement.  It reads floating point values from standard input, and computes the sum.
When there is no more input, `stat` will have a negative values (end-of-file), and
the iteration statement is terminated using the `exit` statement. The next statement
prints the sum.

~~~~fortran
program sum_values
    use, intrinsic :: iso_fortran_env, only : input_unit
    implicit none
    real :: val, total
    integer :: stat

    total = 0.0
    do
        read (unit=input_unit, fmt=*, iostat=stat) val
        if (stat < 0) exit
        if (stat > 0) cycle
        total = total + val
    end do
    print *, total
end program sum_values
~~~~

This code also illustrates the cycle statement.  Its semantics is that it will start
the next iteration, skipping all statements in the block below it.  In this case, `stat`
will have a non-zero positive value when the line that was read from standard input
could not be converted to a `real` value.  If that is the case, the assignment
statement to the variable `total` will not be executed.

Note that the following program would be equivalent, avoiding an infinite loop, as well
as exit and cycle statements.

~~~~fortran
program sum_values
    use, intrinsic :: iso_fortran_env, only : input_unit
    implicit none
    real :: val, total
    integer :: stat

    total = 0.0
    stat = 0
    do while (stat >= 0)
        read (unit=input_unit, fmt=*, iostat=stat) val
        if (stat == 0) total = total + val
    end do
    print *, total
end program sum_values
~~~~

Arguably, the code in this version of the program is even cleaner that the first one,
but it will be hard to generalize to more complex situations.
