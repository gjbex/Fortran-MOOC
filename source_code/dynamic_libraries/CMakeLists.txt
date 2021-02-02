cmake_minimum_required(VERSION 3.0)

project(dynamic_libraries LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(dynamic_library.exe
    dynamic_library_mod.f90 build_load.f90)
target_link_libraries(dynamic_library.exe ${CMAKE_DL_LIBS})
