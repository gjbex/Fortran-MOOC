# Interoperability

Although Fortran is a very nice language for scientific computing, its ecosystem
of third-party libraries is not as extensive as one may wish.  Hence it is
important that Fortran applications can use libraries developed in other
programming languages.

The reverse is also important, i.e., that Fortran libraries can be used from
applications written in other programming languages.


## C interoperability

The Fortran 2003 specification adds explicit C interoperability, the 2018
specification improved on the initial version.  This allows to define interfaces
to call C functions from Fortran code.  the `iso_c_bnding` module defines
conversion functions and data kinds to facilitate interoperability, while the
`bind` keyword allows to specify that a function is intended for interoperability.

Although the reverse is possible, i.e., Fortran procedures can be called from
C code, there are unfortunately quite some limitations, especially with respect
to assumed shape array arguments.


### Simple example

As a very simple example, consider the following C function

~~~~C
double linear(double x, double a, double b) {
    return a*x + b;
}
~~~~

Some work is required to use this function from a Fortran program.  First, you
have to define an interface.

~~~~fortran
use, intrinsic :: iso_c_binding
...
interface
    function linear(x, a, b) result(res) bind(c)
        use, intrinsic :: iso_c_binding
        implicit none
        real(kind=c_double), value :: x, a, b
        real(kind=c_double) :: res
    end function linear
end interface
~~~~

Note the `bind` keyword used to declare that this is an interface to a C function.
The kind of the function's arguments and return value are `c_double`, which
corresponds to C's double precision floating point type.  The arguments are passed
by value, as is the case in the C function.

The function must be called using arguments of kind `c_double`, e.g.,

~~~~fortran
real(kind=c_double) :: x, a, b
...
x = real(3.0, kind=c_double)
a = real(0.5, kind=c_double)
b = real(1.3, kind=c_double)
print '(F7.2)', linear(x, a, b)
~~~~


### Pointers

A somewhat more challenging example is the following C function.

~~~~c
#include <err.h>
#include <stdio.h>
#include <stdlib.h>

int* random_vector(int n) {
    int *vector = (int *) malloc(n*sizeof(int));
    if (!vector) {
        errx(1, "error: can not allocate vector of size %d\n", n);
    }
    for (int i = 0; i < n; ++i) {
        vector[i] = rand();
        printf("C: %d\n", vector[i]);
    }
    return vector;
}
~~~~

The C function returns the address of an array that stores `n` integer values.

To use this function from Fortran, you have to define an interface.

~~~~fortran
interface
    function random_vector(nr_values) result(vector) bind(c)
        use, intrinsic :: iso_c_binding
        implicit none
        integer(kind=c_int), value :: nr_values
        type(c_ptr) :: vector
    end function random_vector
end interface
~~~~

The type of the argument has kind `c_int`, while the return type has `c_ptr`.

The result of the function can be assigned to a variable, and converted to a
corresponding Fortran pointer.

~~~~fortran
integer, parameter :: vector_len = 5
integer(kind=c_int), dimension(:), pointer :: random_values
type(c_ptr) :: vector_ptr
...
vector_ptr = random_vector(vector_len)
call c_f_pointer(vector_ptr, random_values, shape=[vector_len])
do i = 1, vector_len
    print '(A, I0)', 'Fortran: ', random_values(i)
end do
deallocate(random_values)
~~~~

Note that the memory is allocated in the C function using `malloc`, but
deallocated in the Fortran program unit with a `deallocate` statement.Go


### Real world example

As a real world example,we will call a function defined in the Gnu Scientific
Library (GSL), an extensive collection of mathematical data structures and
algorithms.

The following program uses the `gsl_sort` function to sort an array.  The
C function has return type `void`, so the interface defines a subroutine.

~~~~fortran
program use_gsl
    use, intrinsic :: iso_c_binding
    implicit none
    interface
        subroutine gsl_sort(data, stride, n) bind(c)
            use, intrinsic :: iso_c_binding
            implicit none
            real(c_double), dimension(n) :: data
            integer(kind=c_size_t), value :: stride, n
        end subroutine gsl_sort
    end interface
    integer(kind=c_size_t), parameter :: nr_values = 10, stride = 1
    real(kind=c_double), dimension(nr_values) :: values

    call random_number(values)
    print '("original:")'
    print '(*(F25.15, /))', values
    call gsl_sort(values, stride, nr_values)
    print '("sorted:")'
    print '(*(F25.15, /))', values
end program use_gsl
~~~~


## Python

Fortran procedures can be called from Python thanks to the f2py, a utility
that is distributed with the numpy package.

Consider the following Fortran module defined in the file `matrix_mod.f90`.

~~~~fortran
module matrix_mod
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none

    private
        public :: norm_matrix_rows

contains

    subroutine norm_matrix_rows(matrix)
        implicit none
        integer, parameter :: DP = selected_real_kind(15, 307)
        real(kind=DP), dimension(:, :), intent(inout) :: matrix
        ...
    end subroutine norm_matrix_rows
end module matrix_mod
~~~~

The subroutine defined in this module will modify an assumed shape 2D array
passed as argument.

Python wrappers for this Fortran module can be created using the f2py
utility.

~~~~bash
$ f2py  -c  -m matrices  matrix_mod.f90
~~~~

This will create a Python module `matrices` that contains `matrix_mod`
with the function `norm_matrix_rows`.

~~~~python
from matrices import matrix_mod
...
A = np.asfortranarray(np.arange(1.0, 12.5, 1.0).resize((3, 4)))
matrix_mod.norm_matrix_rows(A)
~~~~

As you would expect, Python arrays can be passed as arguments to Fortran
functions flawlessly.
