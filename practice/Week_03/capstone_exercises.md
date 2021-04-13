# Capstone exercises

## Question 1

Consider a data stream, real numbers coming in one by one via standard input.
You are interested in the evolution of the mean value and standard deviation
over the last $$N$$ values.  The application reads data from standard input,
and as soon as it has read $$N$$ values, it starts writing the average of the
last $$N$$ values to standard output.
Create a user defined type to keep track of the data window and use type-bound
procedures to implement the functionality..


## Question 2

Extend the application of the previous exercise to work on multiple window
sizes $$N_1$$, $$N_2$$, ... specified via the command line.  The output is
written to standard output, one column per value $$N_i$$.


## Question 3

The Sierpinski triangle is an example of a fractal.  There are several
algorithms to construct it, but the "chaos game" is rather neat.  You will
find a [description on Wikipedia](https://en.wikipedia.org/wiki/Sierpi%C5%84ski_triangle#Chaos_game).
Implement an application that writes the positions of the points to
standard output.  Make a plot using your favorite visualization application.


## Question 4

The Sierpinski triangle you computed in the previous exercise is a fractal.
Such geometrical object are characterized by a fractal dimension, the Hausdorff
dimension.  This can be determined analytically for the Sierpinski triangle,
but it can also be determined numerically by box counting.  See [Wikipedia for
a description](https://en.wikipedia.org/wiki/Box_counting).
Write an application that reads the output of the program you developed to
create the Sierpinski triangle and applies box counting to determine an
estimate for the Hausdorff dimension.  Compare your result to the theoretical
value.


## Question 5

Create a user defined type to represent a [binary tree](https://en.wikipedia.org/wiki/Binary_tree).  
The nodes in the tree have real values that represent the distance from the
parent node.  The root of the tree will have the value 0.  Write a program to
generate a random tree of a given depth.
Experiment with different ways of representing the tree as text (written to
standard output).


## Question 6

Write a program that reconstructs a binary tree from the output of the previous
exercise, and computes the length of all the paths from the root to leaf nodes,
i.e., nodes that don't have child nodes.  Write the results to standard output.
