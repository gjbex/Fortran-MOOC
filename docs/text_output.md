# Text output

Fortran has fairly sophisticated input/output features.  It has three access
modes, sequential, direct and stream access.  File records can be formatted
or unformatted.  Each of these access modes and record types has its
respective merits and you will learn about all of them.

I/O operations can be done on two types of files, internal, i.e., in memory,
and external, i.e., files on a file system.  The latter is arguably the
most widely used, although there are applications for the former as well.
In Fortran, file operations are associated with unit numbers, which you can
compare with file descriptors in C.

In this section we will concentrate on formatted, sequential output on
external files.


## Writing data

Fortran has two statements to write data, `print` and `write`.  The print
statement will write data to standard output, i.e., the data that will be
displayed by the terminal while your application runs.

The write statement is more general since it can write to arbitrary units,
although it can be used to write to standard output as well when the
appropriate unit number is specified.  The unit number of standard output
is defined in the intrinsic module `iso_fortran_env` and is called
`output_unit`.

A second distinction between the print and the write statements is that the
former can only do formatted, sequential output, while write can do any type of
output.  Since the print statement is the simplest, we will first discuss this.


### print statement

The general form of the print statement is given below.

~~~~
print <fmt>, <list-of-expressions>
~~~~

The `<list-of-expressions>` is a comma separated list of expressions, e.g.,
variables, mathematical expression or function calls.

The simplest value for the format specifier `<fmt>` is simply `*`.  This
leaves it up to the Fortran runtime to determine the appropriate output
format.  For very simple I/O this may be sufficient.  The following code
illustrates the default output format for various data types.

~~~~fortran
program print_test
    use, intrinsic :: iso_fortran_env, only : SP => REAL32, DP => REAL64
    implicit none
    integer, parameter :: n = 15
    real(kind=SP), parameter :: x = 3.14_SP
    real(kind=DP), parameter :: y = 2.69_DP
    character(len=10), parameter :: c = 'abc'
    logical, parameter :: l = .true.
    type udf
        real :: x
        integer :: n
    end type udf
    type(udf), parameter :: u = udf(x = 3.5, n = 7)
    real, dimension(3) :: v = [ 3.5, 5.7, 7.3 ]
    integer, dimension(2, 3) :: A = reshape( [ 3, 7, 5, 9, 2, 4 ], [ 2, 3 ])

    print *, '|', n, '|'
    print *, '|', x, '|'
    print *, '|', y, '|'
    print *, '|', c, '|'
    print *, '|', l, '|'
    print *, '|', u, '|'
    print *, '|', v, '|'
    print *, '|', A, '|'
end program print_test
~~~~

This application produces the following output.

~~~~
 |          15 |
 |   3.14000010     |
 |   2.6899999999999999      |
 |abc       |
 | T |
 |   3.50000000               7 |
 |   3.50000000       5.69999981       7.30000019     |
 |           3           7           5           9           2           4 |
~~~~

As you can see, using the `*` format specifier, the print statement can print
scalar values such as real and integer numbers, logical and character values,
but also user defined types and (multi-) dimensional arrays.

Note the single space at the start of each line.  Each print statement will
write to a new line of the output file.

Although this is no doubt the easiest way to write to standard output, the
formatting is likely not always what you want it to look like.  This is where
non-trivial format specifiers come in.


## Format specification

To control the format of the output, the print statement allows to provide
a format string, also called edit descriptor.  This can either be a literal
string, or a character variable.

For each data type, one or more descriptors are available, e.g., `I` for
integer, `E` and `F` for real values, `A` for characters and so on.  The
descriptor is typically followed by a number indicating the number of
characters to be used to represent the value.  If the width is not
sufficient to represent the values, `*` characters will be printed
instead.  It is rather frustrating to perform a long computation, and end up
with output consisting (partly) of only asterisk symbols, so choose your width
wisely.

The following program illustrates the point.

~~~~fortran
program print_asterisks
    implicit none
    integer :: i = 123456
    character(len=6) :: c = 'abcdef'

    print '(I8)', i
    print '(I4)', i

    print '(A8)', c
    print '(A4)', c

end program print_asterisks
~~~~

The output produced by this application is shown below.

~~~~
  123456
****
  abcdef
abcd
~~~~

As you can see, it is possible to print character values with a width
that is less than the length of the string, but you loose information.


### Integer edit descriptor

The edit descriptor for integer values is `I<w>`, where `<w>` is a positive
integer that specifies the width.  The value is right-aligned, and padded with
spaces if necessary.  For positive values, no sign is printed.

For example, the descriptor `I5` would result in the following output for

