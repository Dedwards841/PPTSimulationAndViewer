MODULE gridset_mod

    implicit none
    save

    real, dimension(3,1) :: array1
    real, dimension(3,1) :: muarray
    real, dimension(400,400,400) :: inputArray

    private
    public :: gridset

    contains
	subroutine gridset(id)

            use constants, only : nxg, nyg, nzg, xmax, ymax, zmax
            use iarray, only    : rhokap,xface,yface,zface, rhokap, refrac
            use opt_prop, only  : kappa
            use ch_opt

            implicit none

            integer, intent(IN) :: id

            integer             :: i, j, k, scorex, scorey, scorez, count1, count2
            real                :: x, y, z, taueq1, taupole1, taueq2, muaSkin, muaBlood, muaGNP, taupole2, temp, muaSkinCan
	    

	    open(12, file="data/coeffStruct3D.dat")

	    read(12,*) muaSkin
	    read(12,*) muaBlood
	    read(12,*) muaGNP
	    read(12,*) muaSkinCan

	    close(12)

	    open(13, file="data/FullTransferSphere.dat")
	    read(13,*) inputArray
	    close(13)

            if(id == 0)then
                print*, ' '
                print *, 'Setting up density grid....'
            end if

	    

            ! setup grid faces
            do i = 1, nxg + 1
                xface(i) = (i - 1) * 2. * xmax/nxg
            end do

            do i = 1, nyg + 1
                yface(i) = (i - 1) * 2. * ymax/nyg
            end do

            do i = 1, nzg + 1
                zface(i) = (i - 1) * 2. * zmax/nzg
            end do

            call init_opt5
            refrac(:,:,:) = muaSkin


            !set up optical properties grid 
            do i = 1, nxg
                do j = 1, nyg
                    do k = 1, nzg
                        rhokap(i,j,k) = kappa
			temp = inputArray(i, j, k)
				
			if(temp < 0.0)then
				refrac(i,j,k) = muaBlood 
			end if
			if(temp < -4.0)then
				refrac(i,j,k) = muaSkinCan 
			end if
			if(temp > 0.0)then
				refrac(i,j,k) = (muaGNP+muaSkinCan)/2 !Part GNP part cancer tissue absorption coeff...
			end if

                    end do
                end do
            end do

            !****************** Calculate equatorial and polar optical depths ****
            taueq1   = 0.
            taupole1 = 0.
            taueq2   = 0.
            taupole2 = 0.

            do i = 1, nxg
                taueq1 = taueq1 + rhokap(i,nyg/2,nzg/2)
            end do

            do i = 1, nzg
                taupole1 = taupole1 + rhokap(nxg/2,nyg/2,i)
            end do

            taueq1 = taueq1 * 2. * xmax/nxg
            taupole1 = taupole1 * 2. * zmax/nzg
            if(id == 0)then
                print'(A,F9.5,A,F9.5)',' taueq1 = ',taueq1,'  taupole1 = ',taupole1
            end if

            if(id == 0)then
                inquire(iolength=i)refrac(:,:,:nzg)
                open(newunit=j,file='refrac.dat',access='direct',form='unformatted',status='replace',recl=i)
                write(j,rec=1)refrac(:,:,:nzg)
                close(j)
            end if

        end subroutine gridset


end MODULE gridset_mod
