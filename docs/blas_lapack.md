# BLAS and LAPACK

Matrix computations and linear algebra are some of the most basic building
blocks of may scientific software applications.  Often, the performance of
these core algorithms determine the performance and efficiency of your code.

BLAS (Basic Linear Algebra Subprograms) is a library specification that
implements various operations on vectors and matrices.  It was originally
published in 1979.  There are many
implementations such as the reference implementation from netlib, OpenBLAS
and Intel MKL (Math Kernel Library).  It is quite important with respect to
performance to select a well-optimized implementation for your platform.
Typically OpenBLAS (open source) and Intel MKL (commercial) will give the best
performance.  BLAS defines three classes of algorithms, BLAS level 1, 2 and 3:

* BLAS Level 1: operations on vectors, e.g., scalar product, scaling, Givens
  rotation;
* BLAS Level 2: matrix-vector operations, e.g., matrix-vector product, solving
  a triangular equation;
* BLAS level 3: matrix-matrix operations, e.g., matrix-matrix products.

For several operations implementations for special types of matrices are
available (triangular matrices, symmetric matrices, band matrices).  The
specification supports single and double precision real and complex floating
point numbers.

Whereas BLAS provides basic linear algebra operations on vectors and matrices,
you will typically turn to LAPACK (Linear Algebra PACKage) for more
sophisticated algorithms.  Just as for BLAS, netlib provides a reference
implementation that has been optimized in various library implementations such
as OpenBLAS and Intel MKL.

LAPACK defines algorithms to find eigenvalues and eigenvectors, solve linear
equations, perform linear regression, as well as a wide selection of matrix
decomposition algorithms.  As for BLAS, algorithms are implemented for both
single and double precision real floating point numbers, and complex numbers
when appropriate.

Under the hood, LAPACK algorithms are often implemented using BLAS procedures,
so it is required to have BLAS installed when you want to use LAPACK, and very
highly recommended to have a well-optimized implementation if you want LAPACK
to perform efficiently.

You will notice that the names of procedures (mostly subroutines) are fairly
cryptic, e.g., `dgemm`.  The latter is a double precision (`d`) general (`ge`)
matrix (`m`)-matrix (`m`) multiplication.  The reason for such names is
historical.  Names for procedures were restricted to 6 characters at the time.

The elements of the vectors and matrices can be single precision real numbers
(`s`), double precision real numbers (`d`), single precision complex numbers
(`c`) and double precision complex numbers (`z`).


## Advantages of BLAS and LAPACK

Although the problems solved by the BLAS library seem fairly simple, the
algorithms that implement them are the result of decades of research and
painstaking optimizations.  Good implementations will use vector instructions
that get every drop of efficiency out of advance CPU design.  They have also
been written to take advantage of multiple cores, so your code automatically
executes in parallel, typically using OpenMP under the hood.

LAPACK is implement on top of BLAS, and hence will benefit from the
optimization and parallelization of that library as well.


## BLAS

BLAS defines a large number (more than 120) of procedures, so we will just
discuss a few of them so that you get the flavor of how to use the library.
You will see one or more examples of each BLAS level.


### BLAS level 1: vector operations

Level 1 operation are defined on vectors.  For example, the subroutine `dcopy`
will copy a double precision array (`d`) to another double precision array.

~~~~fortran
...
real(kind=DP), dimension(rows, cols) :: matrix1, matrix2
...
call dcopy(size(matrix1), matrix1, 1, matrix2, 1)
...
~~~~

Note that although level 1 focuses on vector operations, you can use this
subroutine to copy data from a multidimensional array to another
multidimensional, not necessarily of the same rank and dimensions.

The signature of of this subroutine is
~~~~
subroutine dcopy(<N>, <DX>, <INCX>, <DY>, <INCY>)
~~~~

Here, `<N>` is the number of elements to copy, typically the size of the array,
`<DX>` is the array to copy to `<DY>`.  Usually, the values for `<INCX>` and
`<INCY>` (increment for iterating over the elements of `<DX>` and `<DY>`
respectively are 1, but they can be used creatively in some situations.

Another very useful BLAS level 1 function is `sdot`, the single precision dot
product of two vectors, i.e.,
$$
   d = \Sum_{i=1}^{N} u_I v_i
$$

~~~~fortran
...
real, dimension(v_size) :: vector1, vector2
real :: product
real, external :: sdot
...
product = sdot(size(vector1), vector1, 1, vector2, 1)
...
~~~~

This is a function that returns a `real` value and takes arguments that have
similar semantics as those of `dcopy`.

Some other noteworthy procedures are available for normalization, scaling and
especially a combined multiply-add that is very common in scientific
algorithms, i.e.,
$$
    \vec{y} = \vec{y} + \alpha \vec{x}
$$