| value    | output   |
|----------|----------|
| 123      | `##123`  |
| -123     | `#-123`  |
| 123456   | `*****`  |
| -12345   | `*****`  |

The character `#` is used to visually represent a space, it would of course
not be written out.

A second form of the descriptor is `I<w>.<d>` where `<w>` is again the width
of the string to be written, and `<d>` is the number of digits.  If the number
of characters to represent the integer is less than `<d>`, the value is padded
with `0`.

For example, the descriptor `I5.3` would result in the following output for

| value    | output   |
|----------|----------|
| 123      | `##123`  |
| 12       | `##012`  |
| -1       | `#-001`  |
| 123456   | `*****`  |

Obviously, `<d>` should be less than or equal to `<w>`.

It is very convenient that `<w>` can be equal to 0, in which case the
minimum width required to show the value is automatically computed. It can be
combined with a specification for the number of digits, e.g., `I0.4` which
would apply zero-padding for integer values with a width of less than 3.


### Real edit descriptors

To format real values, quite some options are available.  The most common ones
are `F` and `E`.  They can be used for single and double precision values.

#### `F` edit descriptor

The `F` format the real value in floating point notation.  Similar to the
integer edit descriptor, the width `<w>` should be specified, and optionally,
`<d>`, the number of digits after the decimal dot.  For example, for `F6.2`
the following strings would be written.

| value    | output          |
|----------|-----------------|
| 1.23     | `##1.23`        |
| 1.239    | `##1.24`        |
| -1.23    | `#-1.23`        |
| 1.23e-2  | `##0.01`        |
| 1.23e-7  | `##0.00`        |
| 1.23e7   | `******`        |


Similar to the integer edit descriptor, the width can also be 0 and in that
case the appropriate width will be computed, e.g., `F0.3` would write values
with 3 digits after the decimal dot.

#### `E`, `EN`, `ES` edit descriptors

The `E` edit descriptor will output real values in scientific notation.  For
example, for `E10.2` the output would be.

| value    | output          |
|----------|-----------------|
| 1.23     | `##0.12e+01`    |
| 1.29     | `##0.13e+01`    |
| -1.23    | `#-0.12e+01`    |
| 1.23e5   | `##0.12e+01`    |

The results of edit descriptor can be somewhat inconsistent since leading
zeroes will be left out in order to fit the width if required.

Note that the width *can not* be equal to zero according to the Fortran
specification.  However, some compilers support it (GCC 10.x) while others do
not (Intel 2018).

The `E` edit descriptor can take a second form: `e<w>.<d>e<x>` where `<w>` and
`<d>` have the same semantics as previously explained.  The `<x>` is the number
of digits used for the exponent.  For example, `E15.4e3`would write 123.45678
as `####0.1235e+003`.

The `ES` descriptor is very similar to the `E` edit descriptor, although it
will ensure that the decimal is between 1 and 9.  This output format is more
in line with other programming languages such as C, C++ and Python.

The `EN` produces output in engineering notation, rather than scientific
notation.  For example, the value 12345.678 would be written as `#12.35e+03`
when using the edit descriptor `EN10.2`.

There is a relationship between the width and the number of digits.  For
single precision numbers, `<w> >= <d> + 7`, and `<w> >= <d> + 9` for double
precision.  For the second from of the edit descriptors,
`<w> >= <d> + <x> + 5`.

#### Complex numbers

For complex numbers, two edit descriptors for real values have to be provided.
They can, but don't have to be the same.  For instance, the edit
descriptor `E10.3,E10.3` could be used.

Note that this would be better written as `2E10.3` as you will see later.


### Logical edit descriptor

The edit descriptor for logical values is `L<w>`.  It will print `F` for false,
`T` for true. The value will be right-aligned, and padded with spaces if the
width is larger than one.


### Character edit descriptor

The edit descriptor for character values is `A` or `A<w>` where `<w>`
represents the width.  If the width `<w>` is omitted, the length of the string
will be used.  If the width is larger than the length of the string, the output
is left-aligned, and padded with spaces.


### General edit descriptor

The general edit descriptor `G<w>.<d>` can be used for integer, real, logical
and character values.  Its simplest form is `G0` where it will choose the
appropriate width for the value.  Although this is very convenient, you
should note that for real values, the number of digits is compiler dependent,
so the code may not be entirely portable.


## Combining descriptors

