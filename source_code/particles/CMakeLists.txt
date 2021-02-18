cmake_minimum_required(VERSION 3.0)

project(particles)

add_subdirectory(array_of_udt)
if (CMAKE_Fortran_COMPILER_ID EQUAL 'Intel')
    add_subdirectory(udt_of_arrays)
endif()
add_subdirectory(udt_of_allocatables)
