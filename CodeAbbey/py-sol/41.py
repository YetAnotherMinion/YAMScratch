import sys

N = int(raw_input())
swap = lambda x,y: (y,x)
for _ in xrange(0,N):
	(A,B,C) = tuple([int(x) for x in raw_input().split()])
	if B < A:
		(A,B) = swap(A,B)
	if B > C:
		(B,C) = swap(B,C)
	if B < A:
		(A,B) = swap(A,B)
	sys.stdout.write(str(B) + ' ')
sys.stdout.write('\n')
