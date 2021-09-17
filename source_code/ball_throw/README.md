# Ball throw

Application that solves the set of ordinary differential equations for a ball trhow
(the ball is a point, there is no friction).

## What is it?

1. `ball_throw.F90`: main program that illustrates `exit` and preprocessor macros.
1. `rk4.f90`: Runge-Kutta 4 solver (implemented by John Burkardt).
1. `CMakeLists.txt`: CMake file to build the application.
1. `plot_trajectory.sh`: plot the output of the program using gnuplot.

Note: the compiler will generate a warning about unused dummy argument `t` in subroutine
`rhs`. That argument is required by the API, but since the equations don't
explicitely depend on time, the argument is not used.
