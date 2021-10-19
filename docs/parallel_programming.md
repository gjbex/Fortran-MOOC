# Parallel programming

Modern computer hardware allows for parallel execution at various levels.  Since
performance is very often a primary concern in scientific computing parallel
programming is an essential tool in your toolbox.

This course offers no more than teasers for this fascinating topic, you are
referred to various PRACE courses that deal with parallel programming paradigms
in a lot of detail.


## Vectorization

At the level of the cores in a modern CPU there is already a level of
parallelization: SIMD (Single Instruction, Multiple Data).  You've already
encountered this in a [previous section](performance.md).


## Shared memory programming

A CPU has multiple cores that can each process a thread of instructions
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
application will still perform correctly using only a single thread.

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

The OpenMP `parallel` directive opens a parallel region, i.e., multiple threads
will be executing the code up to the point where the parallel region is closed
again.  When a parallel region is opened, the variables that are intended as
thread-private or shared are declared.

Shared variables are shared among all threads as the name implies.  All threads
can read the value of a shared variable, and can update the variable as well,
although this has to be done with care, since that might introduce race
conditions.

Thread-private variables will be available in each thread, and are independent
of one another.  When a thread modifies a thread-private variable, this has no
bearing on the instances of that variable in other threads.

The work is divided among threads using work sharing directives.  One of the
primary such directives is the `do` directive.  This will divide the iterations
of a do loop among threads.

In this example, the iterations are *not* independent.  Indeed, the variable
`nr_success` is shared among all threads, and potentially incremented in each
iteration.  However, semantically, it is a reduction, so it can be done locally
in each thread, and when all threads have finished, their respective results
can be reduced to the final value of `nr_success`.  All the instructions
required to do this are generated automatically by the compiler.

The semantics is defined by the `reduction` clause of the `do` work sharing
directive.  The reduction operation is a sum, and the variable(s) involved in
the reduction are declared.

Gradually, the feature set of OpenMP was extended.  OpenMP now also defines
directives to help the compiler vectorize code (SIMD directives).

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
alternative to OpenMP.  OpenACC has NVIDIA's weight behind it.

A third alternative is OpenCL, for which Fortran bindings are available.


## Distributed programming

At the next level of parallelization you can use multiple computers, typically
compute nodes in an HPC cluster.  The processes of your application will need
to communicate and exchange state and data.  The de-facto standard for distributed
computing for scientific applications is the Message Passing Interface (MPI).
However, Fortran 2018 defines an alternative: coarrays.


### MPI

MPI is a standard that has a number of implementations, both open source and
commercial e.g., Open MPI, MVAPICH2, Intel MPI and so on.  All implementations
are standard compliant, so an application can be linked to any library
implementation.

Whereas in shared memory programming threads communicate via shared memory
locations, the main mode of communication of MPI is by message passing.

The first thing that all MPI application have to do is initialize the
communication environment, and the last thing is to finalize that environment.
Calls to the `MPI_Init` and `MPI_Finalize` subroutines are the first and last
statement of an MPI application.

This ensures there is a communicator of which all processes are members and
that can be used to exchange messages.  Messages consist of data.  This data
can be single values of a primitive data type such as a floating point or
integer number, or (multi-dimensional) arrays of such values.  In fact, MPI
lets you define your own data types, very similar to user defined types in
Fortran.

Roughly speaking, two types of communication are supported:

* peer-to-peer: an individual process sends a message to another process,
* collective: many or all processes are involved in the communication.

Examples of collective communication are:

* `MPI_Bcast`: one process broadcasts a value to all other processes,
* `MPI_Scatter`: one process sends different values to all other processes,
* `MPI_Gather`: one process receives values from all other processes,
* `MPI_Reduce`: one process aggregates values from all other processes, for
  instance as a sum or a product.

The behavior of the processes is differentiated based on their rank in the
communicator.  This is an integer between 0 and the number of processes in
the communicator minus 1.

The code below computes the value of $$\pi$$ similar to the one which
illustrated OpenMP.

~~~~fortran
...
use :: mpi_f08
...
call MPI_Init()

