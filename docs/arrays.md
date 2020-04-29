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
