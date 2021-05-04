# Random numbers

## Question 1

Which of the following statements are correct?

1. If you run a Fortran application that uses the `random_number` intrinsic procedure twice, the application will run identically if it is not explicitely seeded. [No, the Fortran runtime will seed automatically]
1. The `random_number` intrinsic procedure generates floating point numbers between 0 and 1 (exclusive). [Indeed] [x]
1. You can use the `random_nubmer` intrinsic procedure to initialize multi-dimensional arrays. [Indeed] [x]


## Question 2

Which of the following statements are correct?

1. The size of the random seed can be determined using the `random_seed` intrinsic procedure. [Indeed] [x]
1. The random number generator can be seeded using the `random_seed` intrinsic procedure. [Indeed] [x]
1. The size of the array  used to seed the random number generator determines precision of the pseudo-random numbers generated. [No, absolutely not]
1. The optional `distribution` argument of the `random_number` intrinsic procedure allows to specify the distribution to sample, e.g., `'normal'` or `'gamma'`. [No, this argument doesn't exist]
