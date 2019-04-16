import numpy as np
import subprocess
import scipy
import matplotlib.pyplot as plt
import scipy.misc as mpimg
import matplotlib.colors as colours
import matplotlib.patches as mpatches
import os

def getDat(file, wavelength, start):
	readin = open(file)
	lines = readin.readlines()[start:]
	toReturn = 0.0

	try:
		for line in lines:
			data = line.split()
			for i in range(len(data)):
				if(float(data[i])==wavelength):
					toReturn = float(data[i+1])
	finally:
		readin.close()

	return toReturn
	

#Required to get the most usable value for Water absorptionCoEff as above 800 it is given every 5-10 nm
def roundWater(waveIn):

	if(waveIn < 800):
		waveOut=waveIn+1

	elif(waveIn>=800.0 and waveIn<805.0):
		waveOut=800

	elif(waveIn>=805.0 and waveIn<815.0):
		waveOut=810

	elif(waveIn>=815.0 and waveIn<822.5):
		waveOut=820

	elif(waveIn>=822.5 and waveIn<827.5):
		waveOut=825

	elif(waveIn>827.5 and waveIn<835.0):
		waveOut=830

	elif(waveIn>=835.0 and waveIn<845.0):
		waveOut=840

	elif(waveIn>=845.0 and waveIn<855.0):
		waveOut=850

	elif(waveIn>=855.0 and waveIn<865.0):
		waveOut=860
		
	elif(waveIn>=865.0 and waveIn<872.5):
		waveOut=870

	elif(waveIn>=855.0 and waveIn<877.5):
		waveOut=875

	elif(waveIn>=877.5 and waveIn<885.0):
		waveOut=880

	elif(waveIn>=885.0 and waveIn<895.0):
		waveOut=890

	elif(waveIn>=895.0 and waveIn<905.0):
		waveOut=900

	elif(waveIn>=905.0 and waveIn<915.0):
		waveOut=910

	elif(waveIn>=915.0 and waveIn<922.5):
		waveOut=920

	elif(waveIn>=922.5 and waveIn<927.5):
		waveOut=925

	elif(waveIn>=927.5 and waveIn<935.0):
		waveOut=930

	elif(waveIn>=935.0 and waveIn<945.0):
		waveOut=940

	elif(waveIn>=945.0 and waveIn<955.0):
		waveOut=950

	elif(waveIn>=955.0 and waveIn<965.0):
		waveOut=960

	elif(waveIn>=965.0 and waveIn<972.5):
		waveOut=970

	elif(waveIn>=972.5 and waveIn<977.5):
		waveOut=975

	elif(waveIn>=977.5 and waveIn<985.0):
		waveOut=980

	elif(waveIn>=985.0 and waveIn<995.0):
		waveOut=990

	elif(waveIn>=995.0):
		waveOut=1000
	
	return waveOut

def setDensityGrid(cf,looper): #densityGridSlice, pic, densityGrid

	f = open('data/coeffStruct3D.dat', 'w')
	
	reads = open('res/input.params')
	wavelength = reads.read().split()[30]
	if(float(wavelength)%2 != 0):
		wavelengthBlood = float(wavelength)+1
		wavelengthWater = roundWater(float(wavelength))
	else:
		wavelengthBlood = float(wavelength)
		wavelengthWater = roundWater(float(wavelength))

	absorbBloodOx = getDat('data/absorptionCoEff/datahemo.txt', wavelengthBlood, 0)
	absorbBloodDeox = getDat('data/absorptionCoEff/datahemodeox.txt', wavelengthBlood, 0)	
	absorbBloodTotal = (62.6*absorbBloodOx + 37.4*absorbBloodDeox)/100
	absorbBloodTotalCancer = (61.1*absorbBloodOx + 38.9*absorbBloodDeox)/100
	absorbWater = getDat('data/absorptionCoEff/datawatar.txt', wavelengthWater, 4)		
	absorbFat = getDat('data/absorptionCoEff/datafat.txt', float(wavelength), 3)		
	
	#Values from Jacques 2013
	absorbSkin = 0.0069*absorbBloodTotal + 0.065*absorbWater + 0.74*absorbFat
	absorbCancer = 0.0176*absorbBloodTotalCancer + 0.4*absorbWater + 0.39*absorbFat

	if(looper==1 or looper==2 or looper==3):
		absorbGNP = getDat('data/absorptionCoEff/gnprod150.txt', float(wavelength), 26)
	if(looper==2 or looper==5 or looper==6):
		absorbGNP = getDat('data/absorptionCoEff/gnprod160.txt', float(wavelength), 26)
	if(looper==3 or looper==8 or looper==9):
		absorbGNP = getDat('data/absorptionCoEff/gnprod170.txt', float(wavelength), 26)

	absorbGNP = cf*absorbGNP	
	

	try:	
		f.write(str(absorbSkin)+'\n')
		f.write(str(absorbBloodTotal)+'\n')
		f.write(str(absorbGNP)+'\n')
		f.write(str(absorbCancer)+'\n')
		
	finally:
		f.close()
	

run_MC = True #set true to run new Monte Carlo, false will not
if (run_MC):
	for looper in [1,2,3,4,5,6,7,8,9]: 
		for power in [5,10]: 
		#Loop 1 {Laser Power = 5W, 10W}
			for cf in [10.0,20.0]: 
			#Loop 2 {Concentration Factor = 10.0,20.0}
				for wavel in [775, 800, 825, 850]: 
				#Loop 3 {Wavelengths = 775, 800, 825, 850}

					output = open("ParametersIn.txt","a+")
					output.write("%d %.1f %d \n" % (power, cf, wavel))
					output.close()

					with open('res/input.params', 'r') as file:
						paramet = file.readlines()
	
					paramet[6] = str(power) + "\t\tPower\n"
					paramet[11] = str(wavel) + "\t\tWavelength\n"

					with open('res/input.params', 'w') as file:
						file.writelines(paramet)

					setDensityGrid(cf,looper)
					os.system("bash install.sh")



