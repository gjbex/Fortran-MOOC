module map_mod
    implicit none

    private

    public :: random_integer

    type, public :: map_t
        private
        logical, dimension(:, :), allocatable :: coords
        integer, dimension(:, :), allocatable :: candidates
        integer :: nr_taken, nr_candiates
    contains
        procedure, public, pass :: is_taken, get_nr_taken, get_nr_candidates, &
                                   take_site, print_taken, print_candidates, &
                                   get_hairiness
        procedure, private, pass :: add_site, add_candidate, select_candiate, &
                                    remove_candidates
        final :: destroy_map
    end type map_t

    interface map_t
        procedure :: create_map
    end interface map_t

contains

    function create_map(n) result(map)
        use, intrinsic :: iso_fortran_env, only : error_unit
        implicit none
        integer, value :: n
        type(map_t) :: map
        integer :: side, status

        side = 2*int(sqrt(real(n)))
        allocate (map%coords(-side:side, -side:side), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') 'error: can not allocate map'
            stop 1
        end if
        allocate (map%candidates(2, 4*n), stat=status)
        if (status /= 0) then
            write (unit=error_unit, fmt='(A)') &
                'error: can not allocate candiates'
            stop 1
        end if
        map%coords = .false.
        map%nr_taken = 0
        map%nr_candiates = 0
        call map%add_site(0, 0)
    end function create_map

    subroutine destroy_map(this)
        implicit none
        type(map_t), intent(inout) :: this

        if (allocated(this%coords)) deallocate (this%coords)
        if (allocated(this%candidates)) deallocate (this%candidates)
    end subroutine destroy_map

    real function get_hairiness(this)
        implicit none
        class(map_t), intent(in) :: this

        get_hairiness = real(this%get_nr_candidates())/real(this%get_nr_taken())
    end function get_hairiness

    subroutine take_site(this)
        implicit none
        class(map_t), intent(inout) :: this
        integer, dimension(2) :: site

        site = this%select_candiate()
        call this%add_site(site(1), site(2))
    end subroutine take_site

    subroutine add_candidate(this, x, y)
        implicit none
        class(map_t), intent(inout) :: this
        integer, value :: x, y

        this%nr_candiates = this%nr_candiates + 1
        this%candidates(1, this%nr_candiates) = x
        this%candidates(2, this%nr_candiates) = y
    end subroutine add_candidate
    
    subroutine add_site(this, x, y)
        implicit none
        class(map_t), intent(inout) :: this
        integer, value :: x, y

        if (.not. this%is_taken(x, y)) then
            this%coords(x, y) = .true.
            this%nr_taken = this%nr_taken + 1
        end if
        if (.not. this%is_taken(x - 1, y)) call this%add_candidate(x - 1, y)
        if (.not. this%is_taken(x + 1, y)) call this%add_candidate(x + 1, y)
        if (.not. this%is_taken(x, y - 1)) call this%add_candidate(x, y - 1)
        if (.not. this%is_taken(x, y + 1)) call this%add_candidate(x, y + 1)
    end subroutine add_site

    logical function is_taken(this, x, y)
        implicit none
        class(map_t), intent(in) :: this
        integer, value :: x, y

        is_taken = this%coords(x, y)
    end function is_taken

    integer function get_nr_taken(this)
        implicit none
        class(map_t), intent(in) :: this

        get_nr_taken = this%nr_taken
    end function get_nr_taken

    integer function get_nr_candidates(this)
        implicit none
        class(map_t), intent(in) :: this

        get_nr_candidates = this%nr_candiates
    end function get_nr_candidates

    integer function random_integer(n)
        implicit none
        integer, value :: n
        real :: r

        call random_number(r)
        random_integer = 1 + int(r*n)
    end function random_integer

    subroutine remove_candidates(this, selected)
        implicit none
        class(map_t), intent(inout) :: this
        integer, dimension(2), intent(in) :: selected
        integer :: i

        i = 1
        do while (i < this%nr_candiates)
            if (selected(1) == this%candidates(1, i) .and. &
                selected(2) == this%candidates(2, i)) then
                this%candidates(1, i) = this%candidates(1, this%nr_candiates)
                this%candidates(2, i) = this%candidates(2, this%nr_candiates)
                this%nr_candiates = this%nr_candiates - 1
            end if
            i = i + 1
        end do
    end subroutine remove_candidates

    function select_candiate(this) result(selected)
        implicit none
        class(map_t), intent(inout) :: this
        integer, dimension(2) :: selected
        integer :: idx

        idx = random_integer(this%get_nr_candidates())
        selected(1) = this%candidates(1, idx)
        selected(2) = this%candidates(2, idx)
        call this%remove_candidates(selected)
    end function select_candiate

    subroutine print_taken(this)
        use, intrinsic :: iso_fortran_env, only : output_unit
        implicit none
        class(map_t), intent(in) :: this
        integer :: i, j

        write (unit=output_unit, fmt='(A1)', advance='no') '+'
        do j = lbound(this%coords, 2), ubound(this%coords, 2)
            write (unit=output_unit, fmt='(A1)', advance='no') '-'
        end do
        write (unit=output_unit, fmt='(A1)') '+'
        do i = lbound(this%coords, 1), ubound(this%coords, 1)
            write (unit=output_unit, fmt='(A1)', advance='no') '|'
            do j = lbound(this%coords, 2), ubound(this%coords, 2)
                if (this%coords(i, j)) then
                    write (unit=output_unit, fmt='(A1)', advance='no') 'x'
                else
                    write (unit=output_unit, fmt='(A1)', advance='no') ' '
                end if
            end do
            write (unit=output_unit, fmt='(A)') '|'
        end do
        write (unit=output_unit, fmt='(A1)', advance='no') '+'
        do j = lbound(this%coords, 2), ubound(this%coords, 2)
            write (unit=output_unit, fmt='(A1)', advance='no') '-'
        end do
        write (unit=output_unit, fmt='(A1)') '+'
    end subroutine print_taken

    subroutine print_candidates(this)
        use, intrinsic :: iso_fortran_env, only : output_unit
        implicit none
        class(map_t), intent(in) :: this
        integer :: i

        do i = 1, this%get_nr_candidates()
            print '(2I4)', this%candidates(:, i)
        end do
    end subroutine print_candidates

end module map_mod
