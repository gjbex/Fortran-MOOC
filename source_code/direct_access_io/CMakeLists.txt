cmake_minimum_required(VERSION 3.0)

project(direct_access_io LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(direct_formatted_write.exe direct_formatted_write.f90 format_mod.f90)
add_executable(direct_formatted_read.exe direct_formatted_read.f90 format_mod.f90)
