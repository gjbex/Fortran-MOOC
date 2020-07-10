program environment_variables_test
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none
    character(len=10), parameter :: env_name = 'PATH'
    character(len=:), allocatable :: env_var
    integer :: istat, env_len

    ! get the length of the environment variable
    call get_environment_variable(env_name, length=env_len, status=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not determine length'
        stop 1
    end if

    ! allocate a buffer of appropriate size
    allocate(character(env_len) :: env_var, stat=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not allocate memory'
        stop 2
    end if

    ! get the actual value
    call get_environment_variable(env_name, env_var, status=istat)
    if (istat /= 0) then
        write (unit=error_unit, fmt='(A)') 'error: can not retrieve value'
        stop 3
    end if

    print '(A, ": ''", A, "''")', trim(env_name), env_var
end program environment_variables_test
