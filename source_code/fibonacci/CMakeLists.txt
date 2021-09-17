cmake_minimum_required(VERSION 3.0)

project(fibonacci LANGUAGES Fortran)

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


add_executable(fibonacci_verify.exe fibonacci_verify.f90 fib_mod.f90)
add_executable(fibonacci.exe fibonacci.f90 fib_mod.f90)
add_executable(fibonacci_skewed.exe fibonacci_skewed.f90 fib_mod.f90)
