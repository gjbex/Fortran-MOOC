program neighbours
    use :: map_mod
    implicit none
    type(map_t) :: map
    integer :: nr_sites, site_nr
    logical :: is_verbose

    call get_arguments(nr_sites, is_verbose)
    map = map_t(nr_sites)
    if (is_verbose) then
        call map%print_taken()
        call map%print_candidates()
    end if
    print '(I8, F8.4)', 1, map%get_hairiness()
    do site_nr = 2, nr_sites
        call map%take_site()
        if (is_verbose) then
            call map%print_taken()
            call map%print_candidates()
        end if
        print '(I8, F8.4)', site_nr, map%get_hairiness()
    end do

contains

    subroutine get_arguments(nr_sites, is_verbose)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, intent(out) :: nr_sites
        logical, intent(out) :: is_verbose
        character(len=1024) :: buffer, msg
        integer :: status

        nr_sites = 20
        is_verbose = .true.
        if (command_argument_count() >= 1) then
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iomsg=msg, iostat=status) nr_sites
            if (status /= 0) then
                write (unit=error_unit, fmt='(2A)') 'error: ', msg
                stop 1
            end if
        end if
        if (command_argument_count() >= 2) then
            call get_command_argument(2, buffer)
            if (buffer == '.false.') is_verbose = .false.
        end if
    end subroutine get_arguments

end program neighbours
