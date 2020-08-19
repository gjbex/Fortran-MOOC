module format_mod
    use, intrinsic :: iso_fortran_env, only : DP => REAL64, I4 => INT32
    implicit none

    integer, parameter :: int_width = 4, real_width = 26
    integer, parameter :: rec_width = int_width + real_width
    character(len=20) :: fmt_str = '(I4, E26.15)'

end module format_mod
