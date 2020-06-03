module particles_mod
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    implicit none

    real(kind=DP), parameter :: e_mass = 0.510999_DP, p_mass = 938.272_DP
    integer, parameter :: e_charge = -1, p_charge = +1

    type :: coordinates_t
        real(kind=DP) :: x, y, z
    end type coordinates_t

    type :: particle_t
        type(coordinates_t) :: coords
        real(kind=DP) :: mass
        integer :: charge
    end type particle_t

contains

    subroutine init_particle(particle)
        implicit none
        type(particle_t), intent(out) :: particle
        real :: r

        particle%coords%x = random_coord()
        particle%coords%y = random_coord()
        particle%coords%z = random_coord()
        call random_number(r)
        if (r < 0.5) then
            particle%mass = e_mass
            particle%charge = e_charge
        else
            particle%mass = p_mass
            particle%charge = p_charge
        end if

    contains

        function random_coord() result(coord)
            implicit none
            real(kind=DP) :: coord

            call random_number(coord)
            coord = 2.0_DP*coord - 1.0_DP
        end function random_coord

    end subroutine init_particle

    function compute_center_of_mass(particles) result(coordinates)
        implicit none
        class(particle_t), dimension(:), intent(in) :: particles
        type(coordinates_t) :: coordinates
        real(kind=DP) :: total_mass
        integer :: i

        coordinates%x = 0.0_DP
        coordinates%y = 0.0_DP
        coordinates%z = 0.0_DP
        total_mass = 0.0_DP
        do i = 1, size(particles)
            associate(particle => particles(i))
                coordinates%x = coordinates%x + particle%mass*particle%coords%x
                coordinates%y = coordinates%y + particle%mass*particle%coords%y
                coordinates%z = coordinates%z + particle%mass*particle%coords%z
                total_mass = total_mass + particle%mass
            end associate
        end do
        coordinates%x = coordinates%x/total_mass
        coordinates%y = coordinates%y/total_mass
        coordinates%z = coordinates%z/total_mass
    end function compute_center_of_mass

    function distance(p1, p2) result(dist)
        implicit none
        type(particle_t), intent(in) :: p1, p2
        real(kind=DP) :: dist
        integer :: i

        associate(c1 => p1%coords, c2 => p2%coords)
            dist = sqrt((c1%x - c2%x)**2 + (c1%y - c2%y)**2 + (c1%z - c2%z)**2)
        end associate
    end function distance

    subroutine print_particle(particle)
        implicit none
        type(particle_t), intent(in) :: particle

        associate(c => particle%coords)
            print '("coordinates = ", F10.3, 2(", ", F10.3))', c%x, c%y, c%z
        end associate
        print '("mass = ", F10.3)', particle%mass
        print '("charge = ", I0)', particle%charge
    end subroutine print_particle

end module particles_mod
