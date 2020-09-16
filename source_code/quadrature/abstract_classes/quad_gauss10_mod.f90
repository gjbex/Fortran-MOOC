module quad_gauss10_mod
    use :: quad_gauss_mod
    implicit none

    private
    type, public, extends(quad_gauss_t) :: quad_gauss10_t
    contains
        procedure :: init_quad => init_quad10
    end type

    interface quad_gauss10_t
        module procedure :: create_quad
    end interface

contains

    function create_quad() result(quad)
        implicit none
        type(quad_gauss10_t) :: quad
        call quad%init_quad()
    end function create_quad

    subroutine init_quad10(this)
        implicit none
        class(quad_gauss10_t), intent(inout) :: this

        call this%set_abscissae([ &
            -0.1488743389816312,  &
             0.1488743389816312,  &
            -0.4333953941292472,  &
             0.4333953941292472,  &
            -0.6794095682990244,  &
             0.6794095682990244,  &
            -0.8650633666889845,  &
             0.8650633666889845,  &
            -0.9739065285171717,  &
             0.9739065285171717   &
        ])

        call this%set_weights([ &
            0.2955242247147529, &
            0.2955242247147529, &
            0.2692667193099963, &
            0.2692667193099963, &
            0.2190863625159820, &
            0.2190863625159820, &
            0.1494513491505806, &
            0.1494513491505806, &
            0.0666713443086881, &
            0.0666713443086881  &   
        ])
    end subroutine init_quad10

end module quad_gauss10_mod

