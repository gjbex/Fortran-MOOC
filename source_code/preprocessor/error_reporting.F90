program error_reporting
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none

    call horrible_things_happen()

contains

    subroutine horrible_things_happen()
        implicit none

        write (unit=error_unit, fmt='(3A, I0)') &
            'horrible things happen in ', __FILE__, ':', __LINE__
        stop
    end subroutine horrible_things_happen

end program error_reporting
