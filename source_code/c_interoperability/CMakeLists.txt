cmake_minimum_required(VERSION 3.0)

project(c_interoperability LANGUAGES Fortran C)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

set(C_FLAGS)
list(APPEND C_FLAGS -Wall -Wextra)

set(Fortran_FLAGS)
if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
    list(APPEND Fortran_FLAGS -Wall -Wextra)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
    list(APPEND Fortran_FLAGS -warn all -diag-enable remark)
else()
    message(WARNING "comppiler ${CMAKE_Fortran_COMPILER_ID} not supported")
endif()

add_library(c_functions functions.c)
target_compile_options(c_functions PRIVATE ${C_FLAGS})

add_executable(use_c_funcs.exe use_c_funcs.f90)
target_link_libraries(use_c_funcs.exe PRIVATE c_functions)
target_compile_options(use_c_funcs.exe PRIVATE ${Fortran_FLAGS})

add_library(fortran_functions functions_mod.f90)
target_compile_options(fortran_functions PRIVATE ${Fortran_FLAGS})

add_executable(use_fortran_funcs.exe use_fortran_funcs.c)
target_link_libraries(use_fortran_funcs.exe fortran_functions)
target_compile_options(use_fortran_funcs.exe PRIVATE ${C_FLAGS})

# this project depends on GSL, find it.  Libraries will be in GSL::gsl and
# GSL::gslcblas
find_package(GSL REQUIRED)
if (NOT GSL_FOUND)
    message(FATAL_ERROR "GSL is required, but not found")
endif (NOT GSL_FOUND)

add_executable(gsl_sort.exe gsl_sort.f90)
target_link_libraries(gsl_sort.exe GSL::gsl GSL::gslcblas)
target_compile_options(gsl_sort.exe PRIVATE ${Fortran_FLAGS})

add_executable(gsl_quad.exe gsl_quad.f90 functions_mod.f90)
target_link_libraries(gsl_quad.exe GSL::gsl GSL::gslcblas)
target_compile_options(gsl_quad.exe PRIVATE ${Fortran_FLAGS})
