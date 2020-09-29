cmake_minimum_required(VERSION 3.0)

project(blas_lapack LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(no_blas_probabilities.exe no_blas_probabilities.f90)
