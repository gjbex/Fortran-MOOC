# Text input

Text can be read from the keyboard using the unit `input_unit` defined in the
`iso_fortran_env` module, or from external files.

In this section we will concentrate on sequential, formatted input.  In later
sections you will learn about direct and streaming access, as well as
reading unformatted data.


## Edit descriptors

Almost all edit descriptors that you encountered for formatted output work
for input as well.  The main exception is that zero-width integer and real
descriptors are not allowed.

This raises the issue that if you use edit descriptors to read data, the
data must be formatted *exactly* as specified by the descriptor.  If that is
the case, you risk reading garbage values into your variables or crashing your
program.  Best practice is to use the exact for input and output of data.

If you can not control the format of the data precisely, you can still read
the data using `*` as format specifier.  Consider the following somewhat
messy data file.

~~~~
3.13 12 F gamma
-0.17e-3 -13 t alpha
123.15e2 0 f beta
~~~~

Each line of the file has a real, an integer, a logical and a character value.
The following program reads the values from standard input, and prints the
values to standard output.

~~~~fortran
program read_messy_data
    use, intrinsic :: iso_fortran_env, only : input_unit, error_unit
    implicit none
    integer, parameter ::  nr_values = 3
    real, dimension(nr_values) :: real_values
    integer, dimension(nr_values) :: int_values
    logical, dimension(nr_values) :: logical_values
    character(len=20), dimension(nr_values) :: char_values
    integer :: i, istat
    character(len=1024) :: msg

    do i = 1, nr_values
        read (unit=input_unit, fmt=*, iostat=istat, iomsg=msg) &
            real_values(i), int_values(i), logical_values(i), char_values(i)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'error: ', trim(msg)
            stop 1
        end if
    end do

    print '(*(E20.7))', real_values
    print '(*(I20))', int_values
    print '(*(L20))', logical_values
    print '(*(A20))', char_values

end program read_messy_data
~~~~

Again, it is best practice to check the value of the I/O status after each
read statement.  If everything went well, the I/O status will be zero.
Typically, two categories of problems can arise.  The characters read from
the input can not be converted to the data type of the corresponding variable,
or the end of the input is reached.  You can easily distinguish between these
two situation based on the value of the I/O status variable.  The status will
be `iostat_end`, defined in the `iso_fortran_env` module if the end of the
file was reached.  The value will be strictly positive if the input could not
be converted to the appropriate data type.


## Reading files

If you want to read from a file rather than from standard input, you should
open the file before the first read statement, and close it after the last.

The only status that makes sense for reading a file is `old`, indeed you can
hardly read a file that doesn't exist.

~~~~fortran
open (newunit=unit_nr, file=file_name, access='sequential', action='read', &
      status='old', iostat=istat, iomsg=msg)
~~~~

Although less potentially disastrous as for files that are open for writing,
it is nevertheless good practice to close a file that is open for reading as
well.


## Reading from strings

Reading from strings can be very useful to convert a string representation
to another data type.

~~~~fortran
...
character(len=64) :: buffer
integer :: nr_values, istat
character(len=1024) :: msg
...
read(buffer, fmt='(I64)', iostat=istat, iomsg=msg) nr_values
if (istat /= 0) then
    write (unit=error_unit, fmt='(2A)') 'error: ', msg
    stop 1
end if
...
~~~~
