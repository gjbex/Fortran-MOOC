# Object oriented programming

It may come as a surprise that you can do object oriented programming in
Fortran.  The key syntactic features that are used for this are
1. access control attributes for data encapsulation and
1. type bound procedures,
1. operator/procedure overloading,
1. extension of user defined types.

Opinions about object oriented programming as a paradigm differ widely.  There
are those that consider it the bread and butter of large scale software
development as well as  those who think it is pure evil spawned by the prince
of darkness to torture unsuspecting developers.

While it is true that a number of software projects have gone heavily overboard
when using object orientation, it is definitely true that it can make your code
much more transparent, especially when developing domain specific languages.

The running example we will be using to motivate object oriented programming
and introduce various concepts is descriptive statistics.  We start quite
simple with a user defined type to collect the relevant data to compute the
mean and standard deviation of some real numbers.

Consider data values $$x_i$$ for $$i \in [1, N$$, then the mean value $$\nu$$
is given by
$$
    \mu = \frac{1}{N} \sum_{i=1}^{N} x_i
$$
The standard deviation $$\sigma$$ is given by
$$
   \sigma = \sqrt{\frac{1}{N-1} \sum_{i=1}^{N} (x_i - \mu)^2}
$$

Using a little algebra, the formula for $$\mu$$ can be transformed into
$$
  \sigma = \sqrt{\frac{1}{N-1} \large\( \sum_{i=1}^N x_i^2 - \frac{1}{N} \large\( \sum_{i=1}{N} x_i \large\)^2 \large\)}
$$
Using this formulation of the standard deviation, it is clear that we do not
require the mean value to compute it, but rather simply
1. the sum of the values,
1. the sum of the square of the values,
1. and the number of values

Hence there is no reason to keep track of all the individual data values
$$x_i$$ and we can compute the descriptive statistics of arbitrarily many
values.

Throughout this text we will assume that the `descriptive_stats_t` user
defined type and all procedures that pertain to it are defined in a module
named `stats_mod`.


## Data encapsulation

The following user defined type can be used to keep track of these.

~~~~fortran
type :: descriptive_stats_t
    private
    integer :: nr_values = 0
    real :: sum = 0.0, sum2 = 0.0
end type descriptive_stats_t
~~~~

Since updating these three elements by hand would be very error prone, it is
better to define a procedure to add a new data value to the statistics.

The `private` statement ensures that the elements `nr_values`, `sum` and `sum2`
can only be accessed from within the same compilation unit, i.e., the module
`stats_mod` in our running example.  If we place the declaration in a module
`stats_mod` then only procedures defined in that module can read or modify the
elements of the user defined type.  This ensures data encapsulation, one of the
cornerstones of object oriented design.

~~~~fortran
subroutine add_value(stats, new_value)
    implicit none
    type(descriptive_stats_t), intent(inout) :: stats
    real, value :: new_value

    stats%nr_values = stats%nr_values + 1
    stats%sum = stats%sum + new_value
    stats%sum2 = stats%sum2 + new_value**2
end subroutine add_value
~~~~

Note that the statistics user defined type variable `stats` is the first
argument in the subroutine.

This approach, in combination with the `private` statement in the type
declaration ensures that the elements `n`, `sum` and `sum2` can only be
modified through the subroutine `add_value`, hence reducing the probability
of introducing bugs.

The statistics can be obtained through functions such as `get_mean`,
`get_stddev` and `get_nr_values`.

~~~~fortran
function get_mean(stats) result(mean_value)
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    type(descriptive_stats_t), intent(inout) :: stats
    real :: mean_value

    if (stats%nr_values == 0) then
        write (unit=error_unit, fmt='(A)') &
            'error: too few data value to compute mean'
        stop 1
    end if
    associate (n => stats%nr_values, sum => stats%sum)
        mean_value = sum/n
    end associate
end function get_mean
~~~~

The implementations of `get_nr_values` and `get_stddev` are of course similar.
Although this approach works quite nicely, it can be done more elegantly using
type bound procedures.


## Type bound procedures

It would be more natural to add a value to a variable of the user defined type
`descriptive_stats_t`, or query it to get the current mean value or standard
deviation.  This can be achieved using type bound procedures.

~~~~fortran
type, public :: descriptive_stats_t
    private
    integer :: nr_values = 0
    real :: sum = 0.0, sum2 = 0.0
contains
    procedure, public, pass :: add_value, get_nr_values, get_mean, get_stddev
end type descriptive_stats_t
~~~~

The procedures `add_value`, `get_nr_values`, `get_mean` and `get_stddev` are
now bound to the type `descriptive_stats_t`.  The procedures can be called
using a syntax similar to accessing the elements of a user defined type.

~~~~fortran
...
use :: stats_mod
...
type(descriptive_stats_t) :: stats
...
call stats%add_value(5.3)
call stats%add_value(3.5)
print '(F12.3)', stats%get_mean()
...
~~~~

The signature of the subroutine `add_value` has not changed, so the first
argument to be passed to it is still a variable of type `descriptive_stats_t`.
This is accomplished by adding the `pass` attribute to the declaration in the
type.  The same applies to the other procedures such as `get_mean`.

Note that unless a type bound procedure is declared public in the module, it is
no longer possible to call it as you normally would, i.e., the following line
of code would trigger a compilation error.

~~~~fortran
call add_value(stats, 7.3)
~~~~

If you replace the `pass` attribute by `nopass`, the variable is simply
ignored, and not passed as an argument to the procedure.  We will see
applications of this later.


## Generic type bound procedures

It would be convenient if the `descriptive_stats_t` user defined type would
have a procedure to add either a single value, or all elements of an array
containing values.  You already know that this can be achieved for ordinary
procedures using a named interface.  For type bound procedures it can be
accomplished even simpler.

The code fragment below shows the definition of the user defined type.

~~~~fortran
type, public :: descriptive_stats_t
    private
    integer :: nr_values = 0
    real :: sum = 0.0, sum2 = 0.0
contains
    procedure, public, pass :: get_nr_values, get_mean, get_stddev
    procedure, private, pass :: add_value, add_values
    generic :: add_data => add_value, add_values
end type descriptive_stats_t
~~~~

The subroutine `add_value` is now private rather than public, since it is not
supposed to be called directly.  A subroutine `add_values` has been added to
add an array of data to the statistics.  The generic `add_data` will be called
on variables of type `descriptive_stats_t`, and will be replaced by the
compiler either by `get_value` or `get_values` depending on the type of its
argument.

~~~~fortran
...
use :: stats_mod
...
type(descriptive_stats_t) :: stats
real, dimension(3) :: values = [ 3.5, 5.7, 7.3 ]
...
call stats%add_data(3.7)
call stats%add_data(values)
~~~~

In the context of other programming languages this is called method
overloading.
