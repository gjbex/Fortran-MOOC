module quad_gauss_mod
    use :: quad_mod
    implicit none

    private
    type, public, abstract, extends(quad_t) :: quad_gauss_t
        private
        real, dimension(:), allocatable :: abscissae, weights
    contains
        procedure :: compute => compute_gauss
        procedure(init_quad_t), pass, deferred :: init_quad
        procedure :: set_abscissae, set_weights
    end type

    abstract interface
        module subroutine init_quad_t(this)
            ! import :: quad_gauss_t
            implicit none
            class(quad_gauss_t), intent(inout) :: this
        end subroutine init_quad_t
    end interface

contains

    function compute_gauss(this, func, a, b) result(res)
        implicit none
        class(quad_gauss_t), intent(in) :: this
        procedure(func_t) :: func
        real, value :: a, b
        real :: res
        integer :: i

        res = 0.0
        associate (x => this%abscissae, w => this%weights)
            do i = 1, size(x)
                res = res + 0.5*(b - a)*w(i)*func(0.5*((b - a)*x(i) + a + b))
            end do
        end associate
    end function compute_gauss
        
    subroutine set_abscissae(this, abscissae)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        class(quad_gauss_t), intent(inout) :: this
        real, dimension(:), intent(in) :: abscissae
        integer :: istat

        allocate(this%abscissae, source=abscissae, stat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate abscissae'
            stop 1
        end if
    end subroutine set_abscissae

    subroutine set_weights(this, weights)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        class(quad_gauss_t), intent(inout) :: this
        real, dimension(:), intent(in) :: weights
        integer :: istat

        allocate(this%weights, source=weights, stat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate weights'
            stop 1
        end if
    end subroutine set_weights

end module quad_gauss_mod
