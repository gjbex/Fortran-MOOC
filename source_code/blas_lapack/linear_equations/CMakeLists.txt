cmake_minimum_required(VERSION 3.0)

project(linear_equations LANGUAGES Fortran)

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


set(BLA_VENDOR OpenBLAS)
find_package(BLAS REQUIRED)
find_package(LAPACK REQUIRED)


if (CMAKE_CXX_COMPILER_ID STREQUAL "Intel" OR
        (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND
         CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL "10"))
    add_executable(solve_equations.exe solve_equations.f90 linalg_mod.f90)
    target_link_libraries(solve_equations.exe PUBLIC ${BLAS_LIBRARIES} ${LAPACK_LIBRARIES})

    add_executable(generate_array.exe generate_array.f90 linalg_mod.f90)
else()
    message(STATUS "the compiler doesn't support assumed rank feature, linear_equations will not be built")
endif()
