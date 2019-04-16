module heat_mod

implicit none

	contains
        	subroutine heatDif(nphotons, numproc, deltat, volume, rho, specheat,l)

		use constants, only : nxg,nyg,nzg,fileplace
		use iarray,    only : jmeanFluGLOBAL, jmeanHeatGLOBAL

		implicit none

		integer           :: nphotons, numproc, rho, specheat, i, j, k, xyzzy,l
		real              :: deltat, koverrhoc
		double precision  :: volume, seperation

		call setParams(rho, specheat, koverrhoc, volume, seperation)

		call heateqn(koverrhoc, seperation, deltat,l)

		end subroutine heatDif



		!Sets koverrhoc and seperation parameters up as these remain constant in the heat equation
		subroutine setParams(rho, specheat, koverrhoc, volume, seperation)

		implicit none

		integer           :: rho, specheat
		real              :: deltat, koverrhoc
		double precision  :: volume, seperation

		koverrhoc = (0.56)/(rho*specheat)
		seperation = volume**(1./3.)

		end subroutine setParams



		!Runs heat equation
		subroutine heateqn(koverrhoc, seperation, deltat,l)

		use constants, only : nxg,nyg,nzg
		use iarray,    only : jmeanFluGLOBAL, jmeanHeatGLOBAL, jmeanGLOBAL !, jmeanHeatGLOBAL4D !Remove comment mark for 4D recording

		implicit none

		integer		  :: x,y,z,screams,l
		real              :: deltat, koverrhoc, xminus, xplus, yminus, yplus, zminus, zplus, heatp1, heatp2, heatp3, heatp4
		double precision  :: seperation, abc

		x=0
		y=0
		z=0

		do x=0, nxg
			do y=0, nyg
				do z=0, nzg

					if(x>0 .and. x<nxg) then
						xminus = jmeanFluGLOBAL(x-1,y,z)
						xplus = jmeanFluGLOBAL(x+1,y,z)
					else if(x==0) then
						xminus = 0
						xplus = jmeanFluGLOBAL(x+1,y,z)
					else
						xplus = 0
						xminus = jmeanFluGLOBAL(x-1,y,z)
					end if

					if(y>1 .and. y<nyg) then
						yminus = jmeanFluGLOBAL(x,y-1,z)
						yplus = jmeanFluGLOBAL(x,y+1,z)
					else if(y==1) then
						yminus = 0
						yplus = jmeanFluGLOBAL(x,y+1,z)
					else
						yplus = 0
						yminus = jmeanFluGLOBAL(x,y-1,z)
					end if

					if(z>1 .and. z<nzg) then
						zminus = jmeanFluGLOBAL(x,y,z-1)
						zplus = jmeanFluGLOBAL(x,y,z+1)
					else if(z==1) then
						zminus = 0
						zplus = jmeanFluGLOBAL(x,y,z+1)
					else
						zplus = 0
						zminus = jmeanFluGLOBAL(x,y,z-1)
					end if	

					heatp1 = (jmeanFluGLOBAL(x,y,z)-((6*deltat*koverrhoc)*jmeanFluGLOBAL(x,y,z))/(seperation**2))
					heatp2 = ((deltat*koverrhoc*xminus)/(seperation**2))+((deltat*koverrhoc*xplus)/(seperation**2))
					heatp3 = ((deltat*koverrhoc*yminus)/(seperation**2))+((deltat*koverrhoc*yplus)/(seperation**2))
					heatp4 = ((deltat*koverrhoc*zminus)/(seperation**2))+((deltat*koverrhoc*zplus)/(seperation**2))
					
					jmeanHeatGLOBAL(x,y,z) = heatp1+heatp2+heatp3+heatp4

					if(l <= 100)then
						jmeanHeatGLOBAL(x,y,z) = jmeanHeatGLOBAL(x,y,z)+jmeanGLOBAL(x,y,z)
						!jmeanHeatGLOBAL4D(x,y,z,(l-1)) = jmeanHeatGLOBAL(x,y,z) !Remove comment mark for 4D recording
					end if
				end do
			end do
		end do

		end subroutine heateqn

end module heat_mod
