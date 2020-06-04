# Arrays

In scientific programming arrays play a very important role.  You will use them to
represent vectors (1-dimensional arrays), matrices (2-dimensional arrays), and so on.

An array is a collection of values that can be selected using an index.  For example,
consider the following array declaration in Fortran.

~~~~fortran
integer, dimension(5) :: A
~~~~

Here, the name of the array is `A`, it has 5 elements, as specified by `dimension`,
and each of its elements is an integer, type `integer`.  The first element of the
array is `A(1)`, the second `A(2)`, the last `A(5)`.  So in more abstract terms, you
can view an array as an ordered sequence of objects, all with the same type.

By default, array indices start from 1 and go up to the size of the array.  This is
similar to other programming languages such as MATLAB, R and Julia, but different
from languages such as C, C++ and Python.

Short aside: note the common factor in Fortran, MATLAB, R and Julia, all these
programming languages were specifically designed for scientific computing and doing
mathematics.  C, C++ and Python are positioned as general purpose languages, not
specific to any domain.


## Accessing array elements

The following Fortran program shows how to work with individual array elements.

~~~~fortran
program array_elements
    implicit none
    integer, dimension(5) :: A
    integer :: i

    A(1) = 1
    do i = 2, size(A)
        A(i)  = 2*A(i - 1)
    end do
    print *, A
end program array_elements
~~~~

The `size` intrinsic function returns the number of elements of an array.  Here it is
used as the final index of the array `A`.


## Array initialization

In the last example of the previous section, the array was initialized element-wise.
Although this is fairly common, you can use a few more convenient approaches.

The following program illustrates three options.

~~~~fortran
program array_initialization
    implicit none
    integer :: i
    integer, dimension(5) :: A, B, C

    A = 13
    B = [ 2, 3, 5, 7, 11 ] 
    C = [ (2**i, i=0,4) ] 
    print *, A
    print *, B
    print *, C
end program array_initialization
~~~~

This program generates the following output.

~~~~
         13          13          13          13          13
          2           3           5           7          11
          1           2           4           8          16
~~~~

For the array `A`, the value 13 is assigned to each element.  For array `B`, the
values for the respective elements are listed explicitly.  The initialization
method is obviously only useful for short arrays. The array `C` is initialized using
an implicit do loop over the variable `i`.


## Array arithmetic

Arrays are first-class citizens in Fortran, so you can perform arithmetic directly
on arrays.  The following program illustrates this.

~~~~fortran
program array_arithmetic
    implicit none
    real, dimension(5) :: A = [ 1.2, 2.3, 3.4, 4.5, 5.6 ], &
                          B = [ -1.0, -0.5, 0.0, 0.5, 1.0], &
                          C

    C = A + 2.0*B
    print *, C
end program array_arithmetic
~~~~

The unary operator `-` can be applied to an array, and will change the sign of all the
elements of the array, i.e., `A_new(i) = -A(i)`.  Here `A_new` represents the
resulting array.

The binary operators `+`, `-`, `*`, `/` and `**` can be used
with a scalar operand and the semantics `A_new(i) = scalar <op> A(i)` or
`A_new(i) = A(i) <op> scalar`.  Here, `<op>` represents the binary operator and scalar
is a value that can be converted to the type of the array's elements.

The binary operators can also have an array as both their left and right operands.  The
semantics is `C_new(i) = A(i) <op> B(i)`, where `A` and `B` are the original arrays,
and `C_new` represents the new one.


## Subarrays

Fortran lets you select a subarray out of an array.  This is quite similar to list
or string slicing in Python.  The following program illustrates subarrays.

~~~~fortran
program subarrays
    implicit none
    integer :: i
    integer, dimension(10) :: A = [ (i, i = 1, 10) ]
    character(len=10), parameter :: FMT = '(10I3)'

    print FMT, A
    print FMT, A(4:7)
    print FMT, A(:7)
    print FMT, A(4:)
    print FMT, A(4:7:2)
    print FMT, A(4::2)
    print FMT, A(:7:2)
    print FMT, A(7:4:-1)
