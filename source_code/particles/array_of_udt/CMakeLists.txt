cmake_minimum_required(VERSION 3.0)

project(particles LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra -mcmodel=large)

add_executable(particles.exe
    particles.f90 particles_mod.f90)
