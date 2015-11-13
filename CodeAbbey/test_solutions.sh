
# This script lives in the CodeAbbey master directory and runs tests
# on each solution per language
# Arguments:
#  $1  absolute path to directory containing test cases

echo $1

#create a tmp dir to store output

for full_filename in `find $1 -type f -name '*.in'`;
do
	BASEPATH=$(dirname "$full_filename")
	filename=$(basename "$full_filename")
	i="${filename%.*}"
	echo $BASEPATH
	echo "================ $i ==================";
	#test the C files
	if [ -f "./c-sol/src/$i.c" ] ; then
		make $i -C c-sol
		./c-sol/bin/$i.out < $BASEPATH/$i.in > ./c-sol/tmp.$i.out
		diff --brief $BASEPATH/$i.out ./c-sol/tmp.$i.out
		if [ $? -eq 1 ] ; then
			#show the diff
			diff $BASEPATH/$i.out ./c-sol/tmp.$i.out
		else
			echo ""
			# echo "they are the same"
		fi
		#clean up the tmp file
		rm ./c-sol/tmp.$i.out
	fi
	if [ -f "./py-sol/$i.py" ] ; then
		python ./py-sol/$i.py < $BASEPATH/$i.in> ./py-sol/tmp.$i.out
		diff --brief $BASEPATH/$i.out ./py-sol/tmp.$i.out
		if [ $? -eq 1 ] ; then
			#show the diff
			diff $BASEPATH/$i.out ./py-sol/tmp.$i.out
		else
			echo ""
			# echo "they are the same"
		fi
	fi

done
