# Parallel programming

## Question 1

Which of the following statements is correct?

1. You can share data so that each thread in an OpenMP application can access it. [Indeed] [x]
1. Threads of an OpenMP application can run on multiple computers. [No, this is shared memory programming]
1. You need a special compiler to use OpenMP. {No, compilers such as GCC or Clang support OpenMP out-of-the-box]
1. One of the pitfalls of OpenMP are data races. [Indeed, race conditions can occur] [x]


## Question 2

Which of the following statements is correct?

1. By default, processes that run on the same compute node share memory in an MPI application. [No, MPI is shared-nothing by default]
1. To pass messages using MPI between processes, a communicator is required. [Indeed] [x]
1. Using collective operations will typically be more efficient than implementing the same functionality using only peer-to-peer communication. [Indeed] [x]
1. MPI supports shared memory programming. [Indeed, it does] [x]


## Question 3

Which of the following statements is correct?

1. OpenMP can be used tor GPU programming. [Indeed, recent versions of the standard offer support for accelerators, including GPUs] [x]
1. Code with OpenACC directives will not work unless you have a GPU. [No, OpenACC can generate code for CPUs as well]
1. CuddaFor is a version of CUDA for Fortran. [No, I don't think so, although it sounds cute]
1. When programming for GPUs, efficient data transfer is crucial. [Indeed, as for almost any HPC programming] [x]


## Question 4

Which of the following statements is correct?

1. Coarrays allow direct access from an image to data stored in another image. [Indeed] [x]
1. Coarrays allow you to send a message from one image to another. [No, not directly]
1. Several aggregation operations are defined for coarrays. [Indeed] [x]
1. Any variable that has a codimension is a coarray. [Indeed] [x]


## Question 5

Which of the following statements is correct?

1. You can combine OpenMP shared memory programming with MPI distributed programming. [Indeed, this is a popular form of hybrid programming] [x]
1. MPI has directives to aid compilers when they vectorize code. [No, it doesn't]
1. OpenACC allows you to use GPUs, but also multiple cores of the CPU. [Indeed] [x]
1. Fortran (when it supports coarrays) has procedures to move data between host and accelerators. [No, it hasn't]
