# Vectorization and caches

## Question 1

Can the following do loop be vectorized?

~~~~fortran
do i = 1, 1000
    a[i] = alpha*a[i] + b[i]
end do
~~~~

1. Yes [Indeed, the iterations are independent] [x]
1. No [Are you sure?]


## Question 2

Can the following do loop be vectorized?

~~~~fortran
do i = 2, 1000
    a[i-1] = alpha*a[i] + b[i]
end do
~~~~

1. Yes [Are you sure?]
1. No [Indeed, there is a dependency between the iteration] [x]


## Question 3

Which of the following statements is correct?

1. Everything that is stored in L1 cache is also stored in L2 cache of the core. [Indeed, L1 and L2 are inclusive] [x]
1. If the size of the data level 1 cache is 32 kByte, you can store up to 8196 independent single precision floating point values. [No, read up on cache lines]
1. In assembler, you can specify which values to store in the caches. [No, no such instructions exist]
1. The order in which you iterate over the elements of a multi-dimensional array has an impact on the performance of your application. [Indeed] [x]
