cmake_minimum_required(VERSION 3.0)

project(blas_lapack LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

add_compile_options(-Wall -Wextra)

add_executable(no_blas_probabilities.exe no_blas_probabilities.f90 init_mod.f90)

set(BLA_VENDOR OpenBLAS)
find_package(BLAS REQUIRED)

add_executable(blas_probabilities.exe blas_probabilities.f90 init_mod.f90)
target_link_libraries(blas_probabilities.exe PUBLIC ${BLAS_LIBRARIES})

add_executable(normalize.exe normalize.f90)
target_link_libraries(normalize.exe PUBLIC ${BLAS_LIBRARIES})

add_executable(copy.exe copy.f90)
target_link_libraries(copy.exe PUBLIC ${BLAS_LIBRARIES})

add_executable(dot.exe dot.f90)
target_link_libraries(dot.exe PUBLIC ${BLAS_LIBRARIES})

add_executable(ddot_timing.exe ddot_timing.f90)
target_link_libraries(ddot_timing.exe PUBLIC ${BLAS_LIBRARIES})

add_executable(gemv.exe gemv.f90 util_mod.f90)
target_link_libraries(gemv.exe PUBLIC ${BLAS_LIBRARIES})

add_executable(gemv_vs_trmv.exe gemv_vs_trmv.f90)
target_link_libraries(gemv_vs_trmv.exe PUBLIC ${BLAS_LIBRARIES})

add_executable(syr.exe syr.f90 util_mod.f90)
target_link_libraries(syr.exe PUBLIC ${BLAS_LIBRARIES})
