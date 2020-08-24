  ! This file should be included in a module ... end module block
  ! For example:
  ! module m_ffhash
  ! #define FFH_KEY_TYPE integer
  ! #define FFH_VAL_TYPE integer (optional)
  ! #include "ffhash_inc.f90"
  ! end module m_ffhash

  ! Special handling of strings (which can be shortened)
#ifdef FFH_KEY_IS_STRING
#define FFH_KEY_ARG character(len=*)
#else
#define FFH_KEY_ARG FFH_KEY_TYPE
#endif

#ifdef FFH_VAL_TYPE
#ifdef FFH_VAL_IS_STRING
#define FFH_VAL_ARG character(len=*)
#else
#define FFH_VAL_ARG FFH_VAL_TYPE
#endif
#endif

  private

  !> Type storing the hash table
  type, public :: ffh_t
     !> Number of buckets in hash table
     integer                    :: n_buckets       = 0
     !> Number of keys stored in hash table
     integer                    :: n_keys_stored   = 0
     !> Number of keys stored or deleted
     integer                    :: n_occupied      = 0
     !> Maximum number of occupied buckets
     integer                    :: n_occupied_max  = 0
     !> Mask to convert hash to index
     integer                    :: hash_mask       = 0
     !> Maximum load factor for the hash table
     double precision           :: max_load_factor = 0.7d0

     !> Flags indicating whether buckets are empty or deleted
     character, allocatable     :: flags(:)
     !> Keys of the hash table
     FFH_KEY_TYPE, allocatable  :: keys(:)
#ifdef FFH_VAL_TYPE
     !> Values stored for the keys
     FFH_VAL_TYPE, allocatable  :: vals(:)
#endif
   contains
     !> Get index of a key
     procedure, non_overridable :: get_index
     !> Check whether a valid key is present at index
     procedure, non_overridable :: valid_index
     !> Store a new key
     procedure, non_overridable :: store_key
     !> Delete a key
     procedure, non_overridable :: delete_key
     !> Delete a key (can perform error stop)
     procedure, non_overridable :: udelete_key
     !> Delete key at an index
     procedure, non_overridable :: delete_index
     !> Delete key at an index (can perform error stop)
     procedure, non_overridable :: udelete_index
     !> Resize the hash table
     procedure, non_overridable :: resize
     !> Reset the hash table to initial empty state
     procedure, non_overridable :: reset
#ifdef FFH_VAL_TYPE
     !> Store a key-value pair
     procedure, non_overridable :: store_value
     !> Store a key-value pair (can perform error stop)
     procedure, non_overridable :: ustore_value
     !> Get value for a key
     procedure, non_overridable :: get_value
     !> Get value for a key (can perform error stop)
     procedure, non_overridable :: uget_value
     !> Function to get value for a key (can perform error stop)
     procedure, non_overridable :: fget_value
     !> Function to get value for a key or a dummy if not found
     procedure, non_overridable :: fget_value_or
#endif
     !> Hash function
     procedure, non_overridable, nopass :: hash_function
  end type ffh_t

contains

  !> Get index corresponding to a key
  elemental pure function get_index(h, key) result(ix)
    class(ffh_t), intent(in) :: h
    FFH_KEY_ARG, intent(in)  :: key
    integer                  :: ix, i, step

    ix = -1
    i  = hash_index(h, key)

    do step = 1, h%n_buckets
       ! Exit when an empty bucket or the key is found
       if (bucket_empty(h, i)) then
          ! Key not found
          exit
       else if (h%valid_index(i) .and. keys_equal(h%keys(i), key)) then
          ! Key found
          ix = i
          exit
       else
          i = next_index(h, i, step)
       end if
    end do
  end function get_index

