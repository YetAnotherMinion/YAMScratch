#define _GNU_SOURCE
#include <unistd.h> /*for getop */
#include <stdint.h>
#include <errno.h> /*for errno*/
#include <stdio.h> /*provided perror*/
#include <stdlib.h> /*provides exit*/
#include <string.h> /*provides strsep*/

#include "parseCodeAbbeyInput.h"
#include "wrapped.h"

VECTOR_INIT(int)
VECTOR_INIT(signed)
/*TOKENIZE must come after VECTOR declaration*/
TOKENIZE_INIT(int)
TOKENIZE_INIT(signed)


#define DELIMETER ' '
#define MIN(a,b) a < b ? a : b


int main(int argc, char* argv[]) {
	/*setup our parser template*/
	int (*int_from_string)(char*);
	int_from_string = &wrap_atoi;
	size_t nbytes;
	ssize_t bytes_read;
	char* lineptr;
	lineptr = NULL;
	nbytes = 0;
	Vector(int)* vec = newVector(int);
	bytes_read = wrap_getline(&lineptr, &nbytes, stdin);
	/*account for the terminating null char from getline*/
	bytes_read++;
	tokenizeLine(int, vec, int_from_string, lineptr, bytes_read, DELIMETER);
	if(vec->elms < 1) {
		vector_destroy(int, vec);
		errno = EINVAL;
		perror("Enter at one integer > 0");
		exit(-1);
	}
	unsigned N;
	N = vec->items[0];
	vector_destroy(int, vec);
	/*hack to get around spaces in typename*/
	Vector(signed)* result = newVector(signed);
	Vector(signed)* each_line = newVector(signed);

	unsigned ii, tmp;
	for(ii = 0; ii < N; ii++) {
		vector_clear(signed, each_line);
		free(lineptr);
		lineptr = NULL;
		nbytes = 0;
		bytes_read = wrap_getline(&lineptr, &nbytes, stdin);
		/*account for the terminating null char from getline*/
		bytes_read++;
		tokenizeLine(signed, each_line , int_from_string, lineptr, bytes_read, DELIMETER);
		if(each_line->elms >= 2){
			tmp = MIN(each_line->items[0], each_line->items[1]);
			vector_push_back(signed, result, tmp);	
		}
	}
	free(lineptr);
	vector_destroy(signed, each_line);
	for(ii = 0; ii < result->elms; ii++){
		printf("%d ", result->items[ii]);
	}
	printf("\n");
	vector_destroy(signed, result);
	return 0;
}
