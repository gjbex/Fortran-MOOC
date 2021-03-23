cmake_minimum_required(VERSION 3.0)

project(arrays LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(array_elements.exe array_elements.f90)
add_executable(array_initialization.exe array_initialization.f90)
add_executable(array_arithmetic.exe array_arithmetic.f90)
add_executable(subarrays.exe subarrays.f90)
add_executable(matrix.exe matrix.f90)
add_executable(submatrices.exe submatrices.f90)
add_executable(max_array.exe max_array.f90)
add_executable(trace.exe trace.f90)
add_executable(compute_factorial.exe compute_factorial.f90)
add_executable(linear_transform.exe linear_transform.f90)
add_executable(identity.exe identity.f90)
add_executable(array_timings.exe array_timings.f90)
add_executable(normalize.exe normalize.f90)
add_executable(normalize_performance.exe normalize_performance.f90)
add_executable(allocate_from_source.exe allocate_from_source.f90)
add_executable(large_arrays.exe large_arrays.f90)
