program cellular_automata
    use :: cellular_automata_mod
    implicit none
    integer :: nr_cells, rule_nr, max_steps
    type(automaton_t) :: automaton
    integer :: step

    call get_parameters(rule_nr, nr_cells, max_steps)
    automaton = init_automaton(nr_cells, rule_nr)
    call print_rules(automaton)
    call print_automaton(automaton)
    do step = 1, max_steps
        call step_automaton(automaton)
        call print_automaton(automaton)
    end do

contains

    subroutine get_parameters(rule_nr, nr_cells, max_steps)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, intent(out) :: rule_nr, nr_cells, max_steps
        integer :: istat
        character(len=1024) :: buffer, msg

        rule_nr = 163
        nr_cells = 20
        max_steps = 30

        if (command_argument_count() > 0) then
            call get_command_argument(1, buffer)
            read (buffer, fmt=*, iostat=istat, iomsg=msg) rule_nr
            if (istat /= 0) then
                print '(2A)', 'error: ', msg
                stop 1
            end if
        end if
        if (command_argument_count() > 1) then
            call get_command_argument(2, buffer)
            read (buffer, fmt=*, iostat=istat, iomsg=msg) nr_cells
            if (istat /= 0) then
                print '(2A)', 'error: ', msg
                stop 1
            end if
        end if
        if (command_argument_count() > 2) then
            call get_command_argument(3, buffer)
            read (buffer, fmt=*, iostat=istat, iomsg=msg) max_steps
            if (istat /= 0) then
                print '(2A)', 'error: ', msg
                stop 1
            end if
        end if
    end subroutine get_parameters

end program cellular_automata
