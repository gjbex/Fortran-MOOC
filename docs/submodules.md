# Submodules

Suppose a module defines a procedure that is used in many compilation units.
If the implementation of the procedure is modified, the module itself, but
also all compilation units that depend on it will be recompiled, which can be
an issue when working with large code bases.

That recompilation is unnecessary when the procedure's interface is unchanged,
and this can be achieved using submodules.  The module itself declares the
procedure's interface, while the submodule defines the implementation.  When
the implementation is changed, only the submodule is recompiled.

A second argument for using submodules is that it makes your code easier to
maintain.  The strict separation between the interface and the implementation
ensures that when an interface change is required, it only has to be done
in a single location.

Consider again the example of computing quadratures.  Since there are many
quadrature methods, you would create many functions to create them, all
defined in the module `quad_mod`.

~~~~fortran
module quad_mod
    implicit none

    private
    public :: quad_gauss, quad_simpson

    interface
        function quad_gauss(f, a, b) result(q_f)
            use :: quad_func_interface_mod
            implicit none
            procedure(quad_func_t) :: f
            real, value :: a, b
            real :: q_f
        end function quad_gauss
    end interface
    
    interface
        function quad_simpson(f, a, b) result(q_f)
            use :: quad_func_interface_mod
            implicit none
            procedure(quad_func_t) :: f
            real, value :: a, b
            real :: q_f
        end function quad_simpson
    end interface

contains

    function quad_gauss(f, a, b) result(q_f)
        use :: types_mod, only : DP
        use :: quad_func_interface_mod
        implicit none
        procedure(quad_func_t) :: f
        real(kind=DP), intent(in) :: a, b
        real(kind=DP) :: q_f
        ...
    end function quad_gauss
        
    function quad_simpson(f, a, b) result(q_f)
        use :: types_mod, only : DP
        use :: quad_func_interface_mod
        implicit none
        procedure(quad_func_t) :: f
        real(kind=DP), intent(in) :: a, b
        real(kind=DP) :: q_f
        ...
    end function quad_simpson

end module quad_mod
~~~~

A code change in `quad_gauss` would force a recompilation of all compilation
units in the module.  For this particular example, there are only two, but
there might be many, in which case compilation would potentially take a long
time.

You can address this problem using submodules.  The interface declaration
remains in the module `quad_mod`, but the implementation is put into separate
submodules, each in their own file.

~~~~fortran
module quad_mod
    implicit none

    private
    public :: quad
    
    interface
        module function quad_gauss(f, a, b) result(q_f)
            use :: quad_func_interface_mod
            implicit none
            procedure(quad_func_t) :: f
            real, intent(in) :: a, b
            real :: q_f
        end function quad_gauss
    end interface

    interface
        module function quad_gauss(f, a, b) result(q_f)
            use :: quad_func_interface_mod
            implicit none
            procedure(quad_func_t) :: f
            real, intent(in) :: a, b
            real :: q_f
        end function quad_gauss
    end interface

end module quad_submod_mod
~~~~

The implementations are defined in the submodules `quad_gauss_smod` and
`quad_simpson_smod`.  The former is shown below.

~~~~fortran
submodule(quad_mod) quad_gauss_smod
    implicit none
contains

    module procedure quad_gauss
        implicit none
        ...
    end procedure quad_gauss

end submodule(quad_mod) quad_gauss_smod
~~~~

Note that the interface of the function `quad_gauss` is not repeated
in the submodule.  Also, changing the implementation of `quad_gauss` will
cause the file that contains it to be recompiled, but the files that contain
the implementations of other functions.

Of course, creating a submodule for each individual function is likely
overkill, since the sheer number of files would make project maintenance
unwieldy.  A proper balance has to be struck.

