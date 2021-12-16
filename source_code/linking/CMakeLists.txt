cmake_minimum_required(VERSION 3.0)

project(linking LANGUAGES Fortran)

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


add_executable(linking_all.exe functions_mod.f90 main_all.f90)
add_executable(linking_only.exe functions_mod.f90 main_only.f90)

set_source_files_properties(functions_mod_copy.f90 main_all_copy.f90 main_only_copy.f90 PROPERTIES
    COMPILE_FLAGS -fdata-sections)
set_source_files_properties(functions_mod_copy.f90 main_all_copy.f90 main_only_copy.f90 PROPERTIES
    COMPILE_FLAGS -ffunction-sections)

add_executable(linking_all_gc.exe functions_mod_copy.f90 main_all_copy.f90)
target_link_options(linking_all_gc.exe PUBLIC -Wl,--gc-sections)

add_executable(linking_only_gc.exe functions_mod_copy.f90 main_only_copy.f90)
target_link_options(linking_only_gc.exe PUBLIC -Wl,--gc-sections)
