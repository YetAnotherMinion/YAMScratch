# .--------------------------------------------.
# |+ NSANET - Ciphertext Interception Module - |
# '--------------------------------------------'
# |        *** RECOVERED METADATA ***          |
# '--------------------------------------------'
# |ALGORITHM: ??? [Source Available]           |
# |KEY[BITS]: 128                              |
# |ENCODING : BASE-64                          |
# '--------------------------------------------'
# |BEGIN:                                      |
# |NbNPiQdL4WZ8NkgqncRHTTWzT4kHS+FmfDZIKp3ER001|
# |s0+JB0vhZnw2SCqdxEdNNbNPiQdL4WZ8NkgqncRHTTWz|
# |T4kHS+FmXBtgH6G0fmEel1mrdG6TfHcYYAqF6WNtGK1k|
# |uiRV2AJXRF4ImuF3                            |
# |:END                                        |
# '--------------------------------------------'
# [+] Press Enter For Raw Ciphertext Data
# NbNPiQdL4WZ8NkgqncRHTTWzT4kHS+FmfDZIKp3ER001s0+JB0vhZnw2SCqdxEdNNbNPiQdL4WZ8NkgqncRHTTWzT4kHS+FmXBtgH6G0fmEel1mrdG6TfHcYYAqF6WNtGK1kuiRV2AJXRF4ImuF3
import base64


line = 'NbNPiQdL4WZ8NkgqncRHTTWzT4kHS+FmfDZIKp3ER001s0+JB0vhZnw2SCqdxEdNNbNPiQdL4WZ8NkgqncRHTTWzT4kHS+FmXBtgH6G0fmEel1mrdG6TfHcYYAqF6WNtGK1kuiRV2AJXRF4ImuF3'

#decode the string

ciphertext = base64.b64decode(line)

mask = 'FAIRGAME'
chunk = ciphertext[0:16]
#we only want to grab first 16 bytes
assert 16 == len(chunk)

guess_key  = []
for indx, char in enumerate(chunk):
	guess_key.append(ord(mask[indx % len(mask)]) ^ ord(char))

print guess_key


#decode the entire string
#we should see words FAIRGAME 4 to 10 times padding the begining

out = []
for indx, char in enumerate(ciphertext):
	out.append(chr(guess_key[indx % len(guess_key)] ^ ord(char)))

print "".join(out)