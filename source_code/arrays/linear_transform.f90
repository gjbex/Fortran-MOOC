program linear_transform
    implicit none
    real, dimension(5) :: values

    call random_number(values)
    print *, values
    print *, lin_transform(values, 2.0, 1.0)

contains

    elemental real function lin_transform(x, a, b)
        implicit none
        real, intent(in) :: x, a, b

        lin_transform = a*x + b
    end function lin_transform

end program linear_transform
