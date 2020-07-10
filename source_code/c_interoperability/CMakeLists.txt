cmake_minimum_required(VERSION 3.0)

project(c_interoperability LANGUAGES Fortran C)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(use_c_funcs.exe use_c_funcs.f90 functions.c)
