cmake_minimum_required(VERSION 3.0)

project(c_interoperability LANGUAGES Fortran C)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(use_c_funcs.exe use_c_funcs.f90 functions.c)

# this project depends on GSL, find it.  Libraries will be in GSL::gsl and
# GSL::gslcblas
find_package(GSL REQUIRED)
if (NOT GSL_FOUND)
    message(FATAL_ERROR "GSL is required, but not found")
endif (NOT GSL_FOUND)

add_executable(gsl_sort.exe gsl_sort.f90)
target_link_libraries(gsl_sort.exe GSL::gsl GSL::gslcblas)

add_executable(gsl_quad.exe gsl_quad.f90 functions_mod.f90)
target_link_libraries(gsl_quad.exe GSL::gsl GSL::gslcblas)
