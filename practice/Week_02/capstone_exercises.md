# Capstone exercises week 2

## Question 1

The Fibonacci numbers are defined as $$f_n = f_{n-1} + f_{n-2}$$ with $$f_0 = 0$$, $$f_1 = 1$$ and $$n > 1$$.  Implement a recursive version of the function, and compare the performance to the iterative implementation you did in week 1.  Try to explain the difference you observe.

For more information on Fibonacci numbers, you can have a look at the [Wikipedia article](https://en.wikipedia.org/wiki/Fibonacci_number) on the subject.


## Question 2

Consider again the Julia set that you already computed in week 1. A square region in the complex plain such that $$\\real(z) \le 2$$ and $$\\imag(z) \le 2$$. For each point $$z_0$$, compute the following iterations $$z_{n+1} = z_n^2 + c$$ such that $$\|z_n\| < 2$$ or $$n$$ exceeds 255.  For each point in the complex region, print the real and imaginary component, and the number of iteration $$n$$.  Use the value $$c = -0.622772 + 0.42193\\i$$.  This time, however, implement an elemental function that takes a complex number as input, and outputs the number of iterations.  Apply the function to a matrix of complex number representing the square region.


## Question 3

For the logistic map you've been computing in week 1, write an elemental function that takes an $$x_0$$, $$r$$ value as well as the number of iterations as an argument, and use this to perform the computation on appropriately initialized arrays representing $$x_+0$$ and $$r$$ values.

You can find more information on the logistic map and its applications on [Wikipedia](https://en.wikipedia.org/wiki/Logistic_map).


## Question 4

The Towers of Hanoi is a cute problem: you have to move a stack of disks from one position to another, using an auxiliary position.  All disks have different sizes, and you can never stack a larger disk on a smaller one.  You can only move a single disk at the time, and that should be at the top of a stack, and placed on top of another stack.  Consider a recursive approach.

More information can be found on [Wikipedia](https://en.wikipedia.org/wiki/Tower_of_Hanoi).


## Question 5

How many disks moves would it take to solve the Towers of Hanoi if the movements were simply random (but in accordance with the rules)?  Write a program to find out.
