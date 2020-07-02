submodule(quad_submod_mod) quad_impl_mod
    implicit none
contains

    module procedure quad
        use :: types_mod, only : DP
        implicit none
        q_f = 0.5_DP*(f(b) + f(a))*(b - a)
    end procedure quad

end submodule quad_impl_mod
