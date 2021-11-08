program alignment_udf
    use, intrinsic :: iso_fortran_env, only : SP => REAL32, DP => REAL64
    implicit none
    type :: seq_record
        sequence
        real(kind=SP) :: sp1
        real(kind=DP) :: dp1
        real(kind=SP) :: sp2
    end type
    type :: record
        real(kind=SP) :: sp1
        real(kind=DP) :: dp1
        real(kind=SP) :: sp2
    end type
    type(seq_record) :: sr = seq_record(3.0_SP, 5.0_DP, 7.0_SP)
    type(record) :: r = record(3.0_SP, 5.0_DP, 7.0_SP)

    print *, sr
    print *, r
end program alignment_udf
