module sourceph_mod

    implicit none

    contains
        subroutine sourceph(xcell, ycell, zcell, iseed)
        ! get intial photon position


            use constants, only : nxg, nyg, nzg, xmax, ymax, zmax
            use photon_vars

            implicit none


            integer, intent(OUT)   :: xcell, ycell, zcell
            integer, intent(INOUT) :: iseed
            real                   :: ran2

            zp = ran2(iseed)   

            zp = 0.
            xp = -1.0
            yp = 0.

            phi = 0.
            cosp = cos(phi)
            sinp = sin(phi)          
            cost = 0.0
            sint = 1.0

            nxp = sint * cosp  
            nyp = sint * sinp
            nzp = cost

            !*************** Linear Grid *************************
            xcell=int(nxg*(xp+xmax)/(2.*xmax))+1
            ycell=int(nyg*(yp+ymax)/(2.*ymax))+1
            zcell=int(nzg*(zp+zmax)/(2.*zmax))+1
        !*****************************************************
        end subroutine sourceph
end module sourceph_mod