end program subarrays
~~~~

The output of this program is given below.

~~~~
 1  2  3  4  5  6  7  8  9 10
 4  5  6  7
 1  2  3  4  5  6  7
 4  5  6  7  8  9 10
 4  6
 4  6  8 10
 1  3  5  7
 7  6  5  4
~~~~

The most general form of subarray section is `<start>:<end>:<delta>`, where `<start>`
is the first index, `<end>` is the last index (inclusive), and `<delta>` is the
increment.

  * If `<delta>` is positive, the array indices are computed as
    `<start> + i*<delta>` for values of `i` starting from 0 and up to a value
   `i_max` such that `<start> + i_max*<delta>` is less than `<end>`.  Note that
   `<start>` is less than or equal to `<end>`.
  * If `<delta>` is negative, the array indices are similarly, but the last value
    will be `<start> + i_max*<delta>` such that it is larger than or equal to
    `<end>`.  Note that in that case `<start>` larger than or equal to `<end>`.

If `<delta>` is omitted, it defaults to 1.

As you can see `<start>` and/or `<end>` can be left out.  If `<start>` is left out,
it defaults to the first index, if `<end>` is left out, it defaults to the last
index.

Note: using strided subarrays, i.e., `<delta>` not equal to 1, can result in
performance issues.


## Multidimensional arrays

Up to this point, you have only see examples of one dimensional arrays, or arrays
with rank 1.  Fortran supports multidimensional arrays with ranks up to 15 (as of
Fortran 2008).

In the program below, a two dimensional array is initialized, printed, and the sum
of the squares of the elements is computed using explicit do loops.

~~~~fortran
program matrix
    implicit none
    integer, parameter :: ROWS = 3, COLS = 5
    real, dimension(ROWS, COLS) :: A
    integer :: i, j
    real :: total

    A = reshape([ (((i - 1)*size(A, 2) + j, j=1,size(A, 2)), i=1,size(A, 1)) ], &
                shape(A))
    do i = 1, size(A, 1)
        print *, A(i, :)
    end do
    total = 0.0
    do j = 1, size(A, 2)
        do i = 1, size(A, 1)
            total = total + A(i, j)**2
        end do
    end do
    print '(/, A, F10.2)', 'total = ', total
end program matrix
~~~~

The output of the program is shown below.

~~~~
   1.00000000       4.00000000       7.00000000       10.0000000       13.0000000    
   2.00000000       5.00000000       8.00000000       11.0000000       14.0000000    
   3.00000000       6.00000000       9.00000000       12.0000000       15.0000000    

total =    1240.00
~~~~

The first index of array `A` refers to the row, the second to the column, e.g.,
`A(2, 3)` would be the element on the second row, third column.

Note that in the nested do loops, the outer loop ranges over the column index, while
the inner loop ranges over the row index.  The reason is that two dimensional arrays
in Fortran are stored column-wise.  In general, the inner loop should range over the
rank of which the index changes the fastest, so that is the row index for rank 2
arrays.

The shape of an array is the size in each dimension, so for the matrix `A`, the shape
would be `3, 5`.

Just as for one dimensional arrays, you can select subarrays from multidimensional
arrays as well.  Suppose that `A` is a $$ 5 \times 5$$ matrix, then the the
expression `A(2:3, 2:4)` will create a $$2 \times 3$$ subarray with the values
`A(2, 2)`, `A(2, 3)`, `A(2, 4)` in its first row, and `A(3, 2)`, `A(3, 3)` and
`A(3, 4)` in its second row.

You can select an entire row or column from a two dimensional array as well.  For
example, `A(2, :)` is a subarray that consists of the elements of `A`'s second row.
Similarly, `A(:, 3)` has the elements of the third column of `A`.  Note that both
`A(2, :)` and `A(:, 3)` have rank 1 and size 5.



## Intrinsic procedures

Fortran has many intrinsic procedures for arrays.  You already saw a few of them in
action.


### Size and shape

The `size` intrinsic function returns the number of elements of an array.  It has the
dimension as an optional argument for use with multidimensional arrays, e.g.,
`size(A, 1)` will return the number of rows of the array, `size(A, 2)` the number of
columns.

