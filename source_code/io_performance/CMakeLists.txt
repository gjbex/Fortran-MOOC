cmake_minimum_required(VERSION 3.0)

project(io_performance LANGUAGES Fortran C)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_subdirectory(sequential)
add_subdirectory(streaming)
add_subdirectory(asynchronous)