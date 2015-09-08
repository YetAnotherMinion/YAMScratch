# .--------------------------------------------.
# |+ NSANET - Ciphertext Interception Module - |
# '--------------------------------------------'
# |        *** RECOVERED METADATA ***          |
# '--------------------------------------------'
# |ALGORITHM: XOR                              |
# |KEY[BITS]: 8                                |
# '--------------------------------------------'
# |BEGIN:                                      |
# |22252d362325292122252d362325292122252d362325|
# |292122252d3623252921020805031f20540a303b1411|
# |08083b053b170a541300570a3b130d100c3b100c4517|
# |19                                          |
# |:END                                        |
# '--------------------------------------------'

# 22252d362325292122252d362325292122252d362325292122252d3623252921020805031f20540a303b141108083b053b170a541300570a3b130d100c3b100c451719
import itertools


line = '22252d362325292122252d362325292122252d362325292122252d3623252921020805031f20540a303b141108083b053b170a541300570a3b130d100c3b100c451719'
a = [line[i:i+2] for i in range(0,len(line),2)]

first = [a[i] for i in range(0, len(a), 2)]
second = [a[i] for i in range(1, len(a), 2)]

print "__".join(first)
print "__"+"__".join(second)


f_1 = [int(x,16) for x in second]
A = 100

f_done = [chr(int(x,16)^A) for x in first]

print "_".join(f_done)

for ii in xrange(0,256):
	f_2 = [chr(x^ii) for x in f_1]
	print ii
	print "".join([item for slist in itertools.izip_longest(f_done, f_2) for item in slist if item is not None])
	print "=========================================="