The `shape` intrinsic function returns a one dimensional array with the dimensions
for the array.  So for a $$3 \times 5$$ array, the `shape` function return the array
`[3, 5]`.

The `rank` intrinsic function returns the rank of an array, i.e., its number of
dimensions.

The `reshape` intrinsic function takes two arguments.  The first argument is an array
of any shape, the second is a one dimensional array that specifies a new shape.
In the example code in the previous section, a one dimensional array of size 15
(constructed using implicit do loops) is reshaped into a two dimensional
$$3 \times 5$$

array.  Note that the size of the array should be equal to the product of the
new dimensions.  For example, you can reshape a $$4 \times 5$$ array into a
$$2 \times 10$$ array, or into a one dimensional array with 20 elements.  It can even
be reshaped into a three dimensional $$ 2 \times 2 \times 4$$ array.


### Mathematical functions

Most mathematical function such as the trigonometric functions and their inverse, the
exponential and logarithmic functions and the square root can be applied to an array of
any rank to produce a new array of the same rank with elements that are the result of
applying the function to the corresponding element in the original array.  So
`A_new(i) = <func>(A(i))`.  Such procedure are called elemental and you'll see in one
of the next section how to create your own.

The scalar product of two vectors (i.e, one dimensional arrays) can be computed using
the intrinsic function `dot_product`.  The vector-matrix, matrix-vector or
matrix-matrix product can be computed using the intrinsic function `matmul`.  As you
would expect, the dimensions must match, so for `matmul(A, B)`, `size(A, 2)` must be
equal to `size(B, 1)`.

The `sum` and `product` intrinsic functions compute the sum and product of the elements
of an array respectively.


### Finding and counting

The intrinsic functions `maxval` will return the maximum value of an array.
The corresponding intrinsic function `maxloc` returns the index or indices of the
element with the highest value in the array.  When applied to a multidimensional
array, this function will return a one dimensional array with the same size as the
rank of the argument.  If there are multiple elements with the same maximum value, the
index or indices of the first such element is returned.

Obviously, the intrinsic functions `minval` and `minloc` are similar to `maxval` and
`maxloc`.


### Masks and dimension

Intrinsic unctions similar to `sum` and `maxval` accept two optional arguments
`dim` and `mask`.

If `dim` is specified, the result returned by the function is an array with a rank one
less than that of the argument.  So for a two dimensional array `A`, `maxval(A, dim=1)`
would return a one dimensional array.  The elements of that array would be the maximum
value over each column in `A`.

The `mask` argument is a `logical` array of the same shape as the argument array.
If an element of the `logical` array is `.TRUE.`, the value of the corresponding
element in the argument array is taken into account, if it is `.FALSE.` it is not
taken into account.

The following program illustrates the optional arguments `dim` and `mask` when used
with the intrinsic functions `maxval` and `macloc`.

~~~~fortran
program max_array
    implicit none
    integer, dimension(3, 4) :: A
    integer :: i, j
    character(len=10), parameter :: FMT = '(A, 4I13)'

    A = reshape( [ (((i - 1)*size(A, 2) + j, j=1,size(A, 2)), i=1,size(A, 1)) ], &
                shape(A)) - 8
    do i = 1, size(A, 1)
        print *, A(i, :)
    end do
    print FMT, 'maximum = ', maxval(A)
    print FMT, 'column maximum = ', maxval(A, dim=1)
    print FMT, 'row maximum = ', maxval(A, dim=2)
    print FMT, 'maximum odd elment = ', maxval(A, mask=mod(A, 2) /= 0)
    print FMT, 'row maximum negative elment = ', maxval(A, dim=1, mask=A < 0)
    print FMT, 'maxloc = ', maxloc(A)
    print FMT, 'column maxloc = ', maxloc(A, dim=1)
end program max_array
~~~~

The output of this program is shown below.

~~~~
         -7          -4          -1           2
         -6          -3           0           3
         -5          -2           1           4
