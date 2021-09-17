cmake_minimum_required(VERSION 3.0)

project(blas95 LANGUAGES Fortran C)

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


set(BLA_F95 ON)
set(BLA_VENDOR Intel10_64lp)
find_package(BLAS)

if (BLAS_FOUND)
    add_executable(dot_blas95.exe dot_blas95.f90)
    target_link_libraries(dot_blas95.exe PUBLIC ${BLAS95_LIBRARIES})
    target_compile_options(dot_blas95.exe PUBLIC ${BLAS_LINKER_FLAGS})
else()
    message(STATUS "BLAS95 interface not supported, ignoring project blas95")
endif()
