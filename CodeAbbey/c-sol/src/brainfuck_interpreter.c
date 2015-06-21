#include <errno.h>
#include <stdlib.h>

#include "brainfuck_interpreter.h"
/*remember the Vector_t macro was imported in the header for this file*/

signed brainfuck_evaluate_file(FILE* fp, int debug) {
	return 0;
}

signed brainfuck_evaluate_buffer(char* src, size_t nbytes, int debug) {
	return 0;
}

signed _eval_buffer(char* src, size_t nbytes, struct TapeNode* cursor, Vector_t(int)* stack) {
	return 0;
}
/*only adds to atape, will not remove any nodes*/
signed _eval_buffer_debug(char* src, size_t nbytes, struct TapeNodeDebug* cursor, Vector_t(int)* stack ) {
	/*keep track of where in the data buffer we are*/
	size_t instruction_offset;
	instruction_offset = 0;
	/*keep track of where in the tape we are, using the cursor position */
	signed long data_offset;
	data_offset = cursor->index;
	/*declare some variables to take input from scanf*/
	char in_char;
	unsigned long in_unsigned;

	/*declare the internal variables*/
	char* instr_ptr, *instr_end;
	int rc;
	/*end is the element one past end of buffer*/
	instr_end = src + nbytes;
	instr_ptr = src;
	/*dereference the instruction pointer each time*/
	while(instr_ptr != instr_end) {
		switch(*instr_ptr) {
			case '+': /*increment current value of cell*/
				if(cursor->cell + 1 < cursor->cell) {
					fprintf(stdout, "Overflow detected\n");
				}
				cursor->cell++;
				fprintf(stdout, "a[%ld]= %ld\n", cursor->index, cursor->cell );
				instr_ptr++;
				break;
			case '-': /*decrement current value of cell*/
				if(cursor->cell - 1 > cursor->cell) {
					fprintf(stdout, "Underflow detected\n");
				}
				cursor->cell--;
				fprintf(stdout,"a[%ld] = %ld\n", cursor->index, cursor->cell);
				instr_ptr++;
				break;
			case '>': /*increment the memory cell under the pointer*/
				/*look ahead and allocate a new block if necessary*/
				if(cursor->next == NULL) {
					errno = 0;
					struct TapeNodeDebug* node = (struct TapeNodeDebug*)malloc(sizeof(TapeNodeDebug));
					/*right now I don't know all the failure modes 
					* so just indicate failure mode and exit */
					if(!errno) {
						perror("failed to allocate new tape data struct\n");
						exit(-1);
					}
					cursor->next = node;
					node->prev = cursor;
					cursor = node;
				} else {
					cursor = cursor->next;

				}
				/*we dont care as much about overflows in the data tape index*/
				data_offset++;
				cursor->index++;
				fprintf(stdout, "a[%ld] = %ld\n", cursor->index, cursor->cell);
				instr_ptr++;
				break;
			case '<': /*decrement the memory cell under the pointer*/
				/*look behind and allocate a new block if necessary*/
				if(cursor->prev == NULL) {
					errno = 0;
					struct TapeNodeDebug* node = (struct TapeNodeDebug*)malloc(sizeof(TapeNodeDebug));
					/*right now I don't know all the failure modes 
					* so just indicate failure mode and exit */
					if(!errno) {
						perror("failed to allocate new tape data struct\n");
						exit(-1);
					}
					cursor->prev = node;
					node->next = cursor;
					cursor = node;
				} else {
					cursor = cursor->prev;
				}
				/*we dont care as much about overflows in the data tape index*/
				data_offset--;
				cursor->index--;
				fprintf(stdout, "a[%ld] = %ld\n", cursor->index, cursor->cell);
				instr_ptr++;
				break;
			case '[': /*JZ to just past matching ]*/
				if(cursor->cell == 0) {
					/*search for the matching tag in the buffer*/
					/*this is a strict interpreter, we don't store tags for jumps*/
					while(*instr_ptr++ != ']') {
						/*check for buffer overflow, it is legal c to point one past end
						* of buffer but we cannot dereference*/

					}
				} else {

				}
				break;
			case ']': /*JNZ to matching [*/
			case ',': /*Input a character and store it in the cell at the pointer*/
				errno = 0;
				rc = scanf("%c", &in_char);
				if(rc != 1) {
					if(errno == 0) {
						/*if errno is not set, we set it*/
						errno = EINVAL;
					}
					fprintf(stderr, "Input read of single char failed, instruction_offset = %lu", instruction_offset);
					perror("input read of single char failed\n");
					exit(-1);
				}
				/*print quickly*/
				fprintf(stdout, "input  = %c\n", in_char);
				fprintf(stdout, "a[%ld] = %u", cursor->index, (unsigned)in_char);

				break;
			case '.':
			case ';':
			case ':':
			case '#': /*pushes the current value in cell under pointer to stack*/
			case '$': /*pops the value from stack and overwrites the cell under the pointer*/
				break;
		}
	}
	return 0;
}