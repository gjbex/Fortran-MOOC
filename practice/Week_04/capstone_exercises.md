# Capstone exercises

## Question 1

Write an application that uses direct I/O to create a file that contains 

U 100 records that contain the integer value 1,
* 1000 records that contain the integer value 2,
* 10000 records that contain the integer value 3.


## Question 2

Implement the [Fisher-Yates](https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle) that creates a random permutation (shuffle) of a sequence such that each permutation is equally likely.  Apply this algorithm to the data file generated in the previous exercise.


## Question 3

[Reservoir sampling](https://en.wikipedia.org/wiki/Reservoir_sampling) is a randomized algorithm to choose $$k$$ items from a population of unknown size (without replacement) such that each sequence of $$k$$ items is statistically equally likely.  Implement this algorithm to sample from files generated in the previous exercise.


## Question 4

Benchmark binary sequential versus streaming I/O.  Write one application to write data, another to read that data, for both access modes.


## Question 5

Use gprof to profile the Julia set application that you created in week 2.
