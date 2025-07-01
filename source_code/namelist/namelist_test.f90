program namelist_test
    implicit none
    
    integer :: i
    real :: x
    character(len=20) :: name
    logical :: flag
    
    namelist /test_nml/ i, x, name, flag
    
    ! Initialize variables
    i = 42
    x = 3.14
    name = 'Fortran'
    flag = .true.
    
    ! Write the namelist to a file
    open(unit=10, file='test_nml.txt', status='replace')
    write(10, nml=test_nml)
    close(10)
    
    ! Read the namelist from the file
    open(unit=20, file='test_nml.txt', status='old')
    read(20, nml=test_nml)
    close(20)
    
    ! Print the values to verify they were read correctly
    print *, 'i = ', i
    print *, 'x = ', x
    print *, 'name = ', trim(name)
    print *, 'flag = ', flag
end program namelist_test
