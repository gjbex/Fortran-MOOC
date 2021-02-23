# Capstone exercises week 1

## Question 1

The logistic map is defined as an iteration:
$$
x_{n + 1} = r x_n (1 - x_n)
$$
The iteration is started for an initial value $$0 \le x_0 \le 1$$ and $$0 \le r \le 4$$.  You can find more information on the logistic map and its applications on [Wikipedia](https://en.wikipedia.org/wiki/Logistic_map).

Write a program that for given values of $$x_0$$, $$r$$ and number of iterations prints the number of the iteration $$n$$ and the value of $$x_n$$ to standard output.  Run the application for a number of times for different values of $$x_0$$ and $$r$$, compare the behavior for $$r = 0.5, 1.5, 2.5, 3.3, 3.52, 3.55$$.  Create plots using your favorite plotting program.


## Question 2

Write a program that generates the data for a plot that shows the values of $$x_n$$ on the $$y$$-axis and $$r$$ on the $$x$$-axis for the logistic map as in the previous question.  The aim is to obtain a plot similar this [this one](https://en.wikipedia.org/wiki/Logistic_map#/media/File:Logistic_Bifurcation_map_High_Resolution.png).


## Question 3

Consider a square region in the complex plain such that $$\\real(z) \le 2$$ and $$\\imag(z) \le 2$$.  For each point $$z_0$$, compute the following iterations $$z_{n+1} = z_n^2 + c$$ such that $$\|z_n\| < 2$$ or $$n$$ exceeds 255.  For each point in the complex region, print the real and imaginary component, and the number of iteration $$n$$.  Use the value $$c = -0.622772 + 0.42193\\i$$.

Visualize the data as a heat map using your favorite plotting software.  You have just computed a Julia set, [Wikipedia](https://en.wikipedia.org/wiki/Julia_set) provides more information if you are interested.


## Question 4

Write a function that computes the greatest  common divisor of two positive integers.  You can implement [Euclid's algorithm](https://en.wikipedia.org/wiki/Euclidean_algorithm).


## Question 5

The Fibonacci numbers are defined as $$f_n = f_{n-1} + f_{n-2}$$ with $$f_0 = 0$$, $$f_1 = 1$$ and $$n > 1$$.  This is a recursive definition, find a non-recursive implementation.

For more information on Fibonacci numbers, you can have a look at the [Wikipedia article](https://en.wikipedia.org/wiki/Fibonacci_number) on the subject.
