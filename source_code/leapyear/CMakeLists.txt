cmake_minimum_required(VERSION 3.0)

project(leapyear LANGUAGES Fortran)

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


add_executable(leapyear.exe leapyear.f90)

enable_testing()

add_test(NAME no_leap_year COMMAND ./leapyear.exe 1973)
set_tests_properties(no_leap_year
    PROPERTIES PASS_REGULAR_EXPRESSION "is not a")

add_test(NAME leap_year COMMAND ./leapyear.exe 1972)
set_tests_properties(leap_year
    PROPERTIES PASS_REGULAR_EXPRESSION "is a")

add_test(NAME century COMMAND ./leapyear.exe 1900)
set_tests_properties(century
    PROPERTIES PASS_REGULAR_EXPRESSION "is not a")

add_test(NAME four_centuries COMMAND ./leapyear.exe 2400)
set_tests_properties(four_centuries
    PROPERTIES PASS_REGULAR_EXPRESSION "is a")
