cmake_minimum_required(VERSION 3.9)

project(openmp LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
    add_compile_options(-Wall -Wextra)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
    add_compile_options(-warn all -diag-enable remark)
else()
    message(WARNING "comppiler ${CMAKE_Fortran_COMPILER_ID} not supported")
endif()


find_package(OpenMP)
add_executable(compute_pi_omp.exe compute_pi.f90)
if(OpenMP_Fortran_FOUND)
    target_link_libraries(compute_pi_omp.exe PUBLIC OpenMP::OpenMP_Fortran)
endif()
