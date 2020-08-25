cmake_minimum_required(VERSION 3.0)

project(linked_list LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_subdirectory(linked_real_list)
add_subdirectory(linked_real_list_error_handling)
add_subdirectory(generic_linked_list)
