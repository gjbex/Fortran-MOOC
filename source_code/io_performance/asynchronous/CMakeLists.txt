add_executable(generate_random_sync.exe generate_random_sync.f90)
target_compile_options(generate_random_sync.exe PRIVATE ${Fortran_FLAGS})

add_executable(generate_random_async.exe generate_random_async.f90)
target_compile_options(generate_random_async.exe PRIVATE ${Fortran_FLAGS})
