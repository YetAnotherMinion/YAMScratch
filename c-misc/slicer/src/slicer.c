#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
/*gives strlen*/
#include <string.h>
/*convert the endianess of stl to host*/
#include <endian.h>
/*testing file permissions*/
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
/*command line argument parsing library*/
#include <argp.h>
/*lets us accumulate arguments in struct arguments*/
#include <argz.h>
/*gives bzero*/
#include <strings.h>

#include "slicerBinaryReader.h"
#include "slicerConstants.h"
#include "slicerTypes.h"
#include "badVertexVector.h"


/*Hold a variable length of arguments passed to the program
works kind of like std::vector*/
struct Arguments {
	char *argz;
	size_t argz_len;
};

struct Parameters {
	struct Arguments args;
	float h;
	uint8_t debug;
	uint8_t force;
};

/*Forward Function Declarations*/
static int parse_opt(int key, char *arg, struct argp_state *state);
static int verify_extension(const char* filename, const size_t fn_len, \
							const char* extension, const size_t ex_len);


int main(int argc, char** argv) {
	/*This struct is where we define every parameter to the function*/
	struct argp_option options[] = 
	{
		/*format is given by:
		{long option name,short option integer,type of required option
		for the parameter (0 means not required),(Enum for option visibility), group id}*/
		{0,0,0,0, "Suggested:", 7},
		{"height", 'h',"NUM", 0, "Set the layer height of each slice"},
		{"force", 'f', 0, 0, "Force overwriting of output files if they exist"},
		{0,0,0,0, "Optional:", -1},
		{"debug",'d',0 , OPTION_ARG_OPTIONAL, "Display debug output"},
		{"easter", 0, 0, OPTION_HIDDEN, "Easter egg"},
		{0}
	};
	/*This is where we add the arguments*/
	struct argp argp = {options, parse_opt,"FILENAME [OUTPUT DIR]", \
	"Slice the input STL file and output a DXF file for each and every slice. \
	Output files are named FILENAME_slice(n).dxf where (n) is the layer.\v \
	File permissions will be checked."};
	/*Initialize and fill in our callback struct to use instead of globals*/
	struct Parameters params;
	params.h = 0;
	params.debug = 0;
	/*Check that all of the arguments parsed correctly*/
	error_t rc;
	rc = argp_parse(&argp, argc, argv, 0,0, &params);
	if(rc < 0) {
		fprintf(stderr, "Argp returned error code: %d\n",rc );
		free(params.args.argz);
		exit(1);
	} 
	const char *prev = NULL;
	char *fn;
	fn = argz_next(params.args.argz, params.args.argz_len, prev);
	prev = fn;
	char *out_dir;
	/*create the default directory as the current directory*/
	if( 0 == (out_dir = argz_next(params.args.argz, params.args.argz_len, prev))) {
		out_dir = ".";
	} 
	prev = NULL;

	char *exten_caps = ".STL";
	char *exten_lower = ".stl";
	size_t fn_len = strlen(fn);

	if( verify_extension(fn, fn_len, exten_caps, strlen(exten_caps)) \
		|| verify_extension(fn, fn_len, exten_lower, strlen(exten_lower))) {
		/*check the file for permissions*/
		int n;
		struct stat *file_info = (struct stat*)malloc(sizeof(struct stat));
		n = stat(fn, file_info);
		if(n < 0) {
			fprintf(stderr, "Improper input filename\n");
			free(file_info);
			free(params.args.argz);
			exit(1);
		} else {
			/*Nothing here for now*/
			free(file_info);
			file_info = NULL;
		}
		/*Now check that the destination is valid*/
		struct stat *dir_info = (struct stat*) malloc(sizeof(struct stat));
		n = stat(out_dir, dir_info);
		if(n < 0) {
			fprintf(stderr, "Improper output directory");
			free(dir_info);
			free(params.args.argz);
			exit(1);
		} else {
			if(S_ISDIR(dir_info->st_mode) == 0 ) {
				fprintf(stderr, "ERROR: <%s> is not a directory\n", out_dir);
				free(dir_info);
				free(params.args.argz);
				exit(1);
			}
			free(dir_info);
			dir_info = NULL;
		}
	} else {
		fprintf(stderr, "File must be a .STL or .stl\n");
		free(params.args.argz);
		exit(1);
	}

	rc = parseBinarySTL(fn, (uint8_t) params.debug);

	//rc = foo();
	
	printf("%d\n",rc );
	/*remember that argz creates something like a std::vector and we must free it*/
	free(params.args.argz);
	return 0;
}

const char *argp_program_bug_address = "yetanotherminion@gmail.com";
const char *argp_program_version = 
"YAM Slicer, version 0.1 -devel (x86_64-redhat-linux-gnu)\n\
Copyright (C) 2016 Th!nk Inc\n\
License DWTFYWEFM: Do What The Fuck You Want Except For Microsoft\n\
\n\
This is free software; you are free to change and redistribute it.\n\
There is NO WARRANTY, to the extent permitted by law.";

static int
parse_opt(int key, char *arg, struct argp_state *state) {
	struct Parameters *par = static_cast<struct Parameters*>(state->input);
	struct Arguments *a = &(par->args);
	float *layer_height = &(par->h);
	switch(key) {
		case 'h': {
			*layer_height = atof(arg);
			break;
		} case 'd': {
			par->debug = 1;
			break;
		} case 'f': {
			par->force = 1;
		} case ARGP_KEY_INIT: {
			a->argz = 0;
			a->argz_len = 0;
			break;
		} case ARGP_KEY_ARG: {
			/*add to the struct arguments we made earlier*/
			argz_add(&a->argz, &a->argz_len, arg);
			break;
		} case ARGP_KEY_END: {
			size_t count = argz_count(a->argz,a->argz_len);
			if(count > MAX_ARGUMENTS) {
				argp_failure(state,1, 0, "Too many arguments");
			} else if(count < MIN_ARGUMENTS) {
				argp_failure(state, 1, 0, "Not enough arguments");
			}
			break;
		}
	}
	return 0;
}

static int
verify_extension(const char* filename, const size_t fn_len, \
	const char* extension, const size_t ex_len) {
	/*test the end filename for a match with the extension passed in*/
	if(ex_len > fn_len) {
		/*we will not bother to check anything for a partial match*/
		return 0;
	}
	unsigned int start_fn_index = fn_len - ex_len;
	for(int i = 0; i < (int)ex_len; ++i) {
		if(extension[i] != filename[start_fn_index + i]) {
			return 0;
		}
	}
	return 1;
}
