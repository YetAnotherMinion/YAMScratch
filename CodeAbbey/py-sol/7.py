import sys
#list of numbers separated by whitespace all on one line
#first number is number of test cases
line = [int(x) for x in raw_input().split()]
assert line #make sure it is non empty
N = line[0]
assert N == len(line) - 1
for indx in xrange(1,N+1):
	#oncvert Fahrenheit to Celcius and round to neared integer
	sys.stdout.write(str(int((line[indx]-32) * 5 / 9.0 + 0.5)) + ' ')
sys.stdout.write('\n')
