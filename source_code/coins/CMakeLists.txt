cmake_minimum_required(VERSION 3.0)

project(coins LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(change.exe
    greedy_coins_mod.f90 dyn_prog_coins_mod.f90 change.f90)
