module cellular_automata_mod
    use, intrinsic :: iso_fortran_env, only : error_unit
    implicit none

    private
        integer, parameter, public :: nr_neighbouts = 3
        type, public :: automaton_t
            integer, dimension(0:2**nr_neighbouts - 1) :: rules
            integer, dimension(:), allocatable :: cells
        end type automaton_t

        public :: init_automaton, step_automaton, print_automaton, &
                  print_rules

contains

    subroutine init_rule(rules, rule_nr)
        implicit none
        integer, dimension(0:2**nr_neighbouts - 1), intent(out) :: rules
        integer, value :: rule_nr
        integer i

        do i = lbound(rules, 1), ubound(rules, 1)
            rules(i) = mod(rule_nr, 2)
            rule_nr = rule_nr/2
        end do
    end subroutine init_rule

    function init_automaton(nr_cells, rule_nr) result(automaton)
        implicit none
        integer, value :: nr_cells, rule_nr
        type(automaton_t) :: automaton
        integer :: i, istat
        real :: r

        allocate(automaton%cells(nr_cells), stat=istat)
        if (istat /= 0) then
            write (unit=error_unit, fmt='(A)') &
                'error: can not allocate cells'
            stop 1
        end if
        do i = 1, nr_cells
            call random_number(r)
            if (r > 0.5) then
                automaton%cells(i) = 1
            else
                automaton%cells(i) = 0
            end if
        end do    
        call init_rule(automaton%rules, rule_nr)
    end function init_automaton

    function apply_rule(automaton, left, mid, right) result(new_mid)
        implicit none
        type(automaton_t), intent(in) :: automaton
        integer, intent(in) :: left, mid, right
        integer :: new_mid

        new_mid = automaton%rules(4*left + 2*mid + right)
    end function apply_rule

    subroutine step_automaton(automaton)
        implicit none
        type(automaton_t), intent(inout) :: automaton
        integer :: i, left, last_right, next_left

        left = automaton%cells(size(automaton%cells))
        last_right = automaton%cells(1)
        do i = 1, size(automaton%cells) - 1
            next_left = automaton%cells(i)
            automaton%cells(i) = apply_rule(automaton, &
                                            left, automaton%cells(i), &
                                            automaton%cells(i + 1))
            left = next_left
        end do
        automaton%cells(i) = apply_rule(automaton, &
                                        left, automaton%cells(i), &
                                        last_right)
    end subroutine step_automaton

    subroutine print_automaton(automaton)
        use, intrinsic :: iso_fortran_env, only : output_unit
        implicit none
        type(automaton_t), intent(in) :: automaton
        integer :: i
        character :: c
        
        do i = 1, size(automaton%cells)
            if (automaton%cells(i) == 1) then
                c = 'X'
            else
                c = ' '
            end if
            write (unit=output_unit, fmt='(A)', advance='no') c
        end do
        print '(A)', ''
    end subroutine print_automaton

    function convert_to_neighbourhood(idx) result(neighbours)
        implicit none
        integer, value :: idx
        character(len=3) :: neighbours
        integer :: i

        do i = nr_neighbouts, 1, -1
            if (mod(idx, 2) == 0) then
                neighbours(i:i) = '0'
            else
                neighbours(i:i) = '1'
            end if
            idx = idx/2
        end do
    end function convert_to_neighbourhood

    subroutine print_rules(automaton)
        implicit none
        type(automaton_t), intent(in) :: automaton
        integer :: i

        do i = lbound(automaton%rules, 1), ubound(automaton%rules, 1)
            print '(A3, x, I1)', convert_to_neighbourhood(i), &
               automaton%rules(i)
        end do
    end subroutine print_rules

end module cellular_automata_mod
