srand = [1210966590, 1186053825, 828331504, 627663218, 298077575, 1621029554,
757701149, 1017082882, 22312954, 497556206, 1868211592, 1903838027,
1938824116, 438914258, 697745218, 653705302, 2053197272, 967033002,
892346329, 1760941305, 474680070, 205410322, 30760889, 646833135,
1552407528, 1925490623, 584769422, 1705041581, 285178801, 189864595,
1101248475, 1496145392, 1375918420, 1929579980, 2123808610, 1673995995,
1403125886, 734026111, 543595229, 1425438840, 1231582318, 264323173,
1181793219, 1022922786, 703237431, 1879538438, 1676628088, 608951055,
699087792, 421490770, 222408713, 1173767863, 626901092, 253169602,
1820600998, 31824972, 31176577, 257886772, 1736866554, 316355379,
447751367, 690631381, 1812500771, 1823669787, 472727713, 1788825733,
1350182135, 1875853600, 375368196, 1893777364, 1153808792, 1606950514,
10616890, 188118364, 482389652, 713854321, 2067656802, 11534093,
1322805377, 619260946, 433024863, 1545214090, 1793028809, 1059925955,
1798383692, 1466146160, 1091750928, 1829560269, 1724032932, 681133834,
2145915648, 24300652, 1371765215, 1810932771, 1847970439, 1844492929,
1452274856, 1050668926, 1572862881, 1827643053]

#extract componenets into high bytes and low byte
high = []
low = []
for num in srand:
	high.append(num & (~(0xff)))
	low.append(num & 0xff)

def myhash(s):
	result = 1
	for indx,char in enumerate(s):
		#print "r",srand[indx]
		result += ord(char) ^ srand[indx]
		result %= 1<<32
		#print "h",result
	return result

#result of myhash('RPISEC')= 1477154955

rpisec = 'RPISEC'
target_hash = 1477154955

assert target_hash == myhash(rpisec)

running = 0
running_low = 0
#get the high componenets of the RPISEC hash
for indx, char in enumerate(rpisec):
	running += high[indx]
	running %= 1<<32
	#also check running low
	print char
	print format(low[indx], '#010b' )
	print format(ord(char), '#010b')
	print "------------"
	v1 = low[indx] ^ ord(char)
	print format( v1, '#010b' )
	print ''


	running_low += low[indx] ^ ord(char)

#there should be a difference of 1, which is the initialization vector
print "="*50
print target_hash - running - running_low


#set 3rd bit of R to 1
alt = chr(ord('R') + 8) + chr(ord('P') + 8) + 'ISEC'


running = 0
running_low  =0
for indx, char in enumerate(rpisec):
	running += high[indx]
	running %= 1<<32
	#also check running low
	v1 = low[indx] ^ ord(char)
	print v1
	running_low += low[indx] ^ ord(char)


#there should be a difference of 1, which is the initialization vector
print "="*50
print target_hash - running - running_low

print alt

#flag{H4cK3rs_ArNt_G00D_A7_m47h}