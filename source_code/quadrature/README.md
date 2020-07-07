# Quadrature

Some implementations of quadrature methods to illustrate various concepts.

## What is it?

1. `types_mod.f90`: module that defines real type kinds.
1. `quad_func_interface_mod.f90`: module that defines the interface of
   functions to compute the quadrature of.
1. `quad_mod.f90`: over-simplified implementation of a quadrature method
   to illustrate that functions can be passed as arguments to functions.
1. `quad_test.f90`: program to illustrate the `quad` function.
1. `quad_submod_mod.f90`: implementation illustrating submodules.  This
   module only contains the interface.
1. `quad_impl_mod.f90`: implementation of the interface.
1. `quad_submod_test.f90`: program to test the submodule implementation.
1. `CMakeLists.txt`: CMake file to build the applications.