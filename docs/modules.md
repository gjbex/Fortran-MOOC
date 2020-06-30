# Modules

## Motivation

Using modules helps you to organize your code.  A module can for instance
contain user defined data types, constants and procedures that belong together.
It is also possible to ensure that variables or procedures that should only
be used within the implementation of a module are private to that module, so
that they can not be altered or used inappropriately.

Modules can be used as the building blocks of libraries which is essential
for code reuse.

Modules can be stored in separate files, reducing files to more manageable
sizes.


## Anatomy of a module

A module typically consists of two parts, declarations and definitions,
separated by the keyword `contains`.  For modules that only declare user
defined types, variables or define constants, the second `contains` part that
holds procedure definitions can be omitted.

~~~~
module <module-name>
    <declarations>
contains
    <definitions>
end module <module-name>
~~~~

It is good practice to name modules with a suffix `_mod` to avoid confusion
with other entities.

Consider the following example of a (very simple) module to compute compute
descriptive statistics of a data set.

~~~~fortran
module stats_mod
    implicit none

    private

    public :: descriptive_stats_t, add_value, get_nr_values, get_mean, get_stddev

    type :: descriptive_stats_t
        private
        integer :: nr_values = 0
        real :: sum = 0.0, sum2 = 0.0
    end type descriptive_stats_t

contains
    ...
end module stats_mod
~~~~

The keyword `private` indicates that anything declared in this module can be
used only in the unit itself, unless otherwise specified by an overriding
`public` attribute.

This module defines a public type `descriptive_stats_t` with three private
elements `nr_values`, `sum` and `sum2`.  This implies that a compilation unit
that uses this module can use the type `descriptive_stats_t`, but the
element of the compilation unit's variables of this type can not be accessed.

However, although declared private, the elements can be accessed from within
the procedures defined in the module itself.

The module also declares four procedures `add_value`, `get_nr_values`,
`get_mean` and `get_stddev`.  These procedures are marked public so that
they can be called from compilation units that use this module.

The implementation of these procedures is defined in the second part of
the module.

~~~~fortran
module stats_mod
    ...
contains

    subroutine add_value(stats, new_value)
        implicit none
        type(descriptive_stats_t), intent(inout) :: stats
        real, value :: new_value

        stats%nr_values = stats%nr_values + 1
        stats%sum = stats%sum + new_value
        stats%sum2 = stats%sum2 + new_value**2
    end subroutine add_value

    function get_nr_values(stats) result(nr_values)
        implicit none
        type(descriptive_stats_t), intent(in) :: stats
        integer :: nr_values

        nr_values = stats%nr_values
    end function get_nr_values

    ...
end module stats_mod
~~~~

The type `descriptive_stats_t` can be used thanks to host association.  Note
that these procedures can use and modify the values of the `stats` variable
although they were declared private.

The advantage of this approach is that the state of the user defined type
variable will remain consistent since it can only be modified through the
`add_value` subroutine.

It is good practice to make everything private, and only declare those
entities public that should be accessible in compilation units that use
the module.


## Using modules


