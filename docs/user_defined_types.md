# User defined types

Representing data is key to software design.  You've already
encountered Fortran basic types to represent numbers, logical values
and strings, as well as (multi-dimensional) arrays of such data.

However, some data items that belong together do not fit into an array since they have
different types.  For instance, consider configuration settings for an imaginary
application that can be configured using the name of an integration method, represented
as a string, a precision represented as a real value and a number of iterations,
represented as an integer.

It would of course be possible to define three independent variables to store these
values, but it makes more sense to aggregate this data into a special purpose data
structure.  For this purpose, Fortran offers user defined types.  These are very
similar to `struct` is C/C++ or named tuples in Python.


## Type definition

The definition of a new type `config_t` is given below.

~~~~fortran
    type :: config_t
        character(len=1024) :: method
        integer :: nr_iters
        real(kind=DP) :: precision
    end type config_t
~~~~

The type `config_t` has three element, named `method`, `nr_iters` and `precision`.
Note that the elements have distinct types, e.g., `nr_iters` is an integer, while
`method` is a string.

It is good practice to append the `_t` suffix to make it very clear that this is the
name of a type.


## Variable declaration and use

`config_t` is a type, so you can declare variables of this type, e.g.,

~~~~fortran
type(config_t) :: config
~~~~

The variable `config` has type `config_t`.  You can assign values to the various
arguments as shown below.  The string `'none'` is assigned to the `method` element,
the integer 0 to the `nr_iters` element, and so on.

~~~~fortran
config%method = 'none'
config%nr_iters = 0
config%precision = 1.0e-10_DP
~~~~

Note that Fortran uses `%` to access members of a user defined type.

The initialization of a user defined hype variable can be done in a single
statement, e.g.,

~~~~fortran
config = config_t(method='none', nr_iters=0, precision=1.0e-10_DP)
~~~~

Elements of user defined type variables can be used like any other variable in
expressions, or as arguments in procedure calls, e.g.,

~~~~
if (abs(value) < config%precision) then
    ...
end if
~~~~


## Procedure arguments and function return types

User defined type variables can be passed to procedures as arguments, as well as
returned by functions.  Consider the following user defined type that represents a
particle.

~~~~fortran
type :: particle_t
    real(kind=DP) :: x, y, z, mass
    integer :: charge
end type particle_t
~~~~

The following function takes two arguments of type `particle_t` as argument, and
computes the Euclidean distance between them.

~~~~fortran
function distance(p1, p2) result(dist)
    implicit none
    type(particle_t), intent(in) :: p1, p2
    real(kind=DP) :: dist
    
    dist = sqrt((p1%x - p2%x)**2 + (p1%y - p2%y)**2 + (p1%z - p2%z)**2)
end function distance
~~~~

The return type of a function can also be a user defined type.  You will see an
example in the next section.


## Building types

Combining basic types, arrays and user defined types you can build (almost) any data
structure you may need.

### Arrays of user defined types

It is straightforward to create arrays that have user defined type elements.  By way
of example, suppose you would like to compute the center of mass of a system of
particles represented as `particle_t`.  The particles would be stored in an array and
passed to a function that returns the coordinates of the center of mass.


The following type represents Cartesian coordinates in a three-dimensional space.

~~~~fortran
type :: coordinates_t
    real(kind=DP) :: x, y, z
end type coordinates_t
~~~~

The function computing the center of mass is listed below.  As argument, it receives
a one-dimensional array of `particle_t` elements.

~~~~fortran
function compute_center_of_mass(particles) result(coordinates)
    implicit none
    type(particle_t), dimension(:), intent(in) :: particles
    type(coordinates_t) :: coordinates
    real(kind=DP) :: total_mass
    integer :: i

    coordinates%x = 0.0_DP
    coordinates%y = 0.0_DP
    coordinates%z = 0.0_DP
    total_mass = 0.0_DP
    do i = 1, size(particles)
        associate(particle => particles(i))
            coordinates%x = coordinates%x + particle%mass*particle%x
            coordinates%y = coordinates%y + particle%mass*particle%y
            coordinates%z = coordinates%z + particle%mass*particle%z
            total_mass = total_mass + particle%mass
        end associate
    end do
    coordinates%x = coordinates%x/total_mass
    coordinates%y = coordinates%y/total_mass
    coordinates%z = coordinates%z/total_mass
end function compute_center_of_mass
~~~~

In order to simplify the code a little bit, the associate statement has been used.
This statement lets you associate a name with a variable, array element or subarray.
In this example, the name `particle` is used instead of the array element `particles(i)`
since this makes the code somewhat easier to read.


### Arrays as elements of user defined types

Note that elements of user defined types are not restricted to basic types, they can
be arrays or event user defined types.  For instance, you could represent the particle's
coordinates as an array.

~~~~fortran
type :: particle_t
    real(kind=DP), dimension(3) :: coords
    real(kind=DP) :: mass
    integer :: charge
end type particle_t
~~~~

The `coords` element is an array of three real numbers, representing the coordinates.
The following function takes two particles of this data type and computes the
Cartesian distance between them.

~~~~fortran
function distance(p1, p2) result(dist)
    implicit none
    type(particle_t), intent(in) :: p1, p2
    real(kind=DP) :: dist
    integer :: i

    dist = 0.0_DP
    do i = 1, size(p1%coords)
        dist = dist + (p1%coords(i) - p2%coords(i))**2
    end do 
    dist = sqrt(dist)
end function distance
~~~~


### Nested user defined types

The elements of user defined types can themselves have a user defined type.  The
following definition illustrates this.

~~~~fortran
type :: coordinates_t
    real(kind=DP) :: x, y, z
end type coordinates_t

type :: particle_t
    type(coordinates_t) :: coords
    real(kind=DP) :: mass
    integer :: charge
end type particle_t
~~~~

The type of the `coords` element is a user defined type with three elements, `x`, `y`
and `z` that represent the coordinates.  The following function that computes the
distance between two particles illustrates its use.

~~~~fortran
function distance(p1, p2) result(dist)
    implicit none
    type(particle_t), intent(in) :: p1, p2
    real(kind=DP) :: dist
    integer :: i

    associate(c1 => p1%coords, c2 => p2%coords)
        dist = sqrt((c1%x - c2%x)**2 + (c1%y - c2%y)**2 + (c1%z - c2%z)**2)
    end associate
end function distance
~~~~


## Sequence

For performance reasons, the Fortran compiler can arrange the elements in a user
defined type so that there are gaps between them.  Mostly, that is what you want, but
when it is not, you can add the `sequence` keyword to the type definition, e.g.,

~~~~fortran
type :: particle_t
    sequence
    real(kind=DP) :: x, y, z, mass
    integer :: charge
end type particle_t
~~~~

Note that you should really only use this when you know what you are doing since
adding `sequence` may have a performance impact.
