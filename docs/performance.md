# Performance pitfalls

In High Performance Computing (HPC) computational efficiency is quite important.
Supercomputers are very expensive, and the tax payer who pays the bills will be
grateful if his money is well spent.

## Algorithms

The most important factor that determines performance is the algorithm chosen
to solve a problem.  Lets consider a fairly trivial example, the Fibonacci
sequence.  The Fibonacci numbers are defined as $$f(n) = f(n - 1) + f(n - 2)$$
for $$n \le 0$$ and $$f(1) = 1$$ and $$f(0) = 0$$.

This can be implemented recursively as shown below.

~~~~fortran
recursive function fib_recursive(n) result(fib)
    use, intrinsic :: iso_fortran_env, only : I8 => INT64
    implicit none
    integer(Kind=I8), value :: n
    integer(kind=I8) :: fib

    if (n == 0_I8) then
        fib = 0_I8
    else if (n == 1_I8) then
        fib = 1_I8
    else
        fib = fib_recursive(n - 1_I8) + fib_recursive(n - 2_I8)
    end if
                                                                                                                end function fib_recursive
~~~~

It is easy to see that the number of steps to compute the Fibonacci number for
$$n$$ is $$O(2^n)$$$, so exponential, i.e., very unpleasant.

However, an alternative algorithm is linear in $$n$$, so $$O(n)$$. 

~~~~fortran
function fib_iterative(n) result(fib)
    use, intrinsic :: iso_fortran_env, only : I8 => INT64
    implicit none
    integer(kind=I8), value :: n
    integer(kind=I8) :: fib
    integer(kind=I8) :: fib_n_1, i, tmp

    if (n == 0_I8) then
        fib = 0_I8
    else
        fib_n_1 = 0_I8
        fib = 1_I8
        do i = 2_I8, n
            tmp = fib
            fib = fib + fib_n_1
            fib_n_1 = tmp
        end do
    end if
end function fib_iterative
~~~~

There are many examples where selecting a better algorithms leads to spectacular
speedups of applications.  For instance, using dynamic programming in
optimization problems.


## Arithmetic

