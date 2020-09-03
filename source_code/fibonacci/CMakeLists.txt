cmake_minimum_required(VERSION 3.0)

project(fibonacci LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(fibonacci_verify.exe fibonacci_verify.f90 fib_mod.f90)
add_executable(fibonacci.exe fibonacci.f90 fib_mod.f90)
add_executable(fibonacci_skewed.exe fibonacci_skewed.f90 fib_mod.f90)
