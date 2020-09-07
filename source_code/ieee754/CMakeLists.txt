cmake_minimum_required(VERSION 3.0)

project(ieee754 LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(zero_vs_non_zero.exe zero_vs_non_zero.f90)
add_executable(infinity.exe infinity.f90)
add_executable(nans.exe nans.f90)
add_executable(ieee_inquiries.exe ieee_inquiries.f90)
add_executable(next_up.exe next_up.f90)
add_executable(trap_exceptions.exe infinity.f90)
target_compile_options(trap_exceptions.exe PRIVATE -ffpe-trap=invalid,zero,overflow)
add_executable(trap_underflow.exe next_up.f90)
target_compile_options(trap_exceptions.exe PRIVATE -ffpe-trap=underflow)
add_executable(exceptions.exe exceptions.f90)
add_executable(logistic_map.exe logistic_map.f90)
add_executable(logistic_map_fpe_trap.exe logistic_map.f90)
target_compile_options(logistic_map_fpe_trap.exe PRIVATE -ffpe-trap=invalid,zero,overflow)
