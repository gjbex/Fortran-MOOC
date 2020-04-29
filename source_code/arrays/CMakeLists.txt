cmake_minimum_required(VERSION 3.0)

project(arrays LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(array_elements.exe array_elements.f90)
add_executable(array_initialization.exe array_initialization.f90)
add_executable(array_arithmetic.exe array_arithmetic.f90)
add_executable(subarrays.exe subarrays.f90)
add_executable(matrix.exe matrix.f90)
