cmake_minimum_required(VERSION 3.0)

project(logistic_map LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(logistic_map.exe logistic_map.f90)
add_executable(logistic_map_2.exe logistic_map_2.f90 meshgrid_mod.f90)
add_executable(logistic_function.exe logistic_function.f90)
