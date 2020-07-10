# Interacting with the environment

Fortran programs are typically called from the command line.  This means that
runtime parameters are passed as command line arguments and environment
variables.


## Command line arguments

Fortran has two intrinsic procedures to deal with command line arguments,
the function `command_argument_count` and the subroutine
`get_command_argument`.  As the name implies, `command_argument_count` returns
the number of arguments with which the application is called.

For example, consider the Fortran application `command_argument_test`.

~~~~bash
$ ./command_argument_test abc 123
~~~~

For this call, the value returned by `command_argument_count` will return 2
since there are two arguments on the command line, i.e., `abc` and `123`.

~~~~fortran
nr_args = command_argument_count()
~~~~

The subroutine `get_command_argument` takes two arguments, the first
is the number of the command line argument you want to retrieve, so it should
be between 1 and the number of command line arguments as returned by
`command_argument_count`.  The second argument is a character variable that
to which the subroutine will assign the value passed on the command line.

~~~~fortran
character(len=20) :: buffer
call get_command_argument(1, buffer)
~~~~

Note that the values retrieved by `get_command_argument` are always
character values, so typically they have to be converted to the appropriate
data types.  This can be done by  reading from a string, e.g.,

~~~~fortran
...
integer :: nr_values
...
read (buffer, fmt='(I10)', iostat=istat, iomsg=msg) nr_values
~~~~

This is discussed in more detail in the section on reading formatted data.