Up to now, we have discussed edit descriptors for individual values.  However,
you will often use edit descriptors to output multiple values.  For instance,
to output a real value followed by an integer value, you  would use, e.g.,
`(E12.3, I5)'.  The following code fragment illustrates a full example.

~~~~fortran
...
real :: x = 17.3e5
integer :: i = 19
...
print '(E12.3, I5)', x, i
...
~~~~

This would produce the following output.
~~~~
   0.173e+05   19
~~~~

An edit descriptor can also be repeated, for instance, to write five
real numbers, you could use `(5E13.3)`.  This repetion factor can also be `*`
to indicate an unlimited number of repetitions, e.g.,

~~~~
subroutine print_vector(label, vector)
    implicit none
    character(len=:), intent(in) :: label
    real, dimension(:), intent(in) :: vector

    print '(A, ": ", *(E13.3))', label, vector
end subroutine print_vector
~~~~

Parentheses can be used to group edit descriptors.  For instance, to
print three pairs of a string and an integer value, you can use `(3(A, I0))`.

The example above also illustrates that string literals can be part of an edit
descriptor, i.e., `": "` in this example.

You can use the `/` edit descriptor to start a new line, e.g., the descriptor
`(I0,/,I0)` would write the second integer on the next line of output.


## Output to files

Writing to a file is very similar to writing to standard output.  The write
statement takes the unit number as its first argument.  For standard output and
standard error, those are defined in the `iso_fortran_env` module.

To write to a file, that file first has to be opened.  You can either specify
a unit number yourself, or have the Fortran runtime assign one for you.

The open statement takes a lot of arguments:

1. `unit`, the unit number to use, or `newunit` to assign a new unit number;
1. `file`, the file name to use;
1. `access`, this can be `sequential`, `direct` or `stream`;
1. `action`, this can be `write`, `readwrite` or `read`;
1. `status`, this can be `new`, `old`, `replace` or `scratch`;
1. `form`, this can be `formatted` or `unformatted`;
1. `position`, this is the position to start writing, it can be `rewind` or
   `append`;
1. `iostat`, represents the exit status of the statement, non-zero if there
   were issues;
1. `iomsg`, this is the error message in case something went wrong.

You will learn about the options in other sections, here we will only discuss
`access='write'`, `status=`new``, `status='replace'`, `form='formatted'`.

For example, you can use the following open statement to open a new file
`text.txt` for writing formatted output.

~~~~fortran
program newunit_test
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    integer :: unit_nr, istat
    character(len=1024) :: msg

    open (newunit=unit_nr, file='text.txt', access='sequential', action='write', &
          status='new', form='formatted', iostat=istat, iomsg=msg)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
        stop 1
     end if
     write (unit=unit_nr, fmt='(A)') 'hello world!'
     close (unit=unit_nr)
end program newunit_test
~~~~

The unit number will be assigned to the variable `unit_nr` in the open
statement, this is the most convenient way to avoid conflicting unit numbers.
The value assigned to the variable `iostat` is checked, and if the value is
non-zero, an error message is written to the `error_unit`.  If that is not the
case, the unit number can be used for subsequent operations, such as the write
statement.  When all data has been written, the unit can be closed using
the close statement.

It is good practice to always use `iostat` to verify that I/O operations
succeeded, also in, e.g., write and close statements where they have been
omitted for the sake of brevity.  For instance, a write statement might fail
because you exceed disk quota.

It is also good practice to close a unit.  Failing to do so may result in data
loss or corrupt files when the unit was open for `write` or `readwrite`.

The file name can be given as an absolute path, or, as in this example, a
relative path.  In the latter case, the path is interpreted relative to the
current working directory as you would expect.

The status of the file can be `new`, `old` or `replace` for action `write`.
If the access is `new`, an error occurs when the file already exists.  If the
status is `old`, an error occurs when the file does not yet exist.  If the
status is `replace`, a new file will be created if it doesn't exist yet, or
it will be overwritten otherwise.

Most programming languages allow to open files directly in append mode, i.e.,
new data will be added at the end of an existing file.  This is possible in
Fortran as well, but it is somewhat more cumbersome.  You would have to open
an existing file with status `old`, and additionally specify
`position='append'`.


## Creating strings

Although this section is about writing to text files, as a small aside, we
will briefly discuss creating strings.  The write statement can be applied
to a character variable to create a formatted string.  As an example, consider
that you might want to let the number of digits in an edit description for
a real number depend on some runtime conditions.

~~~~fortran
...
character(len=10) :: fmt_str
integer :: nr_digits
real :: x
...
write (fmt_str, "('(E', I0, '.', I0, ')')" nr_digits + 7, nr_digits
write (unit=output_unit, fmt=fmt_str) x
...
~~~~

If the variable `nr_digits` has the value 5, the value of `fmt_str` would be
`(E12.5)'.
