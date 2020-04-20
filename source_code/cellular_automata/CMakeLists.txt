cmake_minimum_required(VERSION 3.0)

project(cellular_automata LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(cellular_automata.exe
    cellular_automata.f90
    cellular_automata_mod.f90)
