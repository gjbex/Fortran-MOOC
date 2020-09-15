module quad_submod_mod
    implicit none

    private
    public :: quad
    
    interface
        module function quad(f, a, b) result(q_f)
            use :: types_mod, only : DP
            use :: quad_func_interface_mod
            implicit none
            procedure(quad_func_t) :: f
            real(kind=DP), intent(in) :: a, b
            real(kind=DP) :: q_f
        end function quad
    end interface

end module quad_submod_mod

