MODULE subs

implicit none

    contains

        subroutine directory
        !  subroutine defines vars to hold paths to various folders   
        !   
        !   
            use constants, only : cwd, homedir, fileplace, resdir

            implicit none

            !get current working directory

            call get_environment_variable('PWD', cwd)

            ! get 'home' dir from cwd
            homedir = trim(cwd(1:len(trim(cwd))))//'/'
            ! get data dir
            fileplace = trim(homedir)//'data/'
            ! get res dir
            resdir = trim(homedir)//'res/'

        end subroutine directory


        subroutine zarray

            use iarray

            !sets all arrays to zero
            implicit none


            jmean = 0.
            xface = 0.
            yface = 0.
            zface = 0.
            rhokap = 0.
            jmeanGLOBAL = 0.
            refrac = 0.
        end subroutine zarray


        subroutine alloc_array
        !  subroutine allocates allocatable arrays
        !   
        !   
            use iarray
            use constants,only : nxg,nyg,nzg

            implicit none

            allocate(xface(nxg+1), yface(nyg + 1), zface(nzg + 1))
            allocate(rhokap(nxg, nyg, nzg))
            allocate(jmean(nxg, nyg, nzg), jmeanGLOBAL(nxg, nyg, nzg), jmeanHeatGLOBAL(nxg,nyg,nzg), jmeanFluGLOBAL(nxg,nyg,nzg))
	    !allocate(jmeanHeatGLOBAL4D(nxg,nyg,nzg,10)) !Remove comment mark for 4D recording
            allocate(refrac(nxg, nyg, nzg + 1))
        end subroutine alloc_array
end MODULE subs
