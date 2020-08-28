cmake_minimum_required(VERSION 3.0)

project(bit_manipulation LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(create_lookup_table.exe create_lookup_table.f90)
target_compile_options(create_lookup_table.exe PRIVATE -Wno-integer-division)

add_custom_command(
    OUTPUT bitmanip_mod.f90
    COMMAND create_lookup_table.exe lookup_table.dat
    COMMAND cpp -P -I${CMAKE_CURRENT_BINARY_DIR} -o bitmanip_mod.f90 ${CMAKE_SOURCE_DIR}/bitmanip_mod.F90
    DEPENDS create_lookup_table.exe
)

add_executable(bitcount.exe bitcount.f90 ${CMAKE_CURRENT_BINARY_DIR}/bitmanip_mod.f90)
