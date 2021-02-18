cmake_minimum_required(VERSION 3.0)

project(particles LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra -mcmodel=large)

add_executable(particle_array_allocatable.exe particle_array.f90 particle_array_mod.f90)
