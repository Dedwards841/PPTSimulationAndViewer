import numpy
from stl import mesh

import matplotlib.pyplot as plt
from mpl_toolkits import mplot3d
from matplotlib import pyplot
from mpl_toolkits.mplot3d import Axes3D
import time
import os

import binvox_rw

#os.system('location/binvox CancerZone.stl')
#os.system('location/Daniel/Documents/PythonStuff/binvox GNPs.stl')
#os.system('location/Daniel/Documents/PythonStuff/binvox GNPs2.stl')
#os.system('location/Daniel/Documents/PythonStuff/binvox BloodVesselFull.stl')

with open('CancerZone.binvox', 'rb') as f3: model3 = binvox_rw.read_as_3d_array(f3)

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.set_xlabel('$X$')
ax.set_ylabel('$Y$')
ax.set_zlabel('$Z$')

arrayOut = numpy.zeros((400,400,400))

print("Startng Grid Generation. Cancer:")
start3 = time.time()
for i in range(256):
    for j in range(256):
        for k in range(256):
            if(str(model3.data[i,j,k]) == "True"):
                arrayOut[round(i/1.5)+110,round(j/1.5)+110,round(k/1.5)+110] = -5.0
end3 = time.time()

print("Cancer Done. Time Taken:")
print(end3 - start3)

with open('GNPs2.binvox', 'rb') as f2: model2 = binvox_rw.read_as_3d_array(f2)
print("Startng Grid Generation. GNPS:")
start2 = time.time()

for i in range(256):
    for j in range(256):
        for k in range(256):
            if(str(model2.data[i,j,k]) == "True"):
                arrayOut[round(i/1.5)+110,round(j/1.5)+110,round(k/1.5)+110] = 2.0
#plt.show()
                
end2 = time.time()
print("GNPs Done. Time Taken:")
print(end2 - start2)

with open('BloodVesselFull.binvox', 'rb') as f: model = binvox_rw.read_as_3d_array(f)

xlast = 0
ylast = 0
zlast = 0

print("Startng Grid Generation. Blood:")
start1 = time.time()

for i in range(256):
    for j in range(256):
        for k in range(256):
            if(str(model.data[i,j,k]) == "True"):
                
                arrayOut[round(i*400/model.dims[0]),round(j*400/model.dims[1]),round(k*400/model.dims[2])] = -1.0
                
                if(round(k*400/model.dims[2]) != zlast+1):
                    arrayOut[round(i*400/model.dims[0]),round(j*400/model.dims[1]),round(k*400/model.dims[2])-1] = -1.0
                if(round(j*400/model.dims[2]) != ylast+1):
                    arrayOut[round(i*400/model.dims[0]),round(j*400/model.dims[1])-1,round(k*400/model.dims[2])] = -1.0
                if(round(i*400/model.dims[2]) != xlast+1):
                    arrayOut[round(i*400/model.dims[0])-1,round(j*400/model.dims[1]),round(k*400/model.dims[2])] = -1.0
                    
                if(round(i*400/model.dims[2]) != xlast+1 and round(j*400/model.dims[2]) != ylast+1):
                    arrayOut[round(i*400/model.dims[0])-1,round(j*400/model.dims[1])-1,round(k*400/model.dims[2])] = -1.0
                if(round(i*400/model.dims[2]) != xlast+1 and round(j*400/model.dims[2]) != zlast+1):
                    arrayOut[round(i*400/model.dims[0])-1,round(j*400/model.dims[1]),round(k*400/model.dims[2])-1] = -1.0
                if(round(i*400/model.dims[2]) != ylast+1 and round(j*400/model.dims[2]) != zlast+1):
                    arrayOut[round(i*400/model.dims[0]),round(j*400/model.dims[1]-1),round(k*400/model.dims[2])-1] = -1.0
                    
                if(round(i*400/model.dims[2]) != xlast+1 and round(j*400/model.dims[2]) != ylast+1 and round(j*400/model.dims[2]) != zlast+1):
                    arrayOut[round(i*400/model.dims[0])-1,round(j*400/model.dims[1])-1,round(k*400/model.dims[2])-1] = -1.0
                    
                
            zlast=k
        ylast=j
    xlast=i

end1 = time.time()
print("Blood Done. Time Taken:")
print(end1 - start1)

f = open('FullTransferSphere.txt', 'w+')

print("Rewrite Done")


try:
    start4 = time.time()
    for i in range(400):
        for j in range(400):
            for k in range(400):
                f.write(str(arrayOut[i,j,k]) + ", ")
            f.write('\n')
        f.write('\n')
    end4 = time.time()
    print("Array Output Ready. Time Taken:")
    print(end4-start4)        
    
finally:
    f.close()
    print("Done")
