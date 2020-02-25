cmake_minimum_required(VERSION 3.0)

project(julia_set LANGUAGES Fortran)

add_compile_options(-Wall -Wextra)

add_executable(julia_set.exe julia_set_mod.f90 julia_set.f90)

add_executable(julia_set_omp.exe
    julia_set_mod.f90 julia_set_omp_mod.f90 julia_set_omp.f90
)
target_compile_options(julia_set_omp.exe PUBLIC -fopenmp)
target_link_options(julia_set_omp.exe PUBLIC -fopenmp)
