import sys
#number of testcases is integer on first line of input
N = int(raw_input())
for _ in xrange(0, N):
	line = raw_input().split()
	assert 2 == len(line)
	(weight, height) = line
	bmi = float(weight) / (float(height) ** 2) 
	if bmi < 18.5:
		description = 'under'
	elif bmi < 25:
		description = 'normal'
	elif bmi < 30:
		description = 'over'
	else:
		description = 'obese'
	sys.stdout.write(description + ' ')
sys.stdout.write('\n')
