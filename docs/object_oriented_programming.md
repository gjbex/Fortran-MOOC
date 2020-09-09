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
can only be accessed from within the same compilation unit.  If we place the
declaration in a module `stats_mod` then only procedures defined in that
module can read or modify the elements of the user defined type.  This ensures
data encapsulation, one of the cornerstones of object oriented design.

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
