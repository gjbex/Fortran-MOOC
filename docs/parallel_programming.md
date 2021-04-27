# Parallel programming

Modern computer hardware allows for parallel execution at various levels.  Since
performance is very often a primary concern in scientific computing parallel
programming is an essential tool in your toolbox.

This course offers no more than teasers for this fascinating topic, you are
referred to various PRACE courses that deal with parallel programming paradigms
in a lot of detail.


## Vectorization

At the level of the cores in a moderen CPU there is already a level of
parallelization: SIMD (Single Instruction, Multiple Data).  You've already
encountered this in a [previous section](performance.md).


## Shared memory programming

A CPU has multiple cores that can each process a thred of instructions
independently, giving rise to the next level of parallelization.  An
application can have multiple threads, each with instructions executed in
parallel.  For multi-threaded or shared memory programming in Fortran, OpenMP
is the de-facto standard.

OpenMP is a specification that is supported by most compiler developers.  It
consists of three parts:

* directives, i.e., declarative source code annotations,
* library functions for querying the runtime, tuning the behavior and
  managing locks, and
* environment variables to control the OpenMP runtime.

A major advantage of OpenMP is that it can be introduced gradually in the
source code, beginning with the low-hanging fruit.  A well-written OpenMP
application will stil perform correctly using only a single thread.

Initially, OpenMP concentrated primarily on parallelizing iterations.  The
following code fragment illustrates this.

~~~~fortran
real :: x, y
integer :: i, nr_success
...
!$omp parallel default(none) private(x, y) shared(nr_success)
...
!$omp do reduction(+:nr_success)
do i = 1, nr_tries
    call random_number(x)
    call random_number(y)
    if (x**2 + y**2 <= 1.0) nr_success = nr_success + 1
end do
!$omp end do
...
!$omp end parallel
~~~~

The OpenMP `parallel` directive opens a parallel regions, i.e., multiple threads
will be executing the code upto the point where the parallel region is closed
again.  Whe a parallel region is opened, the variables that are intended as
thread-private or shared are declared.

Sahred variables are shared among all threads as the name implies.  All threads
can read the value of a shared variable, and can update the variable as well,
although this has to be done with care, since that might introduce race
conditions.

Thread-private variables will be available in each thread, and are independent
of one another.  When a thread modifies a thread-private variable, this has no
bearing on the instances of that variable in other threads.

The work is divided among threads using worksharing directives.  One of the
primary such directives is the `do` directive.  This will divide the iterations
of a do loop among threads.

In this example, the iterations are *not* independant.  Indeed, the variable
`nr_success` is shared among all threads, and potentially incremented in each
iteration.  However, semantically, it is a reduction, so it can be done locally
in each thread, and when all threads have finished, their respective results
can be reduced to the final value of `nr_success`.  All the instructions
required to do this are generated automatically by the the compiler.

The semantics is dfeined by the `reduction` clause of the `do` worksharing
direcitve.  The reduction operation is a sum, and the variable(s) involved in
the reduction are declared.

Gradually, the feature set of OpenMP was extended.  OpenMP now also defines
direcitves to help the compiler vectorize code (SIMD directives).

Another major addition is task-based parallelism.  Using directives to spawn
independent tasks that are managed by the OpenMP runtime helps to parallelize
code that is hard to express as iterations.  For instance recursive algorithms
can be parallelized using tasks.

However, tasks are also quite useful to handle nested parallelism.  In such
problems, it is often hard to decide on how to distribute iterations at
various levels of the code over threads.  Making the wrong choice will impact
performance considerably.  This problem is mostly solved by using a task-based
approach since the runtime is responsible for the resource allocation and can
typically do this quite efficiently.


## Accelerators

Accelerators, mostly Graphical Processing Units (GPUs) play an increasingly
important role in scientific computing.  If a problem suits the hardware and
the programming model for such devices, considerable speedups can be obtained
compared to computations on CPUs.  However, note the qualified statement, not
all computations can be performed efficiently on GPUs.

Recently, support for accelerators has been added to the OpenMP standard, and
is implemented by various compiler developers.  Directives have been defined
to move data and execution between the host memory/CPU to the accelerator
device.

However, OpenMP is not the only option for Fortran.  OpenACC is a directive-based
alternative to OpenMP.  OpenACC has NIVIDA's weight behind it.

A third alternative is OpenCL, for which Fortran bindings are available.
