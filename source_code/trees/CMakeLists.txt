cmake_minimum_required(VERSION 3.0)

project(tress LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(tree_test.exe tree_test.f90
    node_mod.f90 random_mod.f90)
add_executable(avg_path_test.exe avg_path_test.f90
    node_mod.f90 random_mod.f90)
add_executable(id_tree_test.exe id_tree_test.f90
    id_node_mod.f90 node_mod.f90 random_mod.f90)