#ifdef FFH_VAL_TYPE
  !> Get the value corresponding to a key
  pure subroutine get_value(h, key, val, status)
    class(ffh_t), intent(in)   :: h
    FFH_KEY_ARG, intent(in)    :: key
    FFH_VAL_ARG, intent(inout) :: val
    integer, intent(out)       :: status

    status = h%get_index(key)
    if (status /= -1) val = h%vals(status)
  end subroutine get_value

  !> Get the value corresponding to a key
  subroutine uget_value(h, key, val)
    class(ffh_t), intent(in)   :: h
    FFH_KEY_ARG, intent(in)    :: key
    FFH_VAL_ARG, intent(inout) :: val
    integer                    :: status
    call get_value(h, key, val, status)
    if (status == -1) error stop "Cannot get value"
  end subroutine uget_value

  !> Get the value corresponding to a key
  function fget_value(h, key) result(val)
    class(ffh_t), intent(in) :: h
    FFH_KEY_ARG, intent(in)  :: key
    FFH_VAL_TYPE             :: val
    integer                  :: status
    call get_value(h, key, val, status)
    if (status == -1) error stop "Cannot get value"
  end function fget_value

  !> Get the value corresponding to a key
  elemental pure function fget_value_or(h, key, not_found) result(val)
    class(ffh_t), intent(in) :: h
    FFH_KEY_ARG, intent(in)  :: key
    FFH_VAL_ARG, intent(in)  :: not_found
    FFH_VAL_TYPE             :: val
    integer                  :: status
    call get_value(h, key, val, status)
    if (status == -1) val = not_found
  end function fget_value_or

  !> Store the value corresponding to a key
  pure subroutine store_value(h, key, val, ix)
    class(ffh_t), intent(inout) :: h
    FFH_KEY_ARG, intent(in)     :: key
    FFH_VAL_ARG, intent(in)     :: val
    integer, intent(out)        :: ix !< Index (or -1)

    call h%store_key(key, ix)
    if (ix /= -1) h%vals(ix) = val
  end subroutine store_value

  subroutine ustore_value(h, key, val)
    class(ffh_t), intent(inout) :: h
    FFH_KEY_ARG, intent(in)     :: key
    FFH_VAL_ARG, intent(in)     :: val
    integer                     :: ix
    call store_value(h, key, val, ix)
    if (ix == -1) error stop "Cannot store value"
  end subroutine ustore_value
#endif

  !> Store key in the table, and return index
  pure subroutine store_key(h, key, i)
    class(ffh_t), intent(inout) :: h
    FFH_KEY_ARG, intent(in)     :: key
    integer, intent(out)        :: i
    integer                     :: i_deleted, step, status

    i = -1

    if (h%n_occupied >= h%n_occupied_max) then
       if (h%n_keys_stored <= h%n_occupied_max/2) then
          ! Enough free space, but need to clean up the table
          call h%resize(h%n_buckets, status)
          if (status /= 0) return
       else
          ! Increase table size
          call h%resize(2*h%n_buckets, status)
          if (status /= 0) return
       end if
    end if

    i = hash_index(h, key)

    if (.not. bucket_empty(h, i)) then
       i_deleted = -1
       ! Skip over filled slots if they are deleted or have the wrong key. Skipping
       ! over deleted slots ensures that a key is not added twice, in case it is
       ! not at its 'first' hash index, and some keys in between have been deleted.
       do step = 1, h%n_buckets
          if (bucket_empty(h, i) .or. (.not. bucket_deleted(h, i) &
               .and. keys_equal(h%keys(i), key))) exit
          if (bucket_deleted(h, i)) i_deleted = i
          i = next_index(h, i, step)
       end do

       if (bucket_empty(h, i) .and. i_deleted /= -1) then
          ! Use deleted location. By taking the last one, the deleted sequence
          ! is shrunk from the end.
          i = i_deleted
       end if
    end if

    if (bucket_empty(h, i)) then
       h%n_occupied    = h%n_occupied + 1
       h%n_keys_stored = h%n_keys_stored + 1
       h%keys(i)       = key
       call set_bucket_filled(h, i)
    else if (bucket_deleted(h, i)) then
       h%n_keys_stored = h%n_keys_stored + 1
       h%keys(i)       = key
       call set_bucket_filled(h, i)
    end if
    ! If key is already present, do nothing

  end subroutine store_key

  !> Resize a hash table
  pure subroutine resize(h, new_n_buckets, status)
    class(ffh_t), intent(inout) :: h
    integer, intent(in)         :: new_n_buckets
    integer, intent(out)        :: status
    integer                     :: n_new, i, j, step
    type(ffh_t)                 :: hnew

    ! Make sure n_new is a power of two, and at least 4
    n_new = 4
    do while (n_new < new_n_buckets)
       n_new = 2 * n_new
    end do

    if (h%n_keys_stored >= nint(n_new * h%max_load_factor)) then
       ! Requested size is too small
       status = -1
       return
    end if

    ! Expand or shrink table
#ifdef FFH_VAL_TYPE
    allocate(hnew%flags(0:n_new-1), hnew%keys(0:n_new-1), &
         hnew%vals(0:n_new-1), stat=status)
#else
    allocate(hnew%flags(0:n_new-1), hnew%keys(0:n_new-1), stat=status)