! get rank in and size of communicator
call MPI_Comm_rank(Mcomm=MPI_COMM_WORLD, rank=my_rank)
call MPI_Comm_size(comm=MPI_COMM_WORLD, size=my_size)

! show number of processes, only rank 0
if (my_rank == 0) &
    print '(A, I0, A)', 'running with ', my_size, ' processes'

! do local computation
nr_success = 0
do i = 1, nr_tries/my_size
    call random_number(x)
    call random_number(y)
    if (x**2 + y**2 <= 1.0) nr_success = nr_success + 1
end do

! reduce the results, rank 0 will have the sum
total_nr_success = 0
call MPI_Reduce(sendbuf=nr_success, recvbuf=total_nr_success, count=1, &
                datatype=MPI_INTEGER, op=MPI_SUM, root=0, &
                comm=MPI_COMM_WORLD)

! show the result, only rank 0
if (my_rank == 0) then
    print '(A, F10.7)', 'sampled pi = ', 4.0*real(total_nr_success)/nr_tries
    print '(A, F10.7)', 'real pi = ', PI
end if

! finalize MPI
call MPI_Finalize()
~~~~

Only the process with rank 0 will print the number of processes in the
communicator, and that process will also print the final result.  The
data of all processes will also be aggregated into `total_nr_success`
of root process 0 by a call to the collective `MPI_Reduce` subroutine.

In this code fragment, the Fortran 2008 syntax is used, (module `mpi_f08`).
This is strongly recommended for new development since it defines specific
data types that help the compiler catch mistakes.

As opposed to OpenMP, there are no shared variables, all data is private
to the process.  However, MPI also offers facilities for shared memory
programming, but this is beyond the scope of this very brief introduction.

Note that parallelizing a sequential application using MPI is typically
more work than making it multi-threaded with OpenMP, but MPI applications
offer the huge benefit of scaling to large numbers of compute nodes, at
least when well written.


## Coarrays

The Fortran 2018 standard defines coarrays.  Coarrays and procedures defined on
them allow you to develop distributed applications in pure Fortran.  However,
note that it is still early days, and that not all Fortran compilers support
coarrays, and that even those that do may have only partial support.

A coarray application can run multiple images.  Variables that have a
codimension are instantiated in each image, and can also be accessed from
other images by using the image ID as codimension index.

Several coarray procedures are defined, e.g., `co_sum`, which is similar to
`MPI_Reduce`.

The following program would compute $$\pi$$ as the example for OpenMP and MPI,
but implemented using a coarray.

~~~~fortran
program compute_pi
    use, intrinsic :: iso_fortran_env, only : I8 => INT64
    implicit none
    real, parameter :: PI = acos(-1.0)
    integer(kind=I8), parameter :: nr_tries = 500000000
    integer(kind=I8), codimension[*] :: nr_success
    integer(kind=I8) :: i
    real :: x, y

    nr_success = 0
    if (this_image() == 1) &
        print '(A, I0, A)', 'running with ', num_images(), ' images'
    do i = 1, nr_tries/num_images()
        call random_number(x)
        call random_number(y)
        if (x**2 + y**2 <= 1.0) nr_success = nr_success + 1
    end do
    sync all
    call co_sum(nr_success, result_image=1)
    if (this_image() == 1) then
        print '(A, F10.7)', 'sampled pi = ', 4.0*real(nr_success)/real(nr_tries)
        print '(A, F10.7)', 'real pi = ', PI
    end if
end program compute_pi
~~~~

The variable `nr_success` is a coarray and each instance is updated in its
own image.  These values are summed, and the result is available in image 1.
It is this image that will compute and print the final result.



#e Hybrid programming

Of course, cutting-edge HPC applications will combine parallelism at
various levels.  Almost all applications will be compiled with vector
instructions.  Often, the cores of a CPU are running OpenMP threads, while
processes of the application run on multiple compute nodes, communicating
through MPI.

Large scale acceleration combines MPI for inter-process communication
with, e.g., OpenACC to use GPU accelerators.

Developing hybrid applications is non-trivial, the design and the level
at which to parallelize is a critical decision.  PRACE has a number of
good courses on this topic.
