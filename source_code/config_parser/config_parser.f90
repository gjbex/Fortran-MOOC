program config_parser
    use, intrinsic :: iso_fortran_env, only : error_unit, DP => REAL64
    implicit none
    character(len=1024) :: file_name
    type :: config_t
        character(len=1024) :: method
        integer :: nr_iters
        real(kind=DP) :: precision
    end type config_t
    type(config_t) :: config

    ! get file name from command line
    if (command_argument_count() /= 1) then
        write (unit=error_unit, fmt='(A)') &
            'error: expecting config filename as argument'
        stop 1
    end if
    call get_command_argument(1, file_name)

    call init_config(config)
    call read_config(file_name, config)

    print "('method = ', A)", trim(config%method)
    print "('nr_iters = ', I0)", config%nr_iters
    print "('precision = ', E26.15)", config%precision

contains

    subroutine init_config(config)
        implicit none
        type(config_t), intent(out) :: config

        config%method = 'none'
        config%nr_iters = 0
        config%precision = 1.0D-10
    end subroutine init_config

    subroutine read_config(file_name, config)
        use, intrinsic :: iso_fortran_env, only : error_unit, iostat_end
        implicit none
        character(len=*), intent(in) :: file_name
        type(config_t), intent(inout) :: config
        integer, parameter :: file_unit = 20
        character(len=1024) :: msg, line, name, val
        integer :: istat

        open (unit=file_unit, file=file_name, access='stream', &
              status='old', form='formatted', action='read', &
              iomsg=msg, iostat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(2A)') &
                'error: ', msg
            stop 2
        end if

        do
            read (unit=file_unit, fmt='(A)', iostat=istat) line
            if (istat == iostat_end) exit
            line = adjustl(line)
            if (line(1:1) == '#') cycle
            call split_line(line, name, val, istat)
            if (istat /= 0) then
                write (unit=error_unit, fmt='(2A)') &
                    'warning: illegal config line ', trim(line)
                cycle
            end if
            if (name == 'method') then
                config%method = trim(val)
            else if (name == 'nr_iters') then
                read (val, fmt=*, iostat=istat, iomsg=msg) config%nr_iters
                if (istat /= 0) then
                    write (unit=error_unit, fmt='(2A)') &
                        'I/O error in conifg for nr_iters: ', trim(msg)
                    stop 4
                end if
            else if (name == 'precision') then
                read (val, fmt=*, iostat=istat, iomsg=msg) config%precision
                if (istat /= 0) then
                    write (unit=error_unit, fmt='(2A)') &
                        'I/O error in conifg for precision: ', trim(msg)
                    stop 4
                end if
            else
                write (unit=error_unit, fmt='(3A)') &
                    "error in config: '", trim(name), "' is not a parameter"
                stop 4
            end if
        end do

        close(unit=file_unit)
    end subroutine read_config

    subroutine split_line(line, name, val, stat)
        implicit none
        character(len=*), intent(in) :: line
        character(len=*), intent(out) :: name, val
        integer, intent(out) :: stat
        integer :: pos

        pos = index(line, '=')
        if (pos == 0) then
            stat = 1
        end if
        name = line(:pos-1)
        val = adjustl(line(pos+1:))
        stat = 0
    end subroutine split_line

    subroutine print_config(config)
        implicit none
        type(config_t), intent(in) :: config

        print "('method = ', A)", trim(config%method)
        print "('nr_iters = ', I0)", config%nr_iters
        print "('precision = ', E26.15)", config%precision
    end subroutine print_config

end program config_parser
