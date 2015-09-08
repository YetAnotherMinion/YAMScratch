# .--------------------------------------------.
# |+ NSANET - Ciphertext Interception Module - |
# '--------------------------------------------'
# |        *** RECOVERED METADATA ***          |
# '--------------------------------------------'
# |ALGORITHM: ??? [Source Available]           |
# |KEY[BITS]: 128                              |
# |ENCODING : BASE-64                          |
# '--------------------------------------------'
# | !!!!    KRYPTO-ENGINE OPTIONS MENU    !!!! |
# '--------------------------------------------'
# |[1] SEED KRYPTO ENGINE                      |
# |[2] OBTAIN MESSAGE                          | 
# '--------------------------------------------'
# [+] CHOICE: 1
# [+] ENGINE RESEED COMPLETE SEED [1441408807]
# 5EskPHg05z7pD209v37dcd1TLRttBuUq8w9YWZBn

# [+] ENGINE RESEED COMPLETE SEED [1441408873]
# [+] ::Message:: 
# 4CGaWUtJ6AoS9jiaSNZDitk5k35ee+oeCPYN/mfP

# [+] ENGINE RESEED COMPLETE SEED [1441409454] 2
# [+] ::Message:: 
# M6ftudw5D4qrzNp+h1d+9gq/5J7JCw2esczvGqhO
import base64
import random

t_start = 1441409454

line = 'M6ftudw5D4qrzNp+h1d+9gq/5J7JCw2esczvGqhO'

ciphertext = base64.b64decode(line)

print ciphertext

foo = set()
for ii in xrange(0, 6):
    random.seed(t_start+ii)
    key = []
    for jj in xrange(0, 16):
        key.append(random.randint(0, 2 ** 8))
    out = []
    for indx, char in enumerate(ciphertext):
        out.append(chr(key[indx % len(key)] ^ ord(char)))

    print "".join(out)
