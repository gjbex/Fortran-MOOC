# Capstone exercises

## Question 1

Implement a matrix-matrix multiplication yourself, and compare its performance to the `matmul` intrinsic
function.  Finally, use BLAS to compute the matrix-matrix product and time the results.  When you
benchmark, do this for various sizes for the matrices, starting with e.g., $$3 \times 3$$ and going
to very large matrices.  You can initialize the matrices with random numbers.


## Question 2

Use grpof to see how much time is spent on initializing the matrices versus computing the matrix-matrix
product in the previous expercise.


## Question 3

Can you apply your knowlegde of the memory hierarchy (caches) to improve the performance of your own
matrix-matrix multiplication for large matrices?


## Question 4

Write an application that reads a square matrix $$A$$ from a file using formatted I/O as well as a vector
$$\vec{b}$$ from another file, and that uses LAPACK to solve the set of linear equations
$$A \cdot \vec{x} = \vec{b}$$.  Check the scaling behaviour, i.e., how does the execution time increase
as a function of the dimension of the system of equations?


## Question 5

Use OpenMP to parallelize the computation of the Julia set.  Check the scaling, i.e., how does the
runtime change as a function of the number of threads when the matrix's size remains constant?
Have a look at the `schedule` OpemMP clause to see whether that would improve efficiency.


## Question 6

Use the GSL (Gnu Scientific Library) to solve the set of linear equations you did with LAPaCK in
a previous exercise.  Use C bindings.  Compare the performance of using LAPACK versus GSL.
