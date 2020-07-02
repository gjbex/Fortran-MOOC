cmake_minimum_required(VERSION 3.0)

project(quadrature LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(quad.exe
    quad_test.f90 quad_func_interface_mod.f90 quad_mod.f90 types_mod.f90)

add_executable(submod_quad.exe
    quad_submod_test.f90 quad_func_interface_mod.f90 quad_submod_mod.f90
    quad_impl_mod.f90 types_mod.f90
)
