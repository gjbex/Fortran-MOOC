# Pointers

Although pointers are typically associated with programming languages such as
C and C++, but you can in fact use pointers in Fortran as well.  However, there
are substantial conceptual differences between pointers in C/C++ and Fortran.

In C/C++ a pointer is simply an address of data in memory.  In Fortran, a
pointer isn't an address, but is rather associated with data that has been
designated as a target.  During its lifetime, a pointer can be associated
with any number of targets.


## Pointer basics

Condider the following mathematical relation between a vector $$A$$ at time
$t + 1$$ as a function of the values of $$A$$ at $$t$$:
$$
    A_{t+1, i} = \frac{1}{4}A_{t, i-1} + \frac{1}{2}A_{t, i} + \frac{1}{4}A_{t, i+1}
$$
Starting from some initial values for $$A$$ at $$t = 0$$, what is the values
of $$A$$ after `nr_steps` time steps?

The code fragment below implements this.

~~~~fortran
...
real, dimension(nr_vals) :: A, A_new
integer :: t, i
...
do t = 1, nr_steps
    do i = 2, size(A) - 1
        A_new(i) = 0.25*A(i - 1) + 0.5*A(i) + 0.25*A(i + 1)
    end do
    A = A_new
end do
...
~~~~

For each time step, the values of the array `A_new` have to be copied to the
array `A`.  It would be more efficient if you could swap the roles of `A` and
`A_new` at each time step.  This can be achieved easily using pointers.

~~~~fortran
...
real, dimension(nr_vals), target :: A, A_new
real, dimension(:), pointer :: pA, pA_new, tmp
integer :: t, i
...
pA => A
pA_new => A_new
do t = 1, nr_steps
    do i = 2, size(A) - 1
        pA_new(i) = 0.25*pA(i - 1) + 0.5*pA(i) + 0.25*pA(i + 1)
    end do
    tmp => A
    A => A_new
    A_new => tmp
end do
...
~~~~

The arrays `A` and `A_new` can have pointers associated to them since they
are declared with the `target` attribute.  The variables `pA` and `pA_new` have
the same type as `A` and `A_new`.  Note that they are deferred-shape and have
the `pointer` attribute.

Pointers can be associated with variables using the `=>` operator.  The left
hand side operator is the pointer, the right hand side operator the target.

In this code fragment, the pointer `pA` is originally associated with the array
`A`, but in the iteration statement it gets associated with the array `A_new
for each iteration where `t` is odd, and back to `A` for each iteration where
`t` is even.

The pointer variables can be used just like the targets they are pointing to,
so `pA(5)` refers to the fifth element of the array `A` when `pA` is associated
with `A`, and to the corresponding element in the array `A_new` when it is
associated with the latter.

The benefit of using pointers in this code fragment is that the data in array
`A_new` doesn't need to be copied into array `A` for each iteration, resulting
in better performance for large arrays.

Note that a pointer can be associated with a variable if and only if
* their types match, and
* the variable is a target.


## Pointer associations

A pointer variable is not necessarily associated with a target during its
entire life time.  It is for instance possible that  the data the pointer is
to be associated with has not been created yet.

You can test whether a pointer has been associated with target using the
intrinsic function `associated`.  It can be called with either a single or
with two arguments.  Consider the following code fragment.

~~~~fortran
...
integer, target :: a, b
integer, pointer :: p

nullify (p)
print *, associated(p)       ! prints F

p => a
print *, associated(p)       | prints T
print *, associated(p, a)    | prints T
print *, associated(p, b)    | prints F

p => b
print *, associated(p)       | prints T
print *, associated(p, a)    | prints F
print *, associated(p, b)    | prints T

p => null()
print *, associated(p)       ! prints F
...
~~~~

When `associated` is called with a single pointer argument, it will return
true when that pointer is associated with a target, false otherwise.  When
called with two arguments, the first a pointer, the second a potential target,
the intrinsic function returns true if the pointer is associated with that
specific target, false otherwise.

Note that the function `associated` can return either true or false when
called with an uninitialized pointer as an argument.  Hence it is good practice
to initilize a pointer by either associating it with `null()`, or using tye
`nullify` statement.  Both are illustrated in the code fragment above.  The
function `associated` will return false if the pointer is nullified.

In the example above you see that scalar values of types such as `integer` can
be targets for pointers.  However, there are few applications for this.
Arrays or variables of user defined types make much more interesting targets.
