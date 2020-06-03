program particle_array_program
    use, intrinsic :: iso_fortran_env, only : DP => REAL64
    use :: particle_array_mod, only : particles_t, coordinates_t, &
        init_particles, compute_center_of_mass, finalize_particles
    implicit none
    integer, parameter :: nr_particles = 1000000
    type(particles_t) :: particles
    type(coordinates_t) :: center_of_mass

    ! initialize particles
    particles = init_particles(nr_particles)

    ! compute center of mass, and print the coordinates
    center_of_mass = compute_center_of_mass(particles)
    print '(A, E10.3, 2(", ", E10.3))', 'center of mass = ', &
        center_of_mass%x, center_of_mass%y, center_of_mass%z
    
    ! deallocate memory
    call finalize_particles(particles)

end program particle_array_program
