cmake_minimum_required(VERSION 3.0)

project(strings LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(palindromes.exe palindromes.f90)
add_executable(str_assignment.exe str_assignment.f90)
