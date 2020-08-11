cmake_minimum_required(VERSION 3.0)

project(buffon_needles LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(buffon_needles.f90.exe buffon_needles.f90)
