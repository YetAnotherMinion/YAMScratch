

def f(k, arr, count):
    count[0] += 1
    if k == 1:
      arr[k] = 1
    if arr[k] == 0:
      arr[k] = min([max(x, 1+f(k-x, arr, count)) for x in range(1, int(k/2) + 1)])
    return arr[k]


def g(k):
  arr = [0 for x in range(0,k+1)]
  count = [0,]
  return arr, f(k, arr, count), count[0]


(arr, result, count) = g(100)
#print arr
print result
print count

def f2(k, arr, count):
    count[0] += 1
    if k == 1 or k == 0:
      arr[k] = 1
    if arr[k] == 0:
      arr[k] = min([max(x, 1+f2(k-x, arr, count)) for x in range(int(k/2) + 1, 0, -1)])
    return arr[k]


def g2(k):
  arr = [0 for x in range(0,k+1)]
  count = [0,]
  return arr, f2(k, arr, count), count[0]


(arr, result, count) = g2(100)
#print arr
print result
print count

