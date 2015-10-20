#first line of input is number of test cases
N = int(raw_input())
assert N > 0
#second line contains N test cases separated by whitespace
line = [int(x) for x in raw_input().split()]
assert len(line) == N
wsd = [ str(sum([(int(indx)+1) * int(digit) for indx,digit in enumerate(str(x)) ])) for x in line]
print " ".join(wsd)