maximum =             4
column maximum =            -5           -2            1            4
row maximum =             2            3            4
maximum odd elment =             3
row maximum negative elment =            -5           -2           -1  -2147483648
maxloc =             3            4
column maxloc =             3            3            3            3
~~~~

Note the output for `maxval(A, dim=1, mask=A < 0)`.  The last value is not exactly
what you would expect.  However, when you inspect the matrix, you will see that the
last column has no negative elements.  This is an example of garbage in (this code),
garbage out.

The `count` function uses a mask to count elements in an array that satisfy some
Boolean condition, e.g., `count(A >= 0)` will return the number of positive elements
in the array `A`.  It takes an optional argument `dim` as well.


## Extent

Although the default indices of a Fortran array ranges from 1 to the size of the
array, it is possible to declare arrays with a non-default extent.  Consider the
following array declaration.

~~~~fortran
real, dimension(-10:10) :: A
~~~~

This declares an array named `A` that has 21 elements of type `integer`.  The first
element is at index -10, the second at -9, and so on.  The last element has index
10.

The intrinsic function `lbound` and `ubound` return the lower and upper bound(s) of
an array respectively.  Similar to the `size` function, these intrinsic functions
take an optional argument `dim` to specify the dimension for which you want the
upper or lower bound.

If you feel tempted at this point to emulate 0-based indices because that is what you
are used to in some other programming language, please don't.  It adds complexity to
your code and make it harder to read for seasoned Fortran programmers (also, they
will make fun of you).

Regardless, arrays with non-default upper and lower bounds indices definitely have
their use cases.


## Arrays and user-defined procedures

Arrays can be passed as arguments to user-defined procedures, and be returned as
the result of functions.  You can even create your own elemental procedures that
act on individual array elements just like intrinsic procedures such as, e.g.,
`sqrt`.


### Assumed-shape arguments

You may think that there is an a problem when you have to declare an argument of
a procedure that is an array: how to specify its shape?  If the shape would have
to be specified explicitly, e.g, `dimension(3, 4)` writing and using procedures
involving arrays would be *very* cumbersome.  Fortunately, Fortran offers a very
elegant solution: assumed-shape arrays.

The code fragment below shows a function that has a two dimensional array that is
supposed to represent a square matrix as an argument, and computes the trace.


~~~~fortran
    real function trace(matrix)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        real, dimension(:, :), intent(in) :: matrix
        integer :: i

        if (size(matrix, 1) /= size(matrix, 2)) then
            write (unit=error_unit, fmt='(A)') &
                'error: can not compute trace of a non-square matrix'
            stop 1
        end if
        trace = 0.0
        do i = 1, size(matrix, 1)
            trace = trace + matrix(i, i)
        end do
    end function trace
~~~~

The function's argument is an array of rank 2, but unspecified size
(`dimension(:, :)`), however, the information about the shape of the array is
available when the function is executed.  The `size` and `shape` intrinsic functions
will return the values corresponding to the array in the calling context.


### Elemental procedures

Elemental procedures are pure procedures that operate on a single scalar value.  The
following Fortran program shows an elemental function and its application.

~~~~fortran
program linear_transform
    implicit none
    real, dimension(5) :: values

    call random_number(values)
    print *, values
    print *, lin_transform(values, 2.0, 1.0)

contains

    elemental real function lin_transform(x, a, b)
        implicit none
        real, intent(in) :: x, a, b

        lin_transform = a*x + b
    end function lin_transform

end program linear_transform
~~~~


### Arrays as return values

Fortran procedures can also return arrays as a result of a function call.  The
following function illustrates that.  Given a size, it constructs an identity
matrix (represented as two dimensional array).

~~~~fortran
    function eye(n) result(matrix)
        implicit none
        integer, value :: n
        real, dimension(n, n) :: matrix
        integer :: i

        matrix = 0.0
        do i = 1, size(A, 1)
            matrix(i, i) = 1.0
        end do
    end function eye
~~~~


## Array-related statements

The fact that arrays are first-class citizens in Fortran is further illustrated by two
statements.  The first is the where statement, the second the forall statement.


