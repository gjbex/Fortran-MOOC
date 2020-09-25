cmake_minimum_required(VERSION 3.3)

project(coarrays LANGUAGES Fortran)
# cmake_policy(CMP0057 NEW)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-warn all -diag-enable=remark)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
find_package(Coarray REQUIRED)

add_executable(coarrays.exe coarrays.f90)
target_compile_options(coarrays.exe PRIVATE ${Coarray_COMPILE_OPTIONS})
target_link_libraries(coarrays.exe ${Coarray_LIBRARIES})

add_executable(compute_pi.exe compute_pi.f90)
target_compile_options(compute_pi.exe PRIVATE ${Coarray_COMPILE_OPTIONS})
target_link_libraries(compute_pi.exe ${Coarray_LIBRARIES})
