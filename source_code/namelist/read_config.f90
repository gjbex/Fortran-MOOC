program read_config
    use, intrinsic :: iso_fortran_env, dp => REAL64
    implicit none
    integer :: nr_rows, nr_cols
    real(kind=dp)  :: delta_t
    character(len=1024) :: file_name = 'config_nml.txt'

    call parse_command_line(file_name)
    call read_config_file(file_name, nr_rows, nr_cols, delta_t)

    print '(A)', "Configuration read successfully:"
    print '(A,I0)', "Number of rows: ", nr_rows
    print '(A,I0)', "Number of columns: ", nr_cols
    print '(A,F15.10)', "Time step (delta_t): ", delta_t

contains

    subroutine read_config_file(file_name, nr_rows, nr_cols, delta_t)
        use, intrinsic :: iso_fortran_env, only : dp => REAL64, error_unit
        implicit none
        character(len=*), intent(in) :: file_name
        integer, intent(out) :: nr_rows, nr_cols
        real(kind=dp), intent(out) :: delta_t
        integer :: ios, unit_nr
        namelist /config/ nr_rows, nr_cols, delta_t

        open(newunit=unit_nr, file=file_name, status='old', action='read', iostat=ios)
        if (ios /= 0) then
            write(error_unit, '(A)') "Error opening file: " // trim(file_name)
            stop 2
        end if

        read(unit_nr, nml=config, iostat=ios)
        if (ios /= 0) then
            write(error_unit, '(A)') "Error reading namelist from file: " // trim(file_name)
            stop 3
        end if

        close(unit_nr)
    end subroutine read_config_file

    subroutine parse_command_line(file_name)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        character(len=*), intent(inout) :: file_name

        if (command_argument_count() > 0) then
            call get_command_argument(1, file_name)
            if (len_trim(file_name) == 0) then
                write(error_unit, '(A)') 'No configuration file specified. Using default: "config.txt"'
                file_name = 'config_nml.txt'
            else
                write(error_unit, '(A)') 'Using specified configuration file: "' // trim(file_name) // '"'
            end if
        else
            write(*, '(A)') 'Using default configuration file: "' // trim(file_name) // '"'
        end if

    end subroutine parse_command_line

end program read_config
