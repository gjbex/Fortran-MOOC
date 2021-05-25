cmake_minimum_required(VERSION 3.0)

project(io_performance LANGUAGES Fortran C)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

set(Fortan_FLAGS)
if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
    list(APPEND Fortran_FLAGS -Wall)
    list(APPEND Fortran_FLAGS -Wextra)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
    list(APPEND Fortran_FLAGS "-warn all")
    list(APPEND Fortran_FLAGS "all -diag-enable remark")
else()
    message(WARNING "unknown compiler ID")
endif()

set(C_FLAGS)
list(APPEND C_FLAGS -Wall)
list(APPEND C_FLAGS -Wextra)

add_subdirectory(sequential)
add_subdirectory(streaming)
add_subdirectory(asynchronous)
