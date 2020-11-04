cmake_minimum_required(VERSION 3.0)

project(random_numbers LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(random_numbers.exe random_numbers.f90)
add_executable(reproduction.exe reproduction.f90)
add_executable(random_integers.exe random_integers.f90)
