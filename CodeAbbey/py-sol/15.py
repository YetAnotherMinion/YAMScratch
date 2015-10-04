#expect list of whitespace separated numbers on same line
line = [int(x) for x in raw_input().split()]
max_canidate = line[0]
min_canidate = max_canidate
for indx in xrange(1,len(line)):
	if line[indx] > max_canidate:
		max_canidate = line[indx]
	elif line[indx] < min_canidate:
		min_canidate = line[indx]
print max_canidate, min_canidate
