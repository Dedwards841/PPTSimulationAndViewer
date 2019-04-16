program mcpolar

use mpi

!shared data
use constants
use photon_vars
use iarray
use opt_prop

!subroutines
use subs
use gridset_mod
use sourceph_mod
use inttau2
use ch_opt
use stokes_mod
use writer_mod
use heat_mod

implicit none

integer          :: nphotons, iseed, j, xcell, ycell, zcell, power, rho, specheat,l
logical          :: tflag
double precision :: nscatt, volume
real             :: ran, delta, start,finish,ran2, deltat,startheat,finishheat

integer :: id, error, numproc
real    :: nscattGLOBAL

!set directory paths
call directory

!allocate and set arrays to 0
call alloc_array
call zarray

!init MPI
call MPI_init(error)
call MPI_Comm_size(MPI_COMM_WORLD, numproc, error)
call MPI_Comm_rank(MPI_COMM_WORLD, id, error)

!**** Read in parameters from the file input.params
open(10,file=trim(resdir)//'input.params',status='old')
   read(10,*) nphotons
   read(10,*) xmax
   read(10,*) ymax
   read(10,*) zmax
   read(10,*) n1
   read(10,*) n2
   read(10,*) power
   read(10,*) deltat
   read(10,*) volume
   read(10,*) rho
   read(10,*) specheat
   close(10)

! set seed for rnd generator. id to change seed for each process
iseed=-95648324!+id
iseed=-abs(iseed)  ! Random number seed must be negative for ran2

call init_opt5

if(id == 0)then
   print*, ''      
   print*,'# of photons to run',nphotons*numproc
end if

!***** Set up density grid *******************************************
call gridset(0)

!***** Set small distance for use in optical depth integration routines 
!***** for roundoff effects when crossing cell walls
delta = 1.e-8*(2.*zmax/nzg)
nscatt=0

call cpu_time(start)

!loop over photons 
print*,'Photons now running on core: ',id

do j = 1, nphotons

   tflag=.FALSE.

   if(mod(j,50000) == 0)then
      print *, j,' scattered photons completed on core: ',id
   end if
    
!***** Release photon from point source *******************************
   call sourceph(xcell,ycell,zcell,iseed)
!****** Find scattering location

      call tauint1(xcell,ycell,zcell,tflag,iseed,delta)
!******** Photon scatters in grid until it exits (tflag=TRUE) 
      do while(tflag.eqv..FALSE.)

         ran = ran2(iseed)
         if(ran < albedo)then!interacts with tissue
               call stokes(iseed)
               nscatt = nscatt + 1        
            else
               tflag=.true.
               exit
         end if

!************ Find next scattering location

         call tauint1(xcell,ycell,zcell,tflag,iseed,delta)

      end do
end do      ! end loop over nph photons

call cpu_time(finish)
print*, 'time taken ~',floor(finish-start/60.),'s'



! collate fluence from all processes
call MPI_REDUCE(jmean, jmeanGLOBAL, (nxg*nyg*nzg),MPI_DOUBLE_PRECISION, MPI_SUM,0,MPI_COMM_WORLD,error)
call MPI_BARRIER(MPI_COMM_WORLD, error)

call MPI_REDUCE(nscatt,nscattGLOBAL,1,MPI_DOUBLE_PRECISION,MPI_SUM,0,MPI_COMM_WORLD,error)
call MPI_BARRIER(MPI_COMM_WORLD, error)

!Converts fluence to heat source map (qdot) (in Kelvin) [Added by de30]
jmeanGLOBAL = jmeanGLOBAL*(power/(nphotons*volume))*(deltat/(rho*specheat)) !qdot term <-

if(id == 0)then
   print*,'Average # of scatters per photon:',nscattGLOBAL/(nphotons*numproc)
   !write out heat source file
   call writer(xmax,ymax,zmax,nphotons, numproc)
   print*,'write done'
end if

jmeanFluGLOBAL(:,:,:) = 0.0d0

!Call Heat derivative over time calculator [de30]
!For 4D recording only call writing 2 after the last run and remove calls of writing 3.
call cpu_time(startheat)
do l = 1,400
	
	call heatDif(nphotons, numproc, deltat, volume, rho, specheat,l)

	if (mod(l,20) ==0)then
		print*, l,'time steps completed'
	end if

	if(l==1)then
		call writing2(xmax,ymax,zmax,nphotons,numproc)
	else
		call writing3(xmax,ymax,zmax,nphotons,numproc,l)
	end if
	
	jmeanFluGlobal = jmeanHeatGLOBAL
end do



call cpu_time(finishheat)

print*, 'time taken ~',floor(finishheat-startheat/60.),'s'

call MPI_Finalize(error)
end program mcpolar
