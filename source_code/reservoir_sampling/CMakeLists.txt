cmake_minimum_required(VERSION 3.0)

project(reservoir_sampling LANGUAGES Fortran)

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


add_executable(test_permutations.exe test_permutations.f90 utilities_mod.f90 hash_mod.F90)
add_executable(create_data.exe create_data.f90)
add_executable(shuffle_data.exe shuffle_data.f90)
add_executable(reservoir_sampling.exe reservoir_sampling.f90)
add_executable(optimal_reservoir_sampling.exe optimal_reservoir_sampling.f90)
