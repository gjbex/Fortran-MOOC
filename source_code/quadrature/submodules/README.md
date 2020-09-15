# Quadrature

Some implementations of quadrature methods illustrating submodules.

## What is it?

1. `types_mod.f90`: module that defines real type kinds.
1. `quad_func_interface_mod.f90`: module that defines the interface of
   functions to compute the quadrature of.
1. `quad_submod_mod.f90`: implementation illustrating submodules.  This
   module only contains the interface.
1. `quad_impl_mod.f90`: implementation of the interface.
1. `quad_submod_test.f90`: program to test the submodule implementation.
1. `CMakeLists.txt`: CMake file to build the applications.
