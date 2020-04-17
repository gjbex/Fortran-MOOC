cmake_minimum_required(VERSION 3.0)

project(type_info LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(type_info.exe type_info.f90)
add_executable(type_conversion.exe type_conversion.f90)
add_executable(sqrt2.exe sqrt2.f90)
