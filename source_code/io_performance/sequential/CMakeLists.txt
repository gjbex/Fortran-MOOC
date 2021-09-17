add_executable(formatted_write.exe formatted_write.f90)
target_compile_options(formatted_write.exe PRIVATE ${Fortran_FLAGS})

add_executable(formatted_read.exe formatted_read.f90)
target_compile_options(formatted_read.exe PRIVATE ${Fortran_FLAGS})

add_executable(unformatted_write.exe unformatted_write.f90)
target_compile_options(unformatted_write.exe PRIVATE ${Fortran_FLAGS})

add_executable(unformatted_read.exe unformatted_read.f90)
target_compile_options(unformatted_read.exe PRIVATE ${Fortran_FLAGS})

add_executable(convert.exe convert.f90)
target_compile_options(convert.exe PRIVATE ${Fortran_FLAGS})

add_executable(compute_distance.exe compute_distance.f90)
target_compile_options(compute_distance.exe PRIVATE ${Fortran_FLAGS})
