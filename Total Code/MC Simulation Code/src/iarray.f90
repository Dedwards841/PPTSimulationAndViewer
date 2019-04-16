MODULE iarray
!
!  Contains all array var names.
!
    implicit none

    real, allocatable :: xface(:), yface(:), zface(:)
    real, allocatable :: rhokap(:,:,:)
    real, DIMENSION(0:400,0:400,0:400), allocatable :: jmean(:,:,:), jmeanGLOBAL(:,:,:), jmeanFluGLOBAL(:,:,:)
    real, DIMENSION(0:400,0:400,0:400), allocatable :: jmeanHeatGLOBAL(:,:,:)
    !real, DIMENSION(0:400,0:400,0:400,0:10), allocatable :: jmeanHeatGLOBAL4D(:,:,:,:) !Remove comment mark for 4D recording
    real, allocatable :: refrac(:,:,:)
end MODULE iarray
