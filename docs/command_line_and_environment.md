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
`command_argument_count`.  The second argument is a character variable
to which the subroutine will assign the value passed on the command line.

~~~~fortran
character(len=20) :: buffer
integer :: istat
call get_command_argument(1, buffer, status=istat)
if (istat /= 0) then
    ...
~~~~

The status variable will be zero if the call succeeded without issues, it
will be negative if the value was truncated, positive if the call failed.
It is of course good practice to check the status after a call to
`get_command_argument`.

The subroutine has an additional optional argument `length` that can be used
to retrieve the length of the command argument.

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


## Command name

For some applications, it can be convenient to retrieve the command as it was
entered on the command line.  For the running example, that would be
`./command_argument_test`.

The intrinsic subroutine `get_command` can be used to get this string.

~~~~fortran
...
character(len=128) :: command_name
...
call get_command(command_name)
...
~~~~

Note that the length of the character variable should be large enough.  If not,
the name will be truncated

If you only want to retrieve the actual command and not its arguments, you can 
call `get_command_argument` with 0 as its first argument.


## Environment variables

Retrieving environment variables is very similar to retrieving command line
arguments.  The relevant intrinsic subroutine is `get_environment_variable`.
For instance, the following code fragment retrieves the value of the `HOME`
environment variable 

~~~~fortran
...
character(len=256) :: home_dir
integer :: istat
...
call get_environment_variable('HOME', home_dir, status=istat)
if (istat /= 0) then
    ...
~~~~

It should be stressed once more that it is important to check the status since
your application may do some rather unexpected things when a value is truncated.
