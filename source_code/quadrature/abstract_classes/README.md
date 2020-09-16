# Abstract classes

Illustration of abstract classes with multiple levels.


## What is it?

1. `quad_mod.f90`: abstract class for quadrature methods.  The class declares
   a deferred procedure `compute`.
1. `quad_gauss_mod.f90`: abstract class for Legendre-Gauss quadrature methods.
   It implements `compute`, but declares a deferred procedure `init_quad`.
1. `quad_gauss5_mod.f90` and `quad_gauss10_mod.f90`: concrete classes that implement
   `init_quad`.
1. `quad_simpson_mod.f90`: concrete class that implement the `compute` method using
   Simpson's rule.
1. `test_quad.f90`: program to use the classes for quadrature.
1. `CMakeLists.txt`: CMake file to build the applications.
