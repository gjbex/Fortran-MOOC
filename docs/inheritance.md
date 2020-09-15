# Inheritance

A very important aspect of object oriented programming is inheritance, i.e.,
creating classes that extend or specializing aspects of an existing class.

Suppose you would like to add functionality to the `descriptive_stats_t` user
defined type.  You can already compute the mean value and the standard
deviation, but now you are also interested in the median of the data set.

To compute the median, you first have to sort your data values, and the
median is
* the middle value if the number of data values is odd, and
* the average of the two middle values when the number of data values is even.

This means that you can only compute the median if you keep track of all the
values.  However, a nice feature of the `descriptive_stats_t` implementation
was that you could compute the mean and the standard deviation without that
requirement.  Since there will still be situation where you can't or won't
compute the median, adding that functionality directly to `descriptive_stats_t`
would be very limiting and make the class less useful.  Hence it seems a
creating a new class, say `median_stats_t` is the best option.

Of course you could simply copy the procedures `get_nr_values`, `get_mean`
and `get_stddev` from `descriptive_stats_t` into `median_stats_t` and be done
with it.  However, that would not be ideal.  Suppose you find a bug in the
implementation of `get_stddev`, you would have to fix the same code in two
places, both for `descriptive_stats_t` and `median_stats_t`.  This is quite
error prone since it is likely that you will forget to fix one of the versions
and be faced with some interesting bugs.

Since an object of class `median_stats_t` should be able to compute the mean
and standard deviation, and the procedures to accomplish that are identical to
those in `descriptive_stats_t`, it would be very convenient if the latter could
be used as the basis for `median_stats_t` which would extend it with data and
procedures to compute the median as well.

This is exactly what inheritance accomplishes.  Consider the definition of
`median_stats_t` below.

~~~~fortran
type, extends(descriptive_stats_t), public :: median_stats_t
    private
    real, dimension(:), allocatable :: values
contains
    procedure, public, pass :: add_value, get_median
    final :: finalize_stats
end type median_stats_t
interface median_stats_t
    module procedure init_stats
end interface
~~~~

The attribute `extends` ensures that the user defined type `median_stats_t`
will have all the elements and type bound procedures that `descriptive_stats_t`
has.  So `median_stats_t` will have the elements `nr_values`, `sum` and `sum2`
as well as the type bound procedures `get_nr_values`, `get_mean` and
`get_stddev`, although they are not mentioned explicitly.

The user defined type `median_stats_t` has an additional element `values` to
store all data values added with the `add_value` method.  Hence it should have
its own implementation of the `add_value` method.  It also has two additional
type bound procedures `get_median` and `finalize_stats`.

the procedures `init_stats` and `finalize_stats` will be discussed in a later
section.

In object oriented parlance, `descriptive_stats_t` is called the *base class*
or the *parent class*, while `median_stats_t` is called a *derived class* or
*child class* of `descriptive_stats_t`.  In this case we have only a single base
class and a single derived class, but there may be situation in which the
derived class is used as the base class for another class, creating a
multi-level hierarchy.  If so, the terms *ancestor class* and *descendant class*
are used to refer to classes higher and lower in the derivation hierarchy.

As opposed to C++ or Python, Fortran supports single inheritance only, so a
class can have one parent class, not multiple.  This implies that the
derivation relationship between classes can be represented as a tree.  This
design decision sidesteps a number of issues associated with multiple
inheritance.

