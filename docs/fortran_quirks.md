# Fortran quirks

Just like any programming language, Fortran has its quirks.  Here you will read about
a couple of them.


## List-directed input and forward slash

The `/` character ends list-directed input, which may confuse you.  Suppose you would
like to parse expressions from strings such as `'3.5 + 3.9'` or `'3.5 / 3.9'`.  Such
strings are stored in a variable, say `buffer`.  The following code would seem to do
the trick.

~~~~fortran
character(len=1024) :: buffer
real :: x, y
character :: op
...
read (buffer, fmt=*) x, op, y
~~~~

This would work nicely for the first example, i.e., the variables `x`, `op` and `y`
would have the values 3.5, + and 3.9 if `buffer contained `3.5 + 3.9`.  However, for
the second example when the buffer has the value `3.5 / 3.9`, the variable `x` would
have the value 3.5, but both `op` and `y` would not be assigned to since the read
statements stops processing `buffer` when it encounters a forward slash and
reading is list-directed, i.e., the format is `*`.
