# Numerical Integration

## Trapezoidal rule

Often, the need arises for integrating a function that has no explicit antiderivative or one which is difficult to obtain.

One commonly used technique is the Trapezoidal rule, which computes the integral using trapezoids, instead of rectangles. 
[Trapezoidal rule](https://en.wikipedia.org/wiki/Trapezoidal_rule).

 ![Trapezoidal_rule](trapezoidal_rule.png)
 
The formula for calculating the definite integral of a function f using the trapezoidal rule is given as:
$$\int_a^b f(x) = \frac{h}{2}(f(x_0)+f(x_1))-\frac{h^3}{12}f^{''}(\varepsilon)$$

​Notice that if the second derivative of f is zero the exact result is obtained; that is for polynomials of degree 1 or less.

## Exercise 1

Make a program that computes the definite integral using the trapezoidal rule disregarding the error term.

Using the program calculate the following integrals and compare with the exact value:

1) $$\int_0^2 x^2$$

2) $$\int_0^2 sin(x)$$

