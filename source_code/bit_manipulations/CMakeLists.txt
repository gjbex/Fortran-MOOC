cmake_minimum_required(VERSION 3.0)

project(bit_manipulation LANGUAGES Fortran)

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


add_executable(create_lookup_table.exe create_lookup_table.f90)
target_compile_options(create_lookup_table.exe PRIVATE -Wno-integer-division)

add_custom_command(
    OUTPUT bitmanip_mod.f90
    COMMAND create_lookup_table.exe lookup_table.dat
    COMMAND cpp -P -I${CMAKE_CURRENT_BINARY_DIR} -o bitmanip_mod.f90 ${CMAKE_CURRENT_SOURCE_DIR}/bitmanip_mod.F90
    DEPENDS create_lookup_table.exe
)

add_executable(bitcount.exe bitcount.f90 ${CMAKE_CURRENT_BINARY_DIR}/bitmanip_mod.f90)

add_executable(bit_operations.exe
    bit_operations.f90
    ${CMAKE_CURRENT_BINARY_DIR}/bitmanip_mod.f90)
