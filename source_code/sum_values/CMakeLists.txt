cmake_minimum_required(VERSION 3.0)

project(sum_values LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(sum_values.exe sum_values.f90)
add_executable(sum_values_no_infinite.exe sum_values_no_infinite.f90)
