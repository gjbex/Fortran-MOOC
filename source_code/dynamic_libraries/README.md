# Dynamic library

This illustrates how to compile a shared library from a Fortran program and load
the dynamic library at runtime and executes a procedure.


## What is it?

1. `dynamic_library_mod.f90`: module that defines procedures to compile the code and
   build a shared library, opening, loading procedures and closing a dynamic library.
1. `build_load.f90`: main program that uses the module.
1. `functions..f90`: module containing procedures to dynamically load.
1. `CMakeLists.txt`: CMake file to build the applications.
