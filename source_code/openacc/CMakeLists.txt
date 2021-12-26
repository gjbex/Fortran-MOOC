cmake_minimum_required(VERSION 3.16)

project(openacc LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY
        ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})


find_package(OpenACC REQUIRED)

add_executable(diffusion.exe diffusion.f90 diffusion_mod.f90)
target_compile_options(diffusion.exe PRIVATE ${OpenACC_Fortran_OPTIONS})
target_link_libraries(diffusion.exe PRIVATE ${OpenACC_Fortran_OPTIONS})
