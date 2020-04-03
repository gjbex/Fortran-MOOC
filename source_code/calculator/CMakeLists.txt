cmake_minimum_required(VERSION 3.0)

project(calculator LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(calculator.exe calculator.f90)

enable_testing()

add_test(NAME addition COMMAND ./calculator.exe "3.0 + 7.0")
set_tests_properties(addition
    PROPERTIES PASS_REGULAR_EXPRESSION "0\\.1000000E\\+02")

add_test(NAME substraction COMMAND ./calculator.exe "3.0 - 7.0")
set_tests_properties(substraction
    PROPERTIES PASS_REGULAR_EXPRESSION "-0\\.4000000E\\+01")

add_test(NAME multiplication COMMAND ./calculator.exe "3.0 * 7.0")
set_tests_properties(multiplication
    PROPERTIES PASS_REGULAR_EXPRESSION "0\\.2100000E\\+02")
