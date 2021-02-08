cmake_minimum_required(VERSION 3.0)

project(f2py LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(matrix_test.exe matrix_test.f90 matrix_mod.f90)
