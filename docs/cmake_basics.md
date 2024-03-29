# The basics of CMake

Building software is a fairly tedious process, and you should take care that it
is done correctly and reproducible.  This is especially important for large code
bases, but even for small projects, it saves a lot of time and headache when you
do it right.

[CMake](https://cmake.org/) is a build tool that is cross-platform and versatile.
Here, you will get some basic information on CMake and how to use it to build
Fortran programs, but there is much more to learn.


## Single source file

CMake uses recipes to build software, i.e,. `CMakeLists.txt` files.  Suppose you
want to build the "hello Fortran" example code.  In the same directory as the
source file `hello_fortran.f90`, create a file `CMakeLists.txt` with the following
contents.

~~~~
cmake_minimum_required(VERSION 3.0)

project(fortran_basics LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(hello_fortran.exe hello_fortran.f90)
~~~~

* Line 1 specifies the minimum version of CMake to use, 3.0 in this case.
* Line 3 specifies the name of the project `fortran_basics` and the programming
  languages for this projects `Fortran`.
* Line 5 to 7 make sure that the `*.mod` files that are generated by the compiler
  are stored in the build directory.
* Line 9 specifies some additional options for the compiler, in this case `-Wall`
  and `-Wextra` to generate additional warnings about suspicious code.
* Line 11 defines the actual build, it specifies to compile `hello_world.f90` into
  an executable named `hello_fortran.exe`.

When building software, CMake will create a lot of artifacts that pollute your source
directory, so it is good practice to do the build in a dedicated subdirectory.

~~~~bash
$ mkdir build; cd build
~~~~

Before you can do your first build, CMake has to generate a number of files and
directories based on the `CMakeLists.txt` file in your source directory.  This is
done with the `cmake` command.

~~~~bash
$ cmake ..
~~~~

The argument of the `cmake` command is a directory where the relevant `CMakeLists.txt`
file is located, in this case `..` the parent directory of the build directory.

Now you are ready to build the executable.

~~~~bash
$ make
~~~~

In case you get compilation or linking errors, correct them.  If the build process
succeeded without errors, you can run the executable.

~~~~bash
$ ./hello_fortran.exe
~~~~


## Multiple source files

Suppose that your application is implemented using multiple source files, i.e.,
some modules are stored in their own files. CMake can handle this very easily,
you just have to specify the dependency.  For example, the following specification
would use the files `cellular_automata.f90` as well as `cellular_automata_mod.f90`
to build the application `cellular_automata.exe`.

~~~~
add_executable(cellular_automata.exe
    cellular_automata.f90
    cellular_automata_mod.f90)
~~~~


## Other features

CMake has many more features exceeding the scope of this introduction.  Some of them
are illustrated in the examples.

Functional testing can be done using CTest, and building Doxygen documentation is
also easily integrated into `CMakeLists.txt`.
