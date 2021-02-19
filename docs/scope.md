# Scope in Fortran

The scope of a name binding, e.g., a variable or procedure, is the part of the
source code where that name binding can be used.  In Fortran, declarations of
variables, types, interfaces and so on have to be done at the start of a
compilation unit, and their scope is the compilation unit they are declared in.

A variable, type or interface can be used from the point where it is declared
in the compilation unit.  For instance, the variable `i` in the code fragment
below needs to be declared before it is used in the implicit do loop on the
line below.

~~~~fortran
integer :: i
integer, dimension(5) :: v = [ (i, i=1, 5) ]
~~~~

If a compilation unit is part of another compilation unit, e.g., a procedure
defined in the program unit, the scope of name bindings extends to the entire
program unit, so also to the compilation units that it contains.

A binding to a name in a compilation will shadow a binding to the same name in
the enclosing compilation unit.  For example, the variable `i` in the function
unit will shadow the variable `i` in the program unit.

~~~~fortran
program main
    ...
    integer :: i
    ...
    i = 5
    print *, f(10)
    ...
contains

    integer function f(val)
        ...
        integer :: i
        ...
        i = 7
        f = i*val
    end function f

end program main
~~~~

The variable `i` in the function `f` refers to a different memory location
than the one in the program unit.  Hence the assignment to `i` in the function
does not affect the value of the variable in the program unit, which will still
be 5 after the call of function `f`.

However, if `i` were not declared in the compilation unit function `f`, the
value of the variable `i` *would* be changed in the program unit.  This is of
course a potential source of bugs, so it is quite important that all variables
intended to be local to a compilation unit are declared in that unit.

Procedures that are defined in a compilation unit can be used in that entire
unit.  


## Modules

A module is a compilation unit, so all variables, types, interfaces and
procedures are defined in the scope of that unit.  However, they can be
imported into the scope of another compilation unit using a `use` statement,
provided they are declared public.

It is good practice to import only those entities into the scope of a
compilation unit that are required, so as not to pollute the name space
inadvertently.


## Block statement

The Fortran 2008 specification introduced the block statement.  This
allows to limit the scope of variables to the block in which they are defined.

The program below would not compile since the variable `i` is declared in the
block, but used outside of it.  The variable's scope will not exceed the block
and hence is not declared in the program unit as a whole.

~~~~fortran
program block_scope
    implicit none

    block
        integer :: i = 5
        print *, i
    end block
    print *, i
end program block_scope
~~~~

In general, it is good practice to limit the scope of entities as much as
possible, so the introduction of block statements is a welcome addition to the
Fortran specification.