#endif
    if (status /= 0) then
       status = -1
       return
    end if

    hnew%flags(:)        = achar(0)
    hnew%n_buckets       = n_new
    hnew%n_keys_stored   = h%n_keys_stored
    hnew%n_occupied      = h%n_keys_stored
    hnew%n_occupied_max  = nint(n_new * hnew%max_load_factor)
    hnew%hash_mask       = n_new - 1
    hnew%max_load_factor = h%max_load_factor

    do j = 0, h%n_buckets-1
       if (h%valid_index(j)) then
          ! Find a new index
          i = hash_index(hnew, h%keys(j))

          do step = 1, hnew%n_buckets
             if (bucket_empty(hnew, i)) exit
             i = next_index(hnew, i, step)
          end do
#ifdef FFH_VAL_TYPE
          hnew%vals(i) = h%vals(j)
#endif
          hnew%keys(i) = h%keys(j)
          call set_bucket_filled(hnew, i)
       end if
    end do

    h%n_buckets       = hnew%n_buckets
    h%n_keys_stored   = hnew%n_keys_stored
    h%n_occupied      = hnew%n_occupied
    h%n_occupied_max  = hnew%n_occupied_max
    h%hash_mask       = hnew%hash_mask
    h%max_load_factor = hnew%max_load_factor

    call move_alloc(hnew%flags, h%flags)
    call move_alloc(hnew%keys, h%keys)
#ifdef FFH_VAL_TYPE
    call move_alloc(hnew%vals, h%vals)
#endif

    status = 0
  end subroutine resize

  !> Delete entry for given key
  pure subroutine delete_key(h, key, status)
    class(ffh_t), intent(inout) :: h
    FFH_KEY_ARG, intent(in)     :: key
    integer, intent(out)        :: status
    integer                     :: ix

    ix = h%get_index(key)
    if (ix /= -1) then
       call set_bucket_deleted(h, ix)
       h%n_keys_stored = h%n_keys_stored - 1
       status = 0
    else
       status = -1
    end if
  end subroutine delete_key

  !> Delete entry for given key
  subroutine udelete_key(h, key)
    class(ffh_t), intent(inout) :: h
    FFH_KEY_ARG, intent(in)     :: key
    integer                     :: status
    call h%delete_key(key, status)
    if (status == -1) error stop "Cannot delete key"
  end subroutine udelete_key

  !> Delete entry at index
  pure subroutine delete_index(h, ix, status)
    class(ffh_t), intent(inout) :: h
    integer, intent(in)         :: ix
    integer, intent(out)        :: status

    if (ix < lbound(h%keys, 1) .or. ix > ubound(h%keys, 1)) then
       status = -1
    else if (.not. h%valid_index(ix)) then
       status = -1
    else
       call set_bucket_deleted(h, ix)
       h%n_keys_stored = h%n_keys_stored - 1
       status = 0
    end if
  end subroutine delete_index

  !> Delete entry at index
  subroutine udelete_index(h, ix)
    class(ffh_t), intent(inout) :: h
    integer, intent(in)         :: ix
    integer                     :: status
    call h%delete_index(ix, status)
    if (status == -1) error stop "Cannot delete key"
  end subroutine udelete_index

  !> Reset the hash table to initial empty state
  subroutine reset(h)
    class(ffh_t), intent(inout) :: h

    h%n_buckets       = 0
    h%n_keys_stored   = 0
    h%n_occupied      = 0
    h%n_occupied_max  = 0
    h%hash_mask       = 0
    h%max_load_factor = 0.7d0

    if (allocated(h%flags)) then
#ifdef FFH_VAL_TYPE
       deallocate(h%flags, h%keys, h%vals)
#else
       deallocate(h%flags, h%keys)
#endif
    end if
  end subroutine reset

  pure logical function bucket_empty(h, i)
    type(ffh_t), intent(in) :: h
    integer, intent(in)     :: i
    bucket_empty = (iand(iachar(h%flags(i)), 1) == 0)
  end function bucket_empty

  pure logical function bucket_deleted(h, i)
    type(ffh_t), intent(in) :: h
    integer, intent(in)     :: i
    bucket_deleted = (iand(iachar(h%flags(i)), 2) /= 0)
  end function bucket_deleted

  !> Check if index is used and not deleted
  pure logical function valid_index(h, i)
    class(ffh_t), intent(in) :: h
    integer, intent(in)      :: i
    valid_index = (iachar(h%flags(i)) == 1)
  end function valid_index

  pure subroutine set_bucket_filled(h, i)
    type(ffh_t), intent(inout) :: h
    integer, intent(in)        :: i
    h%flags(i) = achar(1)
  end subroutine set_bucket_filled

  pure subroutine set_bucket_deleted(h, i)
    type(ffh_t), intent(inout) :: h
    integer, intent(in)        :: i
    h%flags(i) = achar(ior(iachar(h%flags(i)), 2))
  end subroutine set_bucket_deleted

  !> Compute index for given key
  pure integer function hash_index(h, key) result(i)
    type(ffh_t), intent(in) :: h
    FFH_KEY_ARG, intent(in) :: key
    i = iand(h%hash_function(key), h%hash_mask)
  end function hash_index

  !> Compute next index inside a loop
  pure integer function next_index(h, i_prev, step)
    type(ffh_t), intent(in) :: h
    integer, intent(in)     :: i_prev
    integer, intent(in)     :: step
    next_index = iand(i_prev + step, h%hash_mask)
  end function next_index

