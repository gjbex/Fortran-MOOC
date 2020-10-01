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


## BLAS

BLAS defines a large number of procedures, so we will just discuss a few of
them so that you get the flavor of how to use the library.  You will see one
or more examples of each BLAS level.


### BLAS level 1

Level 1 operation are defined on vectors.  For example, the subroutine `dcopy`
will copy a double precision array (`d`) to another double precision array.

~~~~fortran
...
real(kind=DP), dimension(rows, cols) :: matrix1, matrix2
...
call dcopy(size(matrix1), matrix1, 1, matrix2, 1)
...
~~~~
