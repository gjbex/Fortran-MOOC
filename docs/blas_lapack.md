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

Note that BLAS function need to be declared as `external`.


### BLAS level 2: matrix-vector operations

An example of a level 2 operation is a matrix-vector product.  For instance,
`sgemv` implements the product of a single precision real general matrix and a
vector.  To be more precise, the result is given by:
$$
    \vec{y} = \alpha A \vec{x} + \beta \vec{y}
$$
or
$$
    \vec{y} = \alpha A' \vec{x} + \beta \vec{y},
$$
depending on the first argument given to `sgemv`.  The signature of the
subroutine is

~~~~fortan
subroutine sgemv(<TRANS>, <M>, <N>, <alpha>, <A>, <LDA>, <x>, <INCX>, <beta>, <y>, <INCRY>)
~~~~

The value of `<TRANS>` can be `'t'` or `'c'` to transpose or take the complex
conjugate from `<A>` respectively, or `'n'` to use `<A>` as is.  `<M>` and `<N>`
are the number of rows and columns of `<A>` respectively.  `<A>` is a single
precision real two-dimensional array.  `<LDA>` is the number of rows of `<A>`.
`<x>` and `<y>` are single precision real one-dimensional arrays.  `<INCX>` and
`<INCY>` are typically equal to 1.  `<alpha>` and `<beta>` are single precision
real values.  If `<beta>` is zero, `<y>` does not need to be initialized.

Specific implementation of this operation are defined for special cases for
$$A$$, e.g., when $$A$$ is a banded, symmetric, symmetric banded or triangular
matrix.

There are a few other useful level 2 operations such as solving a triangular
set of equations and performing a symmetric rank 1 and rank 2 operation, i.e.,
$$
    A = \alpha \vec{x} \otimes \vec{x}' + A
$$
and
$$
    A = \alpha \left\( \vec{x} \otimes \vec{y}' + \vec{y} \otimes \vec{x}' \right\) + A
$$
respectively.


### BLAS level 3: matrix-matrix operations

Matrix-matrix multiplication is implemented by level 3 operations for general,
symmetric and triangular matrices.  For instance, `sgemm` implements a matrix-matrix
multiplication for two-dimensional real arrays with single precision values.

~~~~fortran
...
real, dimension(M, K) :: A
real, dimension(K, N) :: B
real, dimension(M, N) :: C
real :: alpha, beta
...
call sgemm('n', 'n', M, N, K, alpha, A, K, B, N, beta, C, M)
...
~~~~
The first two arguments specify which operation should be performed on the
matrices `A` and `B` respectively. This can be `'n'` (none), `'t'` (transpose)
or `'c'` conjugate complex.
The sizes of the matrices are given next, `A` is an `M` by `K` matrix, `B` is
`K` by `N` and `C` is `M` by `N`.  The operation performed is
$$
    C = \alpha \textrm{op}(A) \cdot \textrm{op}(B) + \beta C
$$

Other operation implemented in the level 3 BLAS library rank-$$k$$ symmetric
updates, and solving sets of triangular linear equations with multiple
right-hand sides.


## LAPACK

LAPACK implements some widely used algorithms for linear algebra for solving
sets of linear equations, linear least square methods, eigenvalue problems,
singular value decomposition and matrix factorization.  Like BLAS, it has
implementation for real and complex matrices, single and double precision.

LAPACK is available under an open source BSD license, but Intel's MKL library
offers an implementation as well.  Since LAPACK is built on top of BLAS, its
performance depends critically on that of the BLAS library implementation.

The naming of LAPACK procedures is similar to BLAS in that the name of a
procedure indicates both the type of data in the matrices (real or complex,
single or double precision) and the type of matrix (general, bidiagonal, 
symmetric and so on).  The name ends with a one to three letter identification
of the algorithm.  For instance, `sgesvd` would be s singular value
decomposition (`svd`) of a general (`ge`) single precision (`s`) matrix.

It would lead us too far to go into all the algorithms implemented in LAPACK,
so we will just present some examples.


### Singular value decomposition

The singular value decomposition of an $$m \times n$$  matrix $$M$$ is given by
$$U \cdot \Sigma \cdot V^{*}$$.   Here $$U$$ is an $$m \times m$$ matrix and
$$V$$ is $$n \times n$$ matrix, both unitary and their columns form an
orthogonal basis.  The matrix $$\Sigma$$ is a diagonal $$m \times n$$ matrix
with non-negative elements.  The LAPACK implementation returns these in
descending order.  If $$M$$ is real-valued, so are $$U$$ and $$V$$, and
$$V^* = V^t$$.

You can find more information about singular value decomposition and its
applications in any good book on numerical methods but for a quick introduction
[Wikipedia](https://en.wikipedia.org/wiki/Singular_value_decomposition) will
serve.

By way of example, we will consider the `sgesvd` subroutine to compute the
singular value decomposition of a general single precision real matrix.
The arrays `M`, `U` and `VT` are declared as you would expect.  The number of
rows of `M` is `nr_rows`, its number of columns is `nr_cols`.  Since $$\Sigma$$
is a diagonal matrix, it is represented as a one-dimensional array `S` with a
size that is the minimum of the number of rows and columns of `M` so as not to
waste memory.

The implementation of the SVD algorithm requires working space that can be
determined by a call to the `sgesvd` subroutine with the argument representing
the size of the work array set to -1.  The work array should have at least size
1 at that point to accommodate the required size as a result of the call.
It is convenient to use an allocatable array so that it can be sized
dynamically as required.

~~~~fortran
real, dimension(:), allocatable :: work
integer :: work_size, info, istat
...
allocate(work(1))
info = 0
call sgesvd('A', 'A', nr_rows, nr_cols, M, nr_rows, S, &
            U, nr_rows, VT, nr_cols, work, -1, info)
work_size = int(work(1)) + 1
allocate(work(work_size), stat=istat)
~~~~

Most of these arguments are self-explanatory, the first two indicate what
should be returned in the matrices `U` and `VT`.   `'A'` means that all columns
should be returned.  You can read `sgesvd`'s documentation for other options.

The argument `info` will be set to 0 upon success.  A negative value indicates
the index of an illegal argument to `sgesvd`, a positive value signals that the
algorithm did not converge (relevant only for the second call to `sgesvd`).

After this preparatory step, the actual work can be done by a second call to
`sgesvd`.

~~~~fortran
call sgesvd('A', 'A', nr_rows, nr_cols, M, nr_rows, S, &
            U, nr_rows, VT, nr_cols, work, work_size, info)
~~~~
