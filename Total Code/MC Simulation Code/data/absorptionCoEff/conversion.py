#Module used to convert hemo and hemodeox values to absorption coefficents
#Values in datahemoraw are molar extinction coefficents and we need absorption coefficents
#In order to reach that we take the 'rawvalue' and use the following equation
#absorptionCoeff = ln(10) * 'rawvalue' * x/64500 where x is the grams per liter of hemoglobin in blood which is roughly 150g/litre (as given in: https://omlc.org/spectra/hemoglobin/summary.html)


wavelength = []
hemo = []
hemodeox = []
params = [wavelength, hemo, hemodeox]

f = open('datahemoraw.txt')
lines = f.readlines()[4:]
g = open('datahemo.txt','w')
h = open('datahemodeox.txt','w')

try:
	for line in lines:
		data = line.split()
		for i in range(len(params)):
			params[i].append(float(data[i]))
	
	for j in range(len(params[1])):
		g.write(str(params[0][j]) + "\t" + str(params[1][j]*2.30258509*150/64458) + "\n")
		h.write(str(params[0][j]) + "\t" + str(params[2][j]*2.30258509*150/64458) + "\n")

finally:
	f.close()
	g.close()
