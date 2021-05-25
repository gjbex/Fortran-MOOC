module particle_array_mod
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    implicit none

    real(kind=DP), parameter :: e_mass = 0.510999_DP, p_mass = 938.272_DP
    integer, parameter :: e_charge = -1, p_charge = +1

    type :: particles_t
        real(kind=DP), dimension(:), allocatable :: x, y, z, mass
        integer, dimension(:), allocatable :: charge
    end type particles_t

    type :: coordinates_t
        real(kind=DP) :: x, y, z
    end type coordinates_t

contains

    function init_particles(nr_particles) result(particles)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, value :: nr_particles
        type(particles_t) :: particles
        real, dimension(:), allocatable :: r
        integer :: status

        call init_coords(particles%x)
        call init_coords(particles%y)
        call init_coords(particles%z)
        allocate(particles%mass(nr_particles), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'can not allocate mass'
            stop 1
        end if
        allocate(particles%charge(nr_particles), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'can not allocate charge'
            stop 1
        end if
        allocate(r(size(particles%x)), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'can not allocate array'
            stop 1
        end if
        call random_number(r)
        where (r < 0.5)
            particles%mass = p_mass
            particles%charge = p_charge
        elsewhere
            particles%mass = e_mass
            particles%charge = e_charge
        end where
        deallocate(r)

    contains

        subroutine init_coords(coords)
            implicit none
            real(kind=DP), dimension(:), allocatable :: coords
            integer :: status

            allocate(coords(nr_particles), stat=status)
            if (status /= 0) then
                write (unit=error_unit, fmt='(A)') 'can not allocate coordinates'
                stop 1
            end if
            call random_number(coords)
            call rescale(coords)
        end subroutine init_coords

        pure subroutine rescale(coords)
            implicit none
            real(kind=DP), dimension(:), intent(inout) :: coords
            coords = 2.0_DP*coords - 1.0_DP
        end subroutine rescale

    end function init_particles

    subroutine finalize_particles(particles)
        implicit none
        type(particles_t), intent(inout) :: particles

        deallocate(particles%x)
        deallocate(particles%y)
        deallocate(particles%z)
        deallocate(particles%mass)
        deallocate(particles%charge)
    end subroutine finalize_particles

    function compute_center_of_mass(particles) result(coordinates)
        implicit none
        type(particles_t), intent(in) :: particles
        type(coordinates_t) :: coordinates
        real(kind=DP) :: total_mass

        coordinates%x = sum(particles%x)
        coordinates%y = sum(particles%y)
        coordinates%z = sum(particles%z)
        total_mass = sum(particles%mass)
        coordinates%x = coordinates%x/total_mass
        coordinates%y = coordinates%y/total_mass
        coordinates%z = coordinates%z/total_mass
    end function compute_center_of_mass

end module particle_array_mod
