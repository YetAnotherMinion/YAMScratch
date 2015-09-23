from PIL import Image, ImageDraw
import binascii


filename = 'misc300_extract_better.png'

img = Image.open(filename)

tmp_pixels = list(img.getdata())
width, height = img.size

print width, height

colors = set()

#there should only be two colors, so
#we can compare on first componenet only
fence = 128

line = ''

for pix in tmp_pixels:
	if pix[0] < fence:
		line += '0'
	else:
		line += '1'

tmp = [line[i:i+8] for i in xrange(0,len(line),8)]
foo = [chr(int(x,2)) for x in tmp]

with open("out_file.txt", "w") as f:
	for thing in foo:
		f.write(thing)
