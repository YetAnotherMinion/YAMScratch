import sys
#fir line is integer with number of test cases
N = int(raw_input())
for _ in range(0,N):
	line = raw_input()
	vowels = filter(lambda x: x in 'aeiouy', line)
	sys.stdout.write(str(len(vowels)) + ' ')
sys.stdout.write('\n')
