module particle_array_mod
    use, intrinsic :: iso_fortran_env, only : DP => REAL64, error_unit
    implicit none

    real(kind=DP), parameter :: e_mass = 0.510999_DP, p_mass = 938.272_DP
    integer, parameter :: e_charge = -1, p_charge = +1

    type :: particles_t(nr_particles)
        integer, len :: nr_particles
        real(kind=DP), dimension(nr_particles) :: x, y, z, mass
        integer, dimension(nr_particles) :: charge
    end type particles_t

    type :: coordinates_t
        real(kind=DP) :: x, y, z
    end type coordinates_t

contains

    subroutine init_particles(particles)
        implicit none
        type(particles_t(*)) :: particles
        real, dimension(:), allocatable :: r

        call random_number(particles%x)
        call rescale(particles%x)
        call random_number(particles%y)
        call rescale(particles%y)
        call random_number(particles%x)
        call rescale(particles%x)
        allocate(r(size(particles%x)))
        if (.not. allocated(r)) then
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

        pure subroutine rescale(coords)
            implicit none
            real(kind=DP), dimension(:), intent(inout) :: coords
            coords = 2.0_DP*coords - 1.0_DP
        end subroutine rescale

    end subroutine init_particles

    function compute_center_of_mass(particles) result(coordinates)
        implicit none
        type(particles_t(*)), intent(in) :: particles
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
