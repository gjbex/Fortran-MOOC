cmake_minimum_required(VERSION 3.0)

project(io_performance LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(formatted_write.exe formatted_write.f90)
add_executable(formatted_read.exe formatted_read.f90)
add_executable(unformatted_write.exe unformatted_write.f90)
add_executable(unformatted_read.exe unformatted_read.f90)
add_executable(convert.exe convert.f90)
add_executable(compute_distance.exe compute_distance.f90)
