cmake_minimum_required(VERSION 3.0)

project(iterations LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
    add_compile_options(-Wall -Wextra)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
    add_compile_options(-warn all -diag-enable remark)
else()
    message(WARNING "comppiler ${CMAKE_Fortran_COMPILER_ID} not supported")
endif()


add_executable(do_factorials.exe do_factorials.f90)
add_executable(messing_up.exe messing_up.f90)
add_executable(verify_do_loop.exe verify_do_loop.f90)
add_executable(zero_step.exe zero_step.f90)
