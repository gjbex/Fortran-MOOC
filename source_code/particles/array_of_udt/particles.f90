program particles_program
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    use :: particles_mod, only : particle_t, coordinates_t, &
        init_particle, compute_center_of_mass
    implicit none
    integer, parameter :: nr_particles = 1000000
    type(particle_t), dimension(nr_particles) :: particles
    type(coordinates_t) :: center_of_mass
    integer :: i

    ! initialize particles
    do i = 1, size(particles)
        call init_particle(particles(i))
    end do

    ! compute center of mass, and print the coordinates
    center_of_mass = compute_center_of_mass(particles)
    print '(A, E10.3, 2(", ", E10.3))', 'center of mass = ', &
        center_of_mass%x, center_of_mass%y, center_of_mass%z

end program particles_program
