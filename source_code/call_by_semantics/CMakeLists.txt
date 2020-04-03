cmake_minimum_required(VERSION 3.0)

project(call_by_semantics LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(call_by_reference.exe call_by_reference.f90)
add_executable(call_by_value.exe call_by_value.f90)
add_executable(call_by_in_reference.exe call_by_in_reference.f90)
