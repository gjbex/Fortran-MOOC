# User defined types and I/O

Formatted output is accomplished using edit descriptors  as you've seen
before.  A large number of descriptors is available for Fortran's
built-in types.  However, it is also possible to define edit descriptors for user
defined types, although it is not quite trivial.  This is called derived type
I/O.

Consider a type that represents quantities required for descriptive statistics
(mean value, standard deviation) on streaming data.  The type's elements are
shown below.

~~~~fortran
type, public :: descriptive_stats_t
    private
    integer :: nr_values = 0
    real :: sum = 0.0, sum2 = 0.0
contains
    procedure, public, pass :: add_value, get_nr_values, get_mean, get_stddev
end type descriptive_stats_t
~~~~

The type bound procedure `add_value` will update the variable's elements
`nr_values`, `sum` and `sum2` with a new, incoming data value.  The
functions `get_mean` and `get_stddev` return the current value of the
mean and standard deviation of the data processed so far.  The function
`get_nr_values` returns the number of data values seen so far. 

It would be convenient to have a formatting code for a value of this user
defined type.  The first step towards this is to define a procedure to
produce the appropriate output.

~~~~fortran
subroutine write_stats(stats, unit_nr, iotype, v_list, iostat, iomsg)
    implicit none
    class(descriptive_stats_t), intent(in) :: stats
    integer, intent(in) :: unit_nr
    character(len=*), intent(in) :: iotype
    integer, dimension(:), intent(in) :: v_list
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
    character(len=1024) :: fmt_str

    if (size(v_list) == 4) then
        write (fmt_str, '(A, 2(A, I0, A, I0), A)') &
            '("n = ", I0', &
            ', ", mean = ", F', v_list(1), '.', v_list(2), &
            ', ", stddev = ", F', v_list(3), '.', v_list(4), &
            ')'
        write (unit=unit_nr, fmt=fmt_str, iostat=iostat, iomsg=iomsg) &
            stats%get_nr_values(), stats%get_mean(), stats%get_stddev()
    else
        write (unit=unit_nr, fmt=*, iostat=iostat, iomsg=iomsg) &
            stats%get_nr_values(), stats%get_mean(), stats%get_stddev()
    end if
end subroutine write_stats
~~~~

The first argument `stats` of the subroutine is the value of this user defined
type that you want to print.  The second argument, `unit_nr` is the unit you
want to write to.  The `iostat` argument's value is typically ignored, it is
mostly present for compatibility with unformatted I/O.  The fourth argument,
`v_list` is an array that contains the arguments to the edit descriptor when it
is used in a format.  In this case, it can have 4 values, the width and
number of digits to write for the mean value, and similar for the standard
deviation.  This is a very simple example, so if the size of the `v_list` array
is not equal to 4 values, we use defaults.  The last two arguments will be
set to the I/O status, and in case there is a problem, the I/O message of the
underlying write statements.

Either a format string is built based on the values in `v_list`, or a default
is used to write the values to the destination unit.

The next step is to ensure that this subroutine will be used to print values
of this type, and that can be done by adding it to the type.

~~~~format
type, public :: descriptive_stats_t
    private
    integer :: nr_values = 0
    real :: sum = 0.0, sum2 = 0.0
contains
    procedure, public, pass :: add_value, get_nr_values, get_mean, get_stddev
    procedure, private :: write_stats
    generic :: write(formatted) => write_stats
end type descriptive_stats_t
~~~~

The subroutine `write_stats` is a type bound procedure and it is declared
Private since it is not intended to be called directly.  It is bound to a
formatted write operation using generic.

Finally, you can use the edit descriptor in a format string for a write
statement, as for instance in the program compilation unit below.

~~~~fortran
program descriptive_statistics
    use, intrinsic :: iso_fortran_env, only : error_unit, input_unit, output_unit
    use :: stats_mod
    implicit none
    type(descriptive_stats_t) :: stats
    integer :: istat
    character(len=2048) :: msg
    real :: data_value

    do
        read (unit=input_unit, fmt=*, iostat=istat, iomsg=msg) data_value
        if (istat == -1) exit
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') 'warning: ', trim(msg)
            cycle
        end if
        call stats%add_value(data_value)
    end do
    print '(A, I0)', 'n      = ', stats%get_nr_values()
    print '(A, F10.3)', 'mean   = ', stats%get_mean()
    print '(A, F10.3)', 'stddev = ', stats%get_stddev()
    write (unit=output_unit, fmt='(dt)') stats
    print '(dt(7, 2, 7, 2))', stats

end program descriptive_statistics
~~~~

The `dt` edit descriptor is used with 4 arguments, the width  and number of
digits for the mean value, and the standard deviation respectively.

It is equally possible to write a subroutine to read a user defined type, but
that is typically fairly brittle, so we won't go into that here.
