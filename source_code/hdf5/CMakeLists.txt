cmake_minimum_required(VERSION 3.10)

project(hdf5 LANGUAGES Fortran)

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


find_package(HDF5 REQUIRED Fortran)
add_compile_options(${HDF5_Fortran_DEFINITIONS})
include_directories(${HDF5_Fortran_INCLUDE_DIRS})

add_executable(create_h5.exe create_h5.f90)
target_link_libraries(create_h5.exe ${HDF5_Fortran_LIBRARIES})

add_executable(append_h5.exe append_h5.f90)
target_link_libraries(append_h5.exe ${HDF5_Fortran_LIBRARIES})

add_executable(compute_center_of_mass.exe compute_center_of_mass.f90)
target_link_libraries(compute_center_of_mass.exe ${HDF5_Fortran_LIBRARIES})
