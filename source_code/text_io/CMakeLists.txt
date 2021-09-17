cmake_minimum_required(VERSION 3.0)

project(text_io LANGUAGES Fortran)

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


add_executable(print_test.exe print_test.f90)
add_executable(print_asterisks.exe print_asterisks.f90)
add_executable(print_integers.exe print_integers.f90)
add_executable(print_real_f.exe print_real_f.f90)
add_executable(print_real_e.exe print_real_e.f90)
add_executable(print_logicals.exe print_logicals.f90)
add_executable(print_characters.exe print_characters.f90)
add_executable(print_g.exe print_g.f90)
add_executable(print_boz.exe print_boz.f90)
add_executable(newunit_test.exe newunit_test.f90)
add_executable(append_test.exe append_test.f90)
add_executable(read_messy_data.exe read_messy_data.f90)
add_executable(read_messy_file.exe read_messy_file.f90)
