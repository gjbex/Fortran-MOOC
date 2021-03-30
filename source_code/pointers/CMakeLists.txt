cmake_minimum_required(VERSION 3.0)

project(pointers LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(kernel.exe kernel.f90)
add_executable(swap_ptrs.exe swap.f90)
add_executable(associations.exe associations.f90)
add_executable(slices.exe slices.f90)
add_executable(benchmark.exe benchmark.f90)
add_executable(pointer_to_allocatable.exe pointer_to_allocatable.f90)
