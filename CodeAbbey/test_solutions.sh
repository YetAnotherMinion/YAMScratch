
# This script lives in the CodeAbbey master directory and runs tests
# on each solution per language
# Arguments:
#  $1  absolute path to directory containing test cases
#  $2  absolute path to YAMScratch/CodeAbbey

echo $1
echo $2
CA_BASEPATH=${2%/}

#create a tmp dir to store output

for full_filename in `find $1 -type f -name '*.in'`;
do
	TEST_BASEPATH=$(dirname "$full_filename")
	filename=$(basename "$full_filename")
	i="${filename%.*}"
	echo $TEST_BASEPATH
	echo $CA_BASEPATH
	echo "================ $i ==================";
	#test the C files
	if [ -f "$CA_BASEPATH/c-sol/src/$i.c" ] ; then
		make $i -C $CA_BASEPATH/c-sol
		$CA_BASEPATH/c-sol/bin/$i.out < $TEST_BASEPATH/$i.in > $CA_BASEPATH/c-sol/tmp.$i.out
		diff --brief $TEST_BASEPATH/$i.out $CA_BASEPATH/c-sol/tmp.$i.out
		if [ $? -eq 1 ] ; then
			#show the diff
			diff $TEST_BASEPATH/$i.out $CA_BASEPATH/c-sol/tmp.$i.out
		else
			echo ""
			# echo "they are the same"
		fi
		#clean up the tmp file
		rm $CA_BASEPATH/c-sol/tmp.$i.out
	fi
	if [ -f "$CA_BASEPATH/py-sol/$i.py" ] ; then
		python $CA_BASEPATH/py-sol/$i.py < $TEST_BASEPATH/$i.in> $CA_BASEPATH/py-sol/tmp.$i.out
		diff --brief $TEST_BASEPATH/$i.out $CA_BASEPATH/py-sol/tmp.$i.out
		if [ $? -eq 1 ] ; then
			#show the diff
			diff $TEST_BASEPATH/$i.out $CA_BASEPATH/py-sol/tmp.$i.out
		else
			echo ""
			# echo "they are the same"
		fi
	fi

done
