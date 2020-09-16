module quad_gauss5_mod
    use :: quad_gauss_mod
    implicit none

    private
    type, public, extends(quad_gauss_t) :: quad_gauss5_t
    contains
        procedure :: init_quad => init_quad5
    end type

    interface quad_gauss5_t
        module procedure :: create_quad
    end interface

contains

    function create_quad() result(quad)
        implicit none
        type(quad_gauss5_t) :: quad
        call quad%init_quad()
    end function create_quad

    subroutine init_quad5(this)
        implicit none
        class(quad_gauss5_t), intent(inout) :: this

        call this%set_abscissae([ &
             0.0000000000000000,  &
            -0.5384693101056831,  &
             0.5384693101056831,  &
            -0.9061798459386640,  &
             0.9061798459386640   &
        ])

        call this%set_weights([ &
            0.5688888888888889, &
            0.4786286704993665, &
            0.4786286704993665, &
            0.2369268850561891, &
            0.2369268850561891  &
        ])
    end subroutine init_quad5

end module quad_gauss5_mod
