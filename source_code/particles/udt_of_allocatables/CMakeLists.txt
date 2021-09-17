cmake_minimum_required(VERSION 3.0)

project(particles LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
    add_compile_options(-Wall -Wextra -mcmodel=large)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
    add_compile_options(-warn all -diag-enable remark -mcmodel=large)
else()
    message(WARMING "unknown compiler iD ${CMAKE_Fortran_COMPILER_ID}")
endif()


add_executable(particle_array_allocatable.exe particle_array.f90 particle_array_mod.f90)
