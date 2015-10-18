import math

print (0.5 - (690 / float(690 + 1000))) * 1100
print "="*40

#circuits for 4 & 5
def first_part(R1, R2, R3, R4, V_in):
	V_th = V_in * (R4 / float(R4 + R1))
	R_th = ( (R4 * R1) / float(R4 + R1) ) + R2 + R3
	return (V_th, R_th)

#data for 4
(V_th, R_th) = first_part(
	R1 = 25000,
	R2 = 93000,
	R3 = 80000,
	R4 = 63000,
	V_in = 92)
print "V_th:", V_th, "Volts"
print "="*40
#data for 5
(V_th, R_th) = first_part(
	R1 = 31000,
	R2 = 93000,
	R3 = 57000,
	R4 = 91000,
	V_in = 64)
print "R_th:", R_th, "Ohms"
print "="*40

#circuits for 6 & 7
def second_part(R1, R2, R3, R4, V_in):
	V_th = V_in * (R4 / float(R4 + R3 + R2))
	R_th = (R4 * (R3 + R2)) / float(R4 + R3 + R2)
	return (V_th, R_th)
#data for 6
(V_th, R_th) = second_part(
	R1 = 72000,
	R2 = 51000,
	R3 = 96000,
	R4 = 34000,
	V_in = 63)
print "V_th:", V_th, "Volts"
print "="*40

#data for 7
(V_th, R_th) = second_part(
	R1 = 76000,
	R2 = 47000,
	R3 = 27000,
	R4 = 36000,
	V_in = 67)
print "R_th:", R_th, "Ohms"
print "="*40

#resonant freq
freq = 20
omega = 2 * math.pi * freq
mass = 82 * (10**-3)# in kg
print "k:", (omega**2) * (0.23 *mass), "kg/s^2"