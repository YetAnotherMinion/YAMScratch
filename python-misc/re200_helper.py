# signed int v7; // [sp+4Ch] [bp-24h]@1
# signed int v8; // [sp+50h] [bp-20h]@1
# signed int v9; // [sp+54h] [bp-1Ch]@1
# signed int v10; // [sp+58h] [bp-18h]@1
# signed int v11; // [sp+5Ch] [bp-14h]@1
# signed int v12; // [sp+60h] [bp-10h]@1
# signed int v13; // [sp+64h] [bp-Ch]@1
# signed int v14; // [sp+68h] [bp-8h]@1
# int v15; // [sp+6Ch] [bp-4h]@1
# v15 = *MK_FP(__GS__, 20);

#  v7 = 0x2A1E4426;  <-- start of buffer
#  v8 = 0x212A3007;
#  v9 = 0x1027461D;
#  v10 = 0x4507172A;
#  v11 = 0x21103259;
#  v12 = 0xC31072A;
#  v13 = 0x382A412A;
#  v14 = 0x46071A;

mask = int('75',16)

#we assume little endian

tmp_key = ['2A1E4426','212A3007','1027461D', '4507172A', '21103259', '0C31072A', '382A412A', '46071A']
key = []
for segment in tmp_key:
  key += [segment[i-2: i] for i in xrange(len(segment),0,-2)]

print len(key)
#now mask the buffer out
key = [chr(int(x,16) ^ mask)  for x in key]
print "".join(key)

# S1k_rE_Th3Re_br0,GeT_rDy_4_Mor3
#flag{S1k_rE_Th3Re_br0,GeT_rDy_4_Mor3}
