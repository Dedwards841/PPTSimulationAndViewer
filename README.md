# PPTSimulationAndViewer
Repository for the project undertaken as part of my CS4796 module.

This contains the code for modular program capable of taking 3D models as .stl and converting them to .binvox
and then .dat files before simulating monte carlo code over the model and then outputing a heat absorption map.

It also contains code which can be used to view these maps.

The following porgrams are utilised by this code, all are avaialble for use

binvox-rw: https://github.com/dimatura/binvox-rw-py
binvox: http://www.patrickmin.com/binvox/
Both used in Model Generation code

data cube viewer: https://github.com/lewisfish/data_cube_viewer
Used in Map Viewer code 

Monte Carlo Simulation Code (updated to Fortran90 by Lewis McMillian and further adapted by myself): 
http://www-star.st-and.ac.uk/~kw25/research/montecarlo/points/points.html
Used in MC Simulation Code
