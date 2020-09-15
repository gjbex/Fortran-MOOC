# Interfaces

Some implementations of quadrature methods to illustrate using innterfaces.

## What is it?

1. `types_mod.f90`: module that defines real type kinds.
1. `quad_func_interface_mod.f90`: module that defines the interface of
   functions to compute the quadrature of.
1. `quad_mod.f90`: over-simplified implementation of a quadrature method
   to illustrate that functions can be passed as arguments to functions.
1. `CMakeLists.txt`: CMake file to build the applications.
