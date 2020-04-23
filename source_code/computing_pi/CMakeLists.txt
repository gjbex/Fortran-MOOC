cmake_minimum_required(VERSION 3.0)

project(computing_pi LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(compute_pi.exe compute_pi.f90)

add_executable(compute_pi_omp.exe compute_pi_omp.f90)
target_compile_options(compute_pi_omp.exe PUBLIC -fopenmp)
target_link_options(compute_pi_omp.exe PUBLIC -fopenmp)
