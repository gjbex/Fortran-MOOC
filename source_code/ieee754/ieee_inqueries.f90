program ieee_inqueries
    use, intrinsic :: ieee_arithmetic
    use, intrinsic :: iso_fortran_env, only : SP => REAL32, DP => REAL64, &
        QP => REAL128
    implicit none
    character(len=20) :: fmt_str = '(A20, L5)'
    
    print fmt_str, 'REAL32', ieee_support_datatype(0.0_SP)
    print fmt_str, 'REAL64', ieee_support_datatype(0.0_DP)
    print fmt_str, 'REAL128', ieee_support_datatype(0.0_QP)
    print fmt_str, 'denormal', ieee_support_denormal()
    print fmt_str, 'divide', ieee_support_divide()
    print fmt_str, 'sqrt', ieee_support_sqrt()
    print fmt_str, 'inf', ieee_support_inf()
    print fmt_str, 'standard', ieee_support_standard()
    print fmt_str, 'underflow control', ieee_support_underflow_control()
end program ieee_inqueries
