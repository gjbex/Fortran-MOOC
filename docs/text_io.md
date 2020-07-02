# Text input/output

Fortran has fairly sophisticated input/output features.  It has three access
modes, sequential, direct and stream access.  File records can be formatted
or unformatted.  Each of these access modes and record types has its
respective merits and you will learn about all of them.

I/O operations can be done on two types of files, internal, i.e., in memory,
and external, i.e., files on a file system.  The latter is arguably the
most widely used, although there are applications for the former as well.
In Fortran, file operations are associated with unit numbers, which you can
compare with file descriptors in C.

In this section we will concentrate on formatted, sequential input/output on
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
format.  For very simple I/O this may be sufficient.  the following code
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
write to a new line of the output file.  It 

Although this is no doubt the easiest way to write to standard output, the
formatting is likely not always what you want it to look like.  This is where
non-trivial format specifiers come in.


## Format specification


