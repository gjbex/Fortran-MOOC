cmake_minimum_required(VERSION 3.0)

project(ball_throw LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(ball_throw.exe ball_throw.F90 rk4.f90)
