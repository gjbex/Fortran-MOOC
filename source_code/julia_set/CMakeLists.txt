cmake_minimum_required(VERSION 3.0)

project(julia_set LANGUAGES Fortran)

if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
    add_compile_options(-Wall -Wextra)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
    add_compile_options(-warn all -diag-enable remark)
else()
    message(WARNING "comppiler ${CMAKE_Fortran_COMPILER_ID} not supported")
endif()


# set directory to store .mod files
set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

# sequential implementation
add_executable(julia_set.exe
    julia_set_mod.f90 julia_set.f90)

# OpenMP implementation
add_executable(julia_set_omp.exe
    julia_set_mod.f90 julia_set_omp_mod.f90
    julia_set_omp.f90)
target_compile_options(julia_set_omp.exe PUBLIC -fopenmp)
target_link_options(julia_set_omp.exe PUBLIC -fopenmp)
