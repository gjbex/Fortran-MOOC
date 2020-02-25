cmake_minimum_required(VERSION 3.0)

project(julia_set LANGUAGES Fortran)

add_compile_options(-Wall -Wextra)

add_executable(julia_set.exe julia_set_mod.f90 julia_set.f90)
