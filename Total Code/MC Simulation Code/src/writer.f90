module writer_mod

implicit none

character(len=30) :: filenames

    contains
        subroutine writer(xmax, ymax, zmax, nphotons, numproc)

            use constants, only : nxg,nyg,nzg,fileplace
            use iarray,    only : jmeanGLOBAL

            implicit none

            integer           :: nphotons, i, u, numproc, tracking
            real              :: xmax, ymax, zmax
	    character(len=1024) :: format_string

	    open(newunit=u, file=trim(fileplace)//'tracking.dat',access='sequential',status='Old',action='readwrite')
	    read(u,*) tracking
	    tracking = tracking + 1
	    rewind(u)
	    write(u,*) tracking
	    close(u)

	    write(format_string,*) tracking
	    filenames = trim('jmean/heatmap')//trim(format_string)//trim('.dat')
	    filenames = trim(filenames)

	    inquire(iolength=i)jmeanGLOBAL

           ! open(newunit=u,file=trim(fileplace)//filenames,access='direct',status='REPLACE',form='unformatted',&
           ! recl=i)
           ! write(u,rec=1) jmeanGLOBAL
           ! close(u)

        end subroutine writer



	subroutine writing2(xmax, ymax, zmax, nphotons, numproc)

	    use constants, only : nxg,nyg,nzg, fileplace
            use iarray,    only : jmeanHeatGLOBAL !, jmeanHeatGLOBAL4D !Remove comment mark for 4D recording

            implicit none

            integer           :: nphotons, i, u, numproc, filerec, tracking
            real              :: xmax, ymax, zmax
	    character(len=1024) :: format_string

	   ! inquire(iolength=i)jmeanHeatGLOBAL4D !Remove comment mark for 4D recording
            inquire(iolength=i)jmeanHeatGLOBAL

	    write(format_string,*) tracking
	    filenames = trim('jmean/point')//trim(format_string)//trim('.csv')
	    filenames = trim(filenames)
		

	   ! open(newunit=u,file=trim(fileplace)//'jmean/jmeanHeatStep1Map.dat',access='direct',status='REPLACE',form='unformatted',&
           ! recl=i)
	   ! write(u,rec=1) jmeanHeatGLOBAL 
            !write(u,rec=1) jmeanHeatGLOBAL4D !Remove comment mark for 4D recording
	    open(newunit=u, file=trim(fileplace)//filenames,access='sequential',status='REPLACE')
	    write(u,*) jmeanHeatGLOBAL(400,375,375),',',jmeanHeatGLOBAL(200,200,200),',',jmeanHeatGLOBAL(165,215,191),','
            close(u)

        end subroutine writing2



	subroutine writing3(xmax, ymax, zmax, nphotons, numproc,l)

	    use constants, only : nxg,nyg,nzg,fileplace
            use iarray,    only : jmeanHeatGLOBAL

            implicit none

            integer           :: nphotons, i, u, numproc,l, filerec
            real              :: xmax, ymax, zmax

            inquire(iolength=i)jmeanHeatGLOBAL
	    
	    open(newunit=u, file=trim(fileplace)//filenames,access='sequential',status='old',position='append')
	    write(u,*) jmeanHeatGLOBAL(400,375,375),',',jmeanHeatGLOBAL(200,200,200),',',jmeanHeatGLOBAL(165,215,191),','
            close(u)
	    

        end subroutine writing3

end module writer_mod