#ifndef FFH_CUSTOM_KEYS_EQUAL
  pure logical function keys_equal(a, b)
    FFH_KEY_ARG, intent(in) :: a, b
    keys_equal = (a == b)
  end function keys_equal
#endif

#ifndef FFH_CUSTOM_HASH_FUNCTION
  pure function hash_function(key) result(hash)
    FFH_KEY_ARG, intent(in) :: key
    integer                 :: hash
    integer, parameter      :: seed = 42
#ifdef FFH_KEY_IS_STRING
    call MurmurHash3_x86_32(key, len_trim(key), seed, hash)
#else
    integer, parameter      :: n_bytes = ceiling(storage_size(key)*0.125d0)
    character(len=n_bytes)  :: buf
    call MurmurHash3_x86_32(transfer(key, buf), n_bytes, seed, hash)
#endif
  end function hash_function

  pure integer(int32) function rotl32(x, r)
    use iso_fortran_env
    integer(int32), intent(in) :: x
    integer(int8), intent(in)  :: r
    rotl32 = ior(shiftl(x, r), shiftr(x, (32 - r)))
  end function rotl32

  pure integer(int64) function rotl64(x, r)
    use iso_fortran_env
    integer(int64), intent(in) :: x
    integer(int8), intent(in)  :: r
    rotl64 = ior(shiftl(x, r), shiftr(x, (64 - r)))
  end function rotl64

  ! Finalization mix - force all bits of a hash block to avalanche
  pure integer(int32) function fmix32(h_in) result(h)
    use iso_fortran_env
    integer(int32), intent(in) :: h_in
    h = h_in
    h = ieor(h, shiftr(h, 16))
    h = h * (-2048144789) !0x85ebca6b
    h = ieor(h, shiftr(h, 13))
    h = h * (-1028477387) !0xc2b2ae35
    h = ieor(h, shiftr(h, 16))
  end function fmix32

  pure subroutine MurmurHash3_x86_32(key, klen, seed, hash)
    use iso_fortran_env
    integer, intent(in)             :: klen
    character(len=klen), intent(in) :: key
    integer(int32), intent(in)      :: seed
    integer(int32), intent(out)     :: hash
    integer                         :: i, i0, n, nblocks
    integer(int32)                  :: h1, k1
    integer(int32), parameter       :: c1        = -862048943 ! 0xcc9e2d51
    integer(int32), parameter       :: c2        = 461845907  !0x1b873593
    integer, parameter              :: shifts(3) = [0, 8, 16]

    h1      = seed
    nblocks = shiftr(klen, 2)    ! nblocks/4

    ! body
    do i = 1, nblocks
       k1 = transfer(key(i*4-3:i*4), k1)

       k1 = k1 * c1
       k1 = rotl32(k1,15_int8)
       k1 = k1 * c2

       h1 = ieor(h1, k1)
       h1 = rotl32(h1,13_int8)
       h1 = h1 * 5 - 430675100  ! 0xe6546b64
    end do

    ! tail
    k1 = 0
    i  = iand(klen, 3)
    i0 = 4 * nblocks

    do n = i, 1, -1
       k1 = ieor(k1, shiftl(iachar(key(i0+n:i0+n)), shifts(n)))
    end do

    ! Check if the above loop was executed
    if (i >= 1) then
       k1 = k1 * c1
       k1 = rotl32(k1,15_int8)
       k1 = k1 * c2
       h1 = ieor(h1, k1)
    end if

    ! finalization
    h1 = ieor(h1, klen)
    h1 = fmix32(h1)
    hash = h1
  end subroutine MurmurHash3_x86_32
#endif

  ! So that this file can be included multiple times
#undef FFH_KEY_TYPE
#undef FFH_KEY_ARG
#undef FFH_KEY_IS_STRING
#undef FFH_VAL_TYPE
#undef FFH_VAL_ARG
#undef FFH_VAL_IS_STRING
#undef FFH_CUSTOM_HASH_FUNCTION
#undef FFH_CUSTOM_KEYS_EQUAL
