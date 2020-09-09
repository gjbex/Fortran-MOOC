program associations
    implicit none
    integer, target :: a = 3, b = 5
    integer, pointer :: p

    call print_associated(p, str='uninitialized')

    p => null()
    call print_associated(p, str='associated with null()')

    p => a
    call print_associated(p, str='associated after association with a')
    call print_associated(p, v=a, str='associated to a')
    call print_associated(p, v=b, str='associated to b')

    p => b
    call print_associated(p, str='associated after association with b')
    call print_associated(p, v=a, str='associated to a')
    call print_associated(p, v=b, str='associated to b')

    nullify (p)
    call print_associated(p, str='after nullify')
    
contains

    subroutine print_associated(p, v, str)
        implicit none
        integer, pointer, intent(in) :: p
        integer, target, intent(in), optional :: v
        character(len=*), intent(in), optional :: str
        character(len=1024) :: msg

        if (.not. present(str)) then
            msg = ''
        else
            msg = str
        end if

        if (present(v)) then
            if (associated(p, v)) then
                print '(2A)', 'p associated ', trim(msg)
            else
                print '(2A)', 'p not associated ', trim(msg)
            end if
        else
            if (associated(p)) then
                print '(2A)', 'p associated ', trim(msg)
            else
                print '(2A)', 'p not associated ', trim(msg)
            end if
        end if
    end subroutine print_associated

end program associations