### where statement

The where statement makes conditional assignment to array elements considerably
simpler.

As an example, consider the random initialization of a system of particles.
Approximately half of the particles are protons, the other half electrons.  The masses
and charges for the particles are stored in an array `masses` and `charges`
respectively.  The number of particles is stored in the parameter `nr_particles`.

This could be implemented as follows.

~~~~fortran
...
real, dimension(nr_particles) :: masses, charges
real :: probability
integer :: i

do i = 1, nr_particles
    call random_number(probability)
    if (probability < 0.5) then
        masses = proton_mass
        charges = proton_charge
    else
        masses = electron_mass
        charges = electron_charge
    end if
end do
...
~~~~

The `random_number` procedure will assign a pseudo-random number in the half-open
interval 0.0 to 1.0.

Although this may seem the obvious way to implement this, there is an arguably more
elegant alternative using the where statement.

~~~~fortran
...
real, dimension(nr_particles) :: masses, charges, probabilies

call random_number(probabilies)
where (probabilies < 0.5)
    masses = proton_mass
    charges = proton_charge
elsewhere
    masses = electron_mass
    charges = electron_charge
end where
...
~~~~

Perhaps the easiest explanation of this statement is its translation into a do and if
statement which is functionally equivalent.

~~~~fortran
...
real, dimension(nr_particles) :: masses, charges, probabilies

call random_number(probabilies)
do i = 1, nr_particles
    if (probabilities(i) < 0.5) then
        masses = proton_mass
        charges = proton_charge
    else
        masses = electron_mass
        charges = electron_charge
    end if
end do
...
~~~~

Using the where statement has a number of advantages:

1. it reduces the number of statements, simplifying the code;
1. it expresses your intent more clearly, so the compiler can take advantage for
   optimization.

Since all assignments are independent, the compiler is free to generate code that does
them in any order.

The general form of the where statement syntax is.

~~~~
where (<logical expression 1>)
    <block statements 1>
elsewhere (<logical expression 2>)
    <block statements 2>
...
elsewhere
    <block statements n>
end where
~~~~

If you have a simple case with a single, unconditional `elsewhere`, the `merge`
function can be a nice alternative.

~~~~fortran
...
real, dimension(nr_particles) :: masses, charges, probabilies

call random_number(probabilies)
masses = merge( probabilies < 0.5, proton_mass, electron_mass)
charges = merge( probabilies < 0.5, proton_charg, electron_charg)
...
~~~~


### forall statement

Another statement that is very useful in the context of arrays is forall.  This
statement lets you iterate over one or more integer variables and set
conditions on the values of these indices.  For instance, suppose you would like
to initialize a triangular matrix with all elements under the main diagonal equal to
0.

~~~~fortran
integer, parameter :: N
integer :: i, j
real, dimension(N, N) :: A

forall (i=1:N, j=1:N, i <= j)
    A(i, j) = f(i, j)
end forall
~~~~

This would be equivalent to the following code.

~~~~fortran
integer, parameter :: N
integer :: i, j
real, dimension(N, N) :: A

do i = 1, N
    do j = i, N
        A(i, j) = f(i, j)
    end do
end do
~~~~

Note that the iterations are independent of one another, so when the forall statement
is used, the compiler is free to choose an efficient order for the iterations.  This
construct also collapses the iteration space from multiple iterations into a single
one.

The general syntax for the forall statement is given below.

~~~~
forall (<iter 1>, ..., <iter n>, <logical expression>)
    <block statements>
end forall
~~~~

The `<iteration 1>` to `<iteration n>` have the form `<variable>=<first>:<last>`
or `<variable>=<first>:<last>:<stride>`.  The values of `<first>`, `<last>` and
`<stride>` should not refer to other iteration variables.  This means our example
can not be written as follows.

~~~~fortran
forall (i=1:N, j=i:N)
    A(i, j) = f(i, j)
end forall
~~~~

If the conditional expression, also called the mask, is left out, it is assumed to be
true for all iteration values.

Note that only assignments to arrays are allowed in the block of a forall statement.
