cmake_minimum_required(VERSION 3.0)

project(ieee754 LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(zero_vs_non_zero.exe zero_vs_non_zero.f90)
add_executable(infinity.exe infinity.f90)
add_executable(nans.exe nans.f90)
add_executable(ieee_inquiries.exe ieee_inquiries.f90)
