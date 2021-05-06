cmake_minimum_required(VERSION 3.0)

project(linear_equations LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

set(BLA_VENDOR OpenBLAS)
find_package(BLAS REQUIRED)
find_package(LAPACK REQUIRED)

add_executable(solve_equations.exe solve_equations.f90 linalg_mod.f90)
target_link_libraries(solve_equations.exe PUBLIC ${BLAS_LIBRARIES} ${LAPACK_LIBRARIES})

add_executable(generate_array.exe generate_array.f90 linalg_mod.f90)