Although this may seem like a limitation, it is easy to overcome by using,
e.g., the facade design pattern.  It would lead us too far to go into the
details, but you can read the article
*[Emulating multiple inheritance in Fortran 2003/2008](https://doi.org/10.1155/2015/126069)*
by Karla Morris if you are interested.


## Overriding procedures

The `add_value` procedure bound to `median_stats_t` should do more that the one
bound to `descriptive_stats_t`.  However, it can rely on the implementation for
`descriptive_stats_t` to update `nr_values`, `sum` and `sum2`.  It should additionally
ensure that the new value is also stored in the array `values`.

~~~~fortran
subroutine add_value(stats, new_value)
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    class(median_stats_t), intent(inout) :: stats
    real, value :: new_value

    if (stats%get_nr_values() + 1 > size(stats%values)) then
        write (unit=error_unit, fmt='(A, I0, A)') &
            'error: capacity exceeded, maximum ', size(stats%values), &
            ' can be processed'
        stop 4
    end if
    call stats%descriptive_stats_t%add_value(new_value)
    stats%values(stats%get_nr_values()) = new_value
end subroutine add_value
~~~~

Since the array `values` has some size, this implementation of the procedure
`add_value` will first check whether the new value can still be stored.  If so,
the values of `nr_values`, `sum` and `sum2` should be updated, but this can
conveniently be done by calling the procedure `add_value` defined in
`descriptive_stats_t`.  You can call procedures defined in an ancestor class by
using its name as a prefix, i.e., `stats%descriptive_stats_t%add_value` in this
case.  Lastly, the procedure will add the new value to the array `values` at
index `nr_values` which refers to the next empty element in `values` since it
was incremented by the call to `descriptive_stats_t`'s `add_value`.


The procedure `get_median` is specific to the `median_stats_t` class, so this
is not inherited from the parent class.  The implementation relies on a sorting
algorithm to sort `values`; you can find it in the repository.


## `class` versus `type`

Now is a better time to explain why `class` is used rather than `type` to
declare the type of arguments to type bound procedures.  When a variable or
procedure argument is declared using `class` it can hold a value that is an
object of that class, or of any of that class' descendant classes.

This implies that for type bound procedures a procedure that is defined in
the parent class can be used in a derived class.

The use of `class` declarations is not restricted to procedure arguments
though.  The following code fragment illustrates that you can decide at runtime
whether to use a `descriptive_stats_t` or `median_stats_t` variable, and how to
distinguish between the types of values.

~~~~fortran
...
class(descriptive_stats_t), allocatable :: stats
...
if (stats_type == 'median') then
    allocate (stats, source=median_stats_t(nr_values))
else
    allocate (stats, source=descriptive_stats_t())
end if
~~~~

Since the variable `stats` is declared as `class(descriptive_stats_t)`, it can
store a object of type `descriptive_stats_t`, or any of that class' descendant
classes, i.e., `median_stats_t` in this case.

Although not strictly required, a named interface `descriptive_stats_t` was
added to create an initializer for `descriptive_stats_t`.  The `source`
argument of the `allocate` statement is used to clone the constructed object.

This is an instance of *runtime polymorphism*, i.e., the type of a variable is
determined at runtime.  The most convenient way to exploit runtime polymorphism
is through allocatable variables as you saw in the code sample above.


## Selecting types and classes

Since the variable `stats` can be either a `descriptive_stats_t` or a
`median_stats_t` object, and the method `get_median` can only be called on
objects of the class `median_stats_t`, you would need a way to determine at
runtime what the class or type of an object is.

Fortran has the `select type` statement to accomplish this.  Its general
form is

~~~~
select type (<target>)
    type is (<type name 1>)
        <block statements 1>
    type is (<type name 2>)
        <block statements 2>
    ...
    class default
        <block statements 3>
end select
~~~~

You can replace the type-guard `type is` by `class is` if you want to check not
only for the type itself, but also for all its descendants.  The `class default` 
type guard is optional.  As you can guess, there can only be a single
`case default` type guard, but you can have any number of `type is` and
`class is` guard clauses.  However, only a single block of code is executed,
even if multiple select clauses match.
1. If there is a `type` clause that matches, the corresponding block of
   statements is executed.
1. If that is not the case, but one or more `class` clauses match, the one for
   the type that is the highest up in the derivation hierarchy.
1. If no `class` clauses match, and a `class default` clause is present, the
   corresponding statement block is executed.

For example, now you can check whether `stats` is of class `median_stats_t`,
and if so, print the median.

~~~~fortran
...
print '(A, F10.3)', 'mean   = ', stats%get_mean()
select type (stats)
    class is (median_stats_t)
        print '(A, F10.3)', 'median   = ', stats%get_median()
end select
print '(A, F10.3)', 'stddev = ', stats%get_stddev()
...
~~~~

Here we use `class is` because all descendants of the `median_stats_t` class
should also either inherit or override the `get_median` function ([Liskov's
substitution principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle)).

The `select type` statement has an additional features that is worth
mentioning:  The `select type` statement can associate an alias, similar to the
`associate` statement.


# Interlude: initialization and finalization

In the previous section we have been using the array `values` to store data
values and compute the median.  That array was declared `allocatable`, but
where and when should it be allocated?  This is where the procedures
`init_stats` and `finalize_stats` come in that we didn't discuss so far.

When we create a new object of the the class `median_stats_t`, the array
`values` should be allocated.  This is done using the function `init_stats`
that returns an initialized instance of `median_stats_t`.

~~~~fortran
function init_stats(nr_values) result(stats)
    use, intrinsic :: iso_fortran_env, only : error_unit
    integer, value :: nr_values
    type(median_stats_t) :: stats

    allocate(stats%values(nr_values))
    if (.not. allocated(stats%values)) then
        write (unit=error_unit, fmt='(A, I0, A)') &
            'error: can not allocated memory for ', nr_values, ' values'
        stop 3
    end if
end function init_stats
~~~~

Since `nr_values`, `sum` and `sum2` are already initialized in the definition of
the parent class `descriptive_stats_t`.

The named interface `median_stats_t` ensures that the procedure `init_stats`
can be used conveniently, e.g.,

~~~~fortran
...
integer :: nr_values
type(median_stats_t) :: stats
...
stats = median_stats_t(nr_values)
...
~~~~

Here, the variable `nr_values` is (at least) the size of the data set.

To avoid memory leaks, it is of course good practice to complement `init_stats`
with a procedure to deallocate the array when the object is no longer required.
The deallocation is implemented in the `finalize_stats` procedure which is
called automatically when the object goes out of scope thanks to the `final`
attribute.

~~~~fortran
subroutine finalize_stats(stats)
    use, intrinsic :: iso_fortran_env, only : error_unit
    type(median_stats_t), intent(inout) :: stats
    integer :: istat

    deallocate(stats%values, stat=istat)
end subroutine finalize_stats
~~~~

Note that you could compare the procedure `init_stats` to a *constructor* in C++
or the `__init__` method in Python, while `finalize_stats` is similar to a C++
*destructor*.

As such, initializing/constructing and destructing objects is completely
independent of inheritance.  It was introduced in this section because it ties
in well with the running example and our base class didn't require either.
