cmake_minimum_required(VERSION 3.9)

project(openmp LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

find_package(MPI REQUIRED)
add_executable(compute_pi.exe compute_pi.f90)
target_link_libraries(compute_pi.exe PUBLIC MPI::MPI_Fortran)
