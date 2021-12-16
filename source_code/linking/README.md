# Linking

Sometimes it is important to do optimizations at link time.  This code and build process
illustrates some of the options.

## What is it?

1. `functions_mod.f90` and `functions_mod_copy.f90`: module defining two
   function `f1` and `f2`.
1. `main_all.f90` and `main_all_copy.f90`: file containing the program
   compilation that doesn't use `f2` but uses the `function_mod` module without
   restrictions.
1. `main_only.f90` and `main_only_copy.f90`: file containing the program
   compilation that doesn't use `f2` but restricts the use of the
  `function_mod` module to `f1`.
1. `CMakeLists.txt`: CMake file to build the applications.

Note: copies of the files are required to ensure that the source files
are compiled with the appropriate compilation flags.  To only link in
functions that are used, the source code needs to be compiled with
the `-ffunction-sections` and `-fdata-sections` flags.  The option
`--gc-sections` has to be passed to the linker, using `-Wl,--gc-sections`
when the linker is invoked though the compiler wrapper.

The size of the executables can be inspected, and it can be verified
using `nm` that the code for the unused function has been optimized
away if the linker was instructed to do so.
