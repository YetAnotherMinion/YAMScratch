#! /bin/bash

for i in `find . -type f -name '*.in' | sed -e 's:'\.\/':'':' -e 's:'\.in':'':'`;
do
	echo "================ $i ==================";
	make $i;
	./bin/$i.out < ./$i.in;
done
