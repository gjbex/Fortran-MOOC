# Formatting conventions

Historically, Fortran had two formatting styles.  Prior to
Fortran 90, code had to be written in so-called fixed source form.
Fortran 90 introduced free source form which is much more
convenient.  Here, we'll only use free format style, but add
notes on fixed format once in a while in case you're interested.


## Why follow formatting conventions?

Each programming language has its own conventions of how
to format source code, and you may be familiar with those
for C, C++, Java or Python. Regardless, it is important
to use those that are specific to the programming language
you are using.  Doing so makes it easier for other programmers
familiar with Fortran to understand your code quickly.

The one exception is when you work in a team or on a code
base that has established its own set of formatting rules,
in that case, follow those.

The motivation is the same: programming is storytelling, the
story should be easy to follow.  The bottom line is:
*be consistent!*


## Use upper case or lower case?

Fortran is not case sensitive, so `SUBROUTINE` is the same as
`subroutine`.  There is empirical evidence that lowercase words
are easier to read than uppercase, so the choice is easy.

In some text books, you will see Fortran keywords such as `if`,
'end if` or `subroutine` rendered in upper case, as opposed to
variable names, procedure names and so on. We will not use this
convention here.

The one exception is for the names of constants, e.g.,

~~~~fortran
integer, parameter :: NR_PARTICLES = 1000
~~~~


## Do you have to use indentation?

Yes, you do.

Indentation really helps to visualize the structure
of your code, and will make it easier to understand.  Each nested
block of code gets indented by an additional level.

~~~~fortran
integer function gcd(a, b)
    implicit none
    integer, intent(in) :: a, b
    integer :: x, y

    x = a
    y = b
    do while (x /= y)
        if (x > y) then
            x = x - y
        else if (y > x) then
            y = y - x
        end if
    end do
    gcd = x
end function gcd
~~~~

Opinions differ on how many space to use to indent a block of
code.  Whatever number you pick, be consistent.  Here, we will
use 4 spaces.

Don't use tabs for indentation, the width a tab is visually
expanded to depends on the settings of your editor, so what
may seem nicely indented to you may be gibberish to someone
else if indentation by tabs and spaces is mixed.  And trust me,
it will at some point.

Historical note: prior to Fortran 90 code had to be
formatted in a very specific way.  The first five characters of
each line would be reserved for numerical labels, if required.
The sixth character had to be blank, unless that line was a
continuation of a previous line.  This convention goes back to
the days when code was written on punch cards.


## Should I stick to a maximum line length?

The Fortran specification states that the maximum line length
for free source form is 132 characters.  Although many compilers
will accept longer lines of code, you should nevertheless respect
the specification.

Furthermore, it can be convenient to limit the line length in
practice to fit in a 80 column terminal window.  This is the
convention that will be followed in the code examples presented
here.

The Fortran syntax is pretty strict about what should go on a
line, and doesn't allow to break lines arbitrarily.  For instance,
consider the following code.

~~~~fortran
if (0.0 <= x_coord .and. x_coord <= X_MAX .and.
    0.0 <= y_coord .and. y_coord <= Y_MAX) then
    ...
end if
~~~~

If you would try to compile this code, the compiler would report
a syntax error.  The if-statement should be on a single line.
However, that would make the code harder to read, and the number of
characters on a line would potentially exceed the limit of 132.

You can indicate that a line will be continued on the next by using
the `&` character at the end.  So the code fragment above would
compile when '&' is added to the first line.

~~~~fortran
if (0.0 <= x_coord .and. x_coord <= X_MAX .and. &
    0.0 <= y_coord .and. y_coord <= Y_MAX) then
    ...
end if
~~~~

Optionally, the line that continues a previous line can also start
with an `&` character, i.e.,

~~~~fortran
if (0.0 <= x_coord .and. x_coord <= X_MAX .and. &
  & 0.0 <= y_coord .and. y_coord <= Y_MaX) then
    ...
end if
~~~~

Although we will typically not use this feature since it makes
the code harder to read, there is one case where it is actually
very useful.

~~~~fortran
character(len=120) :: message = 'Warning: the number of&
                               & characters exceeds the prefered&
                               & limit.'
~~~~

Here, the string would be

~~~~
Warning: the number of characters exceeds the prefered limit.
~~~~

The spaces preceding the `&` on the continuation lines are ignored
in the value of the string.

Historical note: fixed source form restricted the maximum line
length to 72 characters.  again, this was a limitation due to the
use of punch cards.  To indicate that a line is a continuation of
a previous line, you would use a non-zero character in the sixth
column.


## How should I use white space?

Using white space appropriately can make your code easier to read.
The general advise is to use white space as you would in written
English and mathematics.

For example, commas should be followed by a space, keywords and
parentheses should be separated by a space.  Operands and
operators should be separated by a space.

Compare the following code

~~~~fortran
if (0.0 < x) then
    y = f(x, y)
end if
~~~~

with the following which is legal, but harder to read

~~~~fortran
if(0.0<x)then
    y=f(x,y)
endif
~~~~
