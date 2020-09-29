# Random numbers

Fortran has intrinsic procedures for pseudo-random number generation.  You can
easily generate a sequence of pseudo-random floating point values form a uniform
distribution in the half-closed interval $$[0, 1[$$.  The start of the sequence
is determined by a seed, i.e., a state of the algorithm that changes each time a
random number is generated.
This change of state is deterministic, so starting from the same initial state
or seed will get you the exact same sequence of random numbers twice.  This is
the reason these numbers are referred to as "pseudo-random", rather than
"random", although we will use the latter term for brevity anyway.

Random numbers play an important role in many scientific domains and are in
fact at the core of some key algorithms such as Monte Carlo methods.


## Generating random numbers

The intrinsic subroutine `random_number` will give you a random number or array
of numbers each time it is called, e.g.,

~~~~fortran
...
real :: r
...
do i = 1, nr_vals
    call random_number(r)
    print '(F10.7)', r
end do
...
~~~~

Each time the subroutine `random_number` is called, it assigns a new real value
to `r` such that $$0 \e \textrm{r} < 1$$.

In the following code snippet, `coords` is an array of double precision
floating point values.

~~~~fortran
...
use, intrinsic :: iso_fortran_env, only : DP => REAL64
...
real, dimension(3) :: coords
...
call random_number(coords)
...
~~~~


## Random number generator state

The intrinsic subroutine `random_seed` serves several purposes, depending on
the optional arguments it is called with:

1. `size`: the number of integer values that determine the state of the random
   number generator; this is an argument with intent `out`.
1. `get`: the current state of the random number generator, it is an array with
   a size at least equal to the `size` of the state, this is an argument with
   intent `out` as well.
1. `put`: the new state of the random number generator, it is an array with
   a size at least equal to the `size` of the state, this is an argument with
   intent `in`.

The following code fragment determines the current state of the random number
generator.

~~~~fortran
...
integer :: seed_size, istat
integer, dimension(:), allocatable :: seed_vals, new_seed_vals
...
call random_seed(size=seed_size)
allocate (seed_vals(seed_size), new_seed_vals(seed_size), stat=istat)
...
call random_seed(get=seed_vals)
print '(A, *(I12))', 'seeds: ', seed_vals
...
~~~~

We start by checking the required size for the seed of the random number
generator by calling `random_seed` using the optional `size` argument.  Next,
we allocate an integer array of that size to store the values of the state
which we obtain by calling `random_seed` again with the `get` argument.

Note that the size of the state is implementation dependent, e.g., for GCC 10.x
the size is 8, while for Intel's ifort 18.x it is 2.  This is something to take
into account when relying on random numbers in Fortran.


## Why seed?

The Fortran runtime will seed the random number generator automatically for you
so that you get a different sequence of random numbers each time you call the
application.  Very often this is exactly what you want, but not always.

There are circumstances in which you want to make sure that each run of your
application produces exactly the same sequence of random numbers.  Imagine
debugging an application for which a bug is triggered or not, depending on a
random value: good luck to you!

Another use case for seeding the random number generator is in the context of
testing your application. To be reliable, tests often need to be
deterministic.  Sometimes you want to be able to exactly reproduce a previous
run of your application for performance tuning.

A more subtle use case arises in the context of parallel programming.  Since
the seeding of the random number generator by the Fortran runtime is a black
box, it may be based on the value of the system clock.  If that is the case,
and many processes start nearly simultaneously, two or more processes may
have the same seed.  In such a setting that is typically not what you want
since the random sequences of the processes should be independent.

Note: just to be very clear on this point, typically you seed the random number
generator once when your application starts.


## How to seed?

When you initialize an array of the appropriate size (obtained by a call to
`random_seed` with the `size` argument, you can use that to seed the random
number generator.

For debugging purposes you could seed the random number generator in a fairly
trivial way as follows.

~~~~fortran
...
integer :: seed_size, istat
integer, dimension(:), allocatable :: seed_vals
...
call random_seed(size=seed_size)
allocate (seed_vals(seed_size), stat=istat)
...
seed_vals = 42
...
~~~~

A better approach is to store the seed values in a file, and read them to
initialize the array of seed values.


## Best practice

Your application can be configured to use a file containing seed values when
given.  If not, it will write the seed values selected by the Fortran runtime to
a file with a timestamp in its name, so that it is unique.  This file can later
be used to reproduce the specific run of the application.

A little more care is required in the context of parallel applications, but the
same approach can be used.
