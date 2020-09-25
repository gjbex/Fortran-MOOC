cmake_minimum_required(VERSION 3.0)

project(coarrays LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
find_package(Coarray REQUIRED)

add_executable(coarrays.exe coarrays.f90)
target_compile_options(coarrays.exe PRIVATE ${Coarray_COMPILE_OPTIONS})
target_link_libraries(coarrays.exe ${Coarray_LIBRARIES})
