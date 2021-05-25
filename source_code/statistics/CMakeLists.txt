cmake_minimum_required(VERSION 3.0)

project(statistics LANGUAGES Fortran)

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


add_executable(descriptive_statistics.exe descriptive_statistics.f90 stats_mod.f90)

add_executable(median_statistics.exe
    median_statistics.f90 median_stats_mod.f90 quicksort_mod.f90)

add_executable(quicksort_test.exe quicksort_test.f90 quicksort_mod.f90)

add_executable(median.exe median.f90 quicksort_mod.f90)

add_executable(dynamic_array_test.exe dynamic_array_test.f90 dynamic_arrays_mod.f90)
