cmake_minimum_required(VERSION 3.0)

project(statistics LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_subdirectory(dtio)
add_subdirectory(type_bound_procedures)
add_subdirectory(inheritance)
add_subdirectory(overloading)
add_subdirectory(select_class)