When you think about performance in terms of hardware, the clock frequency of
your Central Processing Unit (CPU) is obviously a factor that plays a role.
t what does that mean? 
This frequency is the number of cycles a CPU will perform per second.  In a cycle
elementary operations can be performed.  For instance, a multiplication takes
approximately 5 cycles to complete.  However, if your application does many of
them, one after the other without interruption, on average it takes only a
single cycle for an addition of a multiplication of two floating point values.
(Addition and multiplication are performed in approximately 5 stages, each
in dedicated hardware components.  Hence, when a pair of number is added, at
cycle 2 the first stage is idle, and can handle the first stage of a second pair
of numbers, while the second stage of the first pair is handled by second stage
hardware.  This continues for the five stages, so at any moment, 5 additions
are carried out, although they are each in a different stage.  This is called
pipe lining.

Since in scientific computing it is quite common to perform arithmetic on long
sequences of floating point value, you can say that you can do an addition or
a multiplication in one cycle.

However, some operations are more expensive than others.  For instance, a
division or a square root takes some 10 cycles, while computing an exponential
takes up to 20.

This offers some opportunities to improve performance.  For instance, when you
have to check wither a point $$(x, y)$$ is in a circle with radius $$R$$, you
can either check `sqrt(x*x + y*y) < R` or `x*x + y*y < R*R`.  The latter avoids
an expensive square root operation.

However, before you start to scan your code for this type of micro-optimizations,
read on, because it is unlikely that this is your main performance issue.


## Vectorization

CPUs can perform vector operations, i.e., the arithmetic operation on multiple
data values.  Values can be stored in registers, and these registers are used
as operands to the operations.  These registers have a width of 256 bit (or
even 512 bit on the most recent hardware), so they can store 8 single precision
floating point values, or 4 double precision values (twice those numbers for
512 bit registers).

Operations such as additions and multiplication can be executed on entire
registers, so on multiple values concurrently.  This is called Single Instruction
Multiple Data (SIMD).  Iterations are the candidate high-level programming
constructs to be handled using SIMD instructions.  This means that the iterations
that are executed concurrently have to be independent.

Consider the following code fragment.

~~~~fortran
use, intrinsic :: iso_fortran_env, only : SP => REAL32, DP => REAL64
real(kind=DP), dimension(N) :: x, y
real(kind=DP) :: alpha = 0.5_DP
integer :: i

do i = 1, N
    x(i) = alpha*x(i) + y(i)
end do
~~~~

The operations in each iteration are independent, so the following operations
can be performed simultaneously

* `x(1) = alpha*x(1)`
* `x(2) = alpha*x(2)`
* `x(3) = alpha*x(3)`
* `x(4) = alpha*x(4)`

The compiler will generate vector instructions for such a loop automatically
(if the optimization level is high enough, `-O3` for Fortran).

Of course this is not possible is there is a dependency between the loops as
in the example below.

~~~~fortran
do i = 2, N
    x(i) = alpha*x(i - 1) + y(i)
end do
~~~~

Note that expressing computations as array expressions makes it abundantly clear
to the compiler that it can generate vector instructions, e.g.,

~~~~fortran
use, intrinsic :: iso_fortran_env, only : DP => REAL64
real(kind=DP), dimension(N) :: x, y
real(kind=DP) :: alpha = 0.5_DP

x = alpha * x + y
~~~~

This also stresses the importantce of elemental procedures since the compiler can
sometimes generate versions of such procedures that are vectorized.

The use of vector instructions can significantly speed up your application.
It also follows that vectorized single precision arithmetic will be faster
than double precision, so if you don't need the accuracy of double precision
you can speed up your application.

However, array expressions may lead to temporary arrays being created in some
circumentances.  Using statements such as where and do concurrent can help in
such situations since this also indicates clearly to the compiler that iterations
are independent.


## Double promotion

It is important to control the precision of your computations to guarantee the
desired accuracy, but also with performance in mind.

Consider the following code fragment.

~~~~fortran
use, intrinsic :: iso_fortran_env, only : SP => REAL32, DP => REAL64
real(kind=SP), dimension(N) :: x, y
real(kind=DP) :: alpha = 0.5_DP

x = alpha * x + y
~~~~

Due to the type of the variable `alpha`, the computation is performed in double
precision, and converted to single precision.  If this code is vectorized, it
will take approximately twice as long to execute than would be the case if the
type of `alpha` were single precision.

This effect is call "double promotion', and you should be aware of it.


## Latencies and bandwidth

Many scientific applications are memory bound, i.e., the performance is limited
by the memory latency, i.e., the time it takes to move data between the Random
Access Memory (RAM) and the CPU.  That time is called latency, and can be
expressed in cycles.  The latency to fetch data from RAM is approximately 200
cycles.  The cache hierarchy in the CPU helps to mitigate this problem by
providing faster storage on the CPU so that data can be reused, rather than
fetched again from RAM.  These caches are of course substantially smaller
than the RAM.

The following table gives an overview of the size of the caches and their
latency.

| cache     | size        | latency (cycles) |
|-----------|-------------|------------------|
| L1        | 32 KB       | 5-10             |
| L2        | 256 KB      | 20               |
| L3 or LLC | up to 25 MB | 50               |
| RAM       | 100s GB     | 200              |

As a programmer, you don't have direct control over the contents of the
caches, the CPU manages this automatically.  However, indirectly, you
can exploit the cache hierarchy to your benefit.  Caches are intended for
data reuse, and that is at least partly under your control.

The figure below shows the latencies for various operations.

![Latencies][latency.png]

Another limiting factor is the bandwidth available between various
components of your computer, e.g., that between RAM and CPU.  It is best
to measure it for your system (or lookup the specifications), but for
dual CPU Intel Skylake nodes with 18 cores per CPU it is of the order of
250 GB/s.

Also the bandwidth of PCI Express is important since that will limit
network communication or data exchange with an accelerator.


## Cache lines

When a value, e.g., a single precision floating number, is transferred
from RAM to CPU, in reality 64 bytes are transferred, 4 of which contain the
w
relevant data value.  These 64 bytes are a cache line, and all values of a
cache line are transferred and stored in L2 and L1 caches.

This is something that you can exploit as a programmer: try to make sure that
all values on that cache line are used in your computation.  That means that
you should try to operate on data that is stored consecutively in memory, since
these values will be on the same cache lines.  This ensures that you use the
available memory bandwidth and caches optimally.

Consider the following example.

~~~~fortran
integer, parameter :: nr_rows = 1000, nr_cols = 500
real, dimension(nr_rows, nr_cols) :: data
integer :: row, col
...
do row = 1, nr_rows
    do col = 1, nr_cols
        ...
        call compute(data(row, col))
        ...
    end do
end do
~~~~

Now remember that Fortran stores 2D arrays by column, hence in the first iteration,
the cache line fetched from memory will contain several values of the first column
of `data`.  In the second iteration, the cache line fetched from memory will
contain values of the second column of `data`.  So each time, only a single value
of the cache line is used, so 4 bytes out of 64 bytes for single precision
floating point computations.

If you can change the order of the do-loop, this can be made much more efficient.

~~~~fortran
integer, parameter :: nr_rows = 1000, nr_cols = 500
real, dimension(nr_rows, nr_cols) :: data
integer :: row, col
...
do col = 1, nr_cols
    do row = 1, nr_rows
        ...
        call compute(data(row, col))
        ...
    end do
end do
~~~~

Now all values of `data` that are in the cache line will be used, so typically
all 16 values in the cache line.

In simple cases, the compiler will detect such issues, and automatically reorder
the loops.  In general however, it is your responsibility as a programmer to
ensure that your algorithm accesses the data in the most efficient way.
