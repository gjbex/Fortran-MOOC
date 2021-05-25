add_executable(unformatted_stream_write.exe unformatted_write.f90)
target_compile_options(unformatted_write.exe PRIVATE ${Fortran_FLAGS})

add_executable(unformatted_stream_read.exe unformatted_read.f90)
target_compile_options(unformatted_read.exe PRIVATE ${Fortran_FLAGS})

add_executable(convert_c.exe convert.c)
target_compile_options(convert_c.exe PRIVATE ${C_FLAGS})
