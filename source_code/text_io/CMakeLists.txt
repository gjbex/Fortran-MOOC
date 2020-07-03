cmake_minimum_required(VERSION 3.0)

project(text_io LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(print_test.exe print_test.f90)
add_executable(print_asterisks.exe print_asterisks.f90)
add_executable(print_integers.exe print_integers.f90)
add_executable(print_real_f.exe print_real_f.f90)
add_executable(print_real_e.exe print_real_e.f90)
