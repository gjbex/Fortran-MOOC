cmake_minimum_required(VERSION 3.0)

project(gcd LANGUAGES Fortran)

add_compile_options(-Wall -Wextra)

add_executable(gcd.exe gcd.f90)
