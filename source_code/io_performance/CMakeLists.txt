cmake_minimum_required(VERSION 3.0)

project(io_performance LANGUAGES Fortran C)

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})

if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
    list(APPEND CMAKE_Fortran_FLAGS -Wall)
    list(APPEND CMAKE_Fortran_FLAGS -Wextra)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
    list(APPEND CMAKE_Fortran_FLAGS "-warn all")
    list(APPEND CMAKE_Fortran_FLAGS "-warn all -diag-enable remark")
else()
    message(WARNING "unknown compiler ID")
endif()

list(APPEND CMAKE_C_FLAGS -Wall)
list(APPEND CMAKE_C_FLAGS -Wextra)

add_subdirectory(sequential)
add_subdirectory(streaming)
add_subdirectory(asynchronous)
