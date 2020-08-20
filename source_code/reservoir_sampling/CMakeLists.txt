cmake_minimum_required(VERSION 3.0)

project(reservoir_sampling LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(test_permutations.exe test_permutations.f90 utilities_mod.f90)
add_executable(create_data.exe create_data.f90)
add_executable(shuffle_data.exe shuffle_data.f90)
add_executable(reservoir_sampling..exe reservioir_sampling.f90)
