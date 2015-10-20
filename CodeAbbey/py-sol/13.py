#first line of input is number of test cases
N = int(raw_input())
assert N > 0
line = [int(x) for x in raw_input().split()]
assert len(line) == N
k = 1776


wsd = [ sum([(int(indx)+1) * int(digit) for indx,digit in enumerate(str(x)) ]) for x in line]
print " ".join([str(x) for x in wsd])
