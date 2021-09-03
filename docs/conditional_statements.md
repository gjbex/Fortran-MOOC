# Conditional statements

Fortran has a number of conditional statements, just like
all programming languages that are Turing complete.


## if-statements

The first conditional statement, and the one you will use
most often is the if-statement.  Fortran has two
if-statements, the block if and the logical if.


### Block if

A block if has the following general form using the keywords
`if`, `then`, `else` and `end if`:

~~~~
if (<logical expression>) then
    <block statements 1>
else
    <block statements 2>
end if
~~~~

It checks whether a logical (or Boolean) expression
`<logical expression>` evaluates to true or false,
and executes the appropriate block of statements
accordingly.  This means `<block statements 1>` is
executed when the logical expression evaluates to true,
while `<block statements 2>` will be executed when
the logical condition evaluates to false.

Each if-statement is bracketed by `if` and `end if`.  This
makes makes the semantics of nested conditional statements
quite straightforward.

The else block is optional in a block if, so the following
statement is also legal Fortran.

~~~~
if (<logical expression>) then
    <block statements 1>
end if
~~~~

Chains of if statements can be added by using `else if`,
the structure looks as follows.

~~~~
if (<logical expression 1>) then
    <block statements 1>
else if (<logical expression 2>) then
    <block statements 2>
else
    <block statements 3>
end if
~~~~

If `<logical expression 1>` evaluates to true,
`<block statements 1>` is executed.  If that is not the
case, `<logical statements 2>` will be evaluated, and
if it is true, `<block statements 2>` will be executed.
If `<logical expression 2>` also evaluates to false,
`<block statements 3>` is executed.

You can have as many `else if` cases as you require.

The following code snippet checks whether an integer that
represents a year is a leap year or not.

~~~~fortran
logical function is_leapyear(year)
    implicit none
    integer, intent(in) :: year

    if (mod(year, 4) /= 0) then
        is_leapyear = .false.
    else if (mod(year, 100) == 0) then
        if (mod(year, 400) == 0) then
            is_leapyear = .true.
        else
            is_leapyear = .false.
        end if
    else
        is_leapyear = .true.
    end if
end function is_leapyear
~~~~

As a challenge, reduce the body of the function
`is_leapyear` to a single statement that assigns the
result of a logical expression to `is_leapyear`.


### Logical if

Fortran's second if-statement is the logical if.  It is
syntactically simpler that the block if, and is a single
line of code.

The general form is:

~~~~
if (<logical expression>) <statement>
~~~~

The logical if will execute a single statement
`<statement>` if `<logical expression>` evaluates to true.

Note that a logical if

* can only execute a single statement,
* has no `else`, and
* requires no `end if`.


## select statement

Fortran's second conditional statement is the select
statement.  Although it adds no new functionality when
compared with a chained block if statement, the compiler
can sometimes generate faster code from a select statement.

The general form is:

~~~~fortran
select case (<expression>)
    case (<expression 1>)
        <block statements 1>
    case (<expression 2>)
        <block statements 2>
    ...
    case (<expression n>)
        <block statements n>
    case default
        <block statements default>
end select
~~~~

There are restrictions on `<expression>`, it should be
an integer or a character expression.  The case expressions
`<expression 1>`, ..., `<expression n>` should be of the
same type.  The `case default` is optional.

Semantically, this would be equivalent to the following
block if.

~~~~fortran
if (<expression> == <expression 1>) then
    <block statements 1>
else if (<expression> == <expression 2>) then
    <block statements 2>
...
else if (<expression> == <expression n>) then
    <block statements n>
else
    <block statements default>
end if
~~~~

The following function uses a select statement to decide
which arithmetic operation would have to be carried out.

~~~~fortran
real(kind=DP) function calculate(op, x, y)
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    character(len=1), intent(in) :: op
    real(kind=DP), intent(in) :: x, y

    select case (op)
        case ('+')
            calculate = x + y
        case ('-')
            calculate = x - y
        case ('*')
            calculate = x*y
        case ('/')
            calculate = x/y
        case default
            write (unit=error_unit, fmt='(3A)') &
                'error: ', op, ' is not a valid operator'
            stop 1
    end select
end function calculate
~~~~
