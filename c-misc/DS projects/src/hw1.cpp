#include <iostream>
#include <istream>
#include <stdlib.h>
#include <assert.h>
#include <string>
#include <fstream>
#include <stdint.h>

#include "../include/ellipse.h"

using namespace std;

//create a linked list to store each point as it is created
//we will never insert into this list
//simple implementaation is fine
//afterwards we will walk along and delete every node
int output_ellipse_moire(short width, short height, string pattern, ofstream & file)
{
	//set the border character here
	const char border = '*';
	//use a non printing control character to make the outline
	const char first_pass = 1;

	//we pass in the tail so that we can run this function and the generator in separate threads
	int x_offset = (width+1)%2;
	int y_offset = (height+1)%2;
	//we do not need a 
	char ** output_buffer = new char*[height];
	for(uint32_t ii = 0; ii < height; ++ii) {
		output_buffer[ii] = new char[width+1];
	}
	//char output_buffer[height][width+1]; //add room for null terminator
	for(int i = 0; i < height; i++)
	{
		for(int j =0; j < width; j++)
		{
			output_buffer[i][j] = ' ';
		}
		output_buffer[i][width] = '\x0';
	}
	//reverse the elements
	EllipsePoint * tail = new EllipsePoint;
	//create new thread here
	EllipsePoint * head = calculate_ellipse(height, width,tail);
	head = NULL; //head is not used here

	//we reverse the order of the x and y so that the tail has
	//the minimum x coordinate in the y
	//in effect we are reflecting about the y =x axis to increment
	//by x while the algorithim is incrementing y
	while (tail != NULL)
	{
		int x = tail->y; //swap the x and y
		int y = tail->x;
		signed int x_quadrants[4] = {(x - x_offset + width)>>1,\
									(-x - x_offset + width)>>1,\
									(x - x_offset + width)>>1,\
									(-x - x_offset + width)>>1};
		signed int y_quadrants[4] = {(-y - y_offset + height)>>1,\
									(-y - y_offset + height)>>1,\
									(y - y_offset + height)>>1,\
									(y - y_offset + height)>>1};

		for(char i = 0; i < 4; i++)
		{
			int x_index = x_quadrants[i];
			int y_index = y_quadrants[i];
			output_buffer[y_index][x_index] = first_pass; //use a nonprinting control character
			if (x_index >= width>>1)
			{
				//null terminate the string, because x coord is strictly increasing
				//a null will be overwritten if a point has a greater x_coord 
				output_buffer[y_index][x_index+1] = '\x0';
			}
		}
		
		if(tail->prev != NULL)
		{
			tail = tail->prev; // move to next point
			//cout << "now on ";
			//EllipsePoint_print(tail);
			//cout << "deleting ";
			//EllipsePoint_print(tail->next);
			EllipsePoint_destroy(tail->next); // free the memory
			tail->next = NULL;
		}
		else
		{
			//cout << "final delete";
			//EllipsePoint_print(tail);
			EllipsePoint_destroy(tail);
			tail = NULL;
		}
	}
	assert(tail == NULL);
	//get the length of the pattern
	size_t ring_length = pattern.length();
	// fill in the pattern
	int crossing_count;
	int pattern_index = 0;
	for(int i = 0; i < height; i++)
	{
		crossing_count = 0;
		bool crossing_flag = false;
		//the rows
		for(int j = 0; j < width; j++)
		{
			if (output_buffer[i][j] == first_pass)
			{
				if(!crossing_flag) crossing_flag = true;
				output_buffer[i][j] = border; //remap the border
			}
			else if (output_buffer[i][j] == '\x0')
			{
				break;
			}
			else if(crossing_flag)
			{
				crossing_flag = false;
				crossing_count++;
			}

			if (crossing_count%2 && !crossing_flag)
			{
				output_buffer[i][j] = pattern[pattern_index];
				pattern_index = (pattern_index + 1)%ring_length;
			}
		}
	}
	//print out the output
	for(int j = 0;j<height;j++)
	{
		//file << output_buffer[j] << endl;
		//cout << output_buffer[j] << endl;
	}
	for(uint32_t ii = 0; ii < height; ++ii) {
		delete[] output_buffer[ii];
	}
	delete[] output_buffer;
	return 0;
}

int output_right_triangle_moire(int height, string pattern, ofstream & file)
{
	char border = '*';
	size_t ring_length = pattern.length();
	int pattern_index = 0;
	for(int i = 0; i < height; i++)
	{
		char *buffer = new char[i+1];
		buffer[0] = border;
		buffer[i] = border;
		buffer[i+1] = '\x0';
		for(int j = 1;j < i;j++)
		{
			if (i != height-1)
			{
				buffer[j] = pattern[pattern_index];
				pattern_index = (pattern_index+1)%ring_length;
			}
			else
			{
				buffer[j] = border;
			}
		}
		cout << buffer << endl;
		file << buffer << endl;
		delete[] buffer;
	}
	
	return 0;
}

int output_isosceles_triangle(int height, string pattern, ofstream & file)
{
	char border = '*';
	size_t ring_length = pattern.length();
	int pattern_index = 0;
	for(int i = 0; i < height; i++)
	{
		char *buffer = new char[(height + i +1)]; //leave room for the null terminator
		int left = height-i-1;
		int right = height+ i -1;
		//cout << left << "," << right << endl;
		buffer[right] = border;
		//cout << height +i << endl;
		buffer[height + i] = '\x0';
		for(int j = 0; j < right; j++)
		{
			//cout << j << endl;
			if(i != height -1)
			{
				if (j < left)
				{
					buffer[j] = ' ';
				}
				else if (j == left)
				{
					buffer[j] = border;
				}
				else
				{
					buffer[j] = pattern[pattern_index];
					pattern_index = (pattern_index+1)%ring_length;
				}
			}
			else
			{
				buffer[j] = border;
			}
		}
		cout << buffer << endl;
		file << buffer << endl;
		delete[] buffer;
	}	
	return 0;
}

int output_square(int height, string pattern, ofstream  &  file)
{
	char border = '*';
	//ofstream file(filename.c_str());
	size_t ring_length = pattern.length();
	int pattern_index = 0;
	for(int i = 0; i < height; i++)
	{
		char *buffer = new char[height+1];
		buffer[height] = '\x0'; //null terminate
		buffer[height-1] = border;
		buffer[0] = border;
		for(int j = 1; j < height-1;j++)
			{
			if( i == 0 || i == height - 1)
			{
				buffer[j] = border;
			}
			else
			{
				buffer[j] = pattern[pattern_index];
				pattern_index = (pattern_index+1)%ring_length;
			}
		}
		cout << buffer << endl;
		delete[] buffer;
	}
	return 0;
}

int output_bat_symbol(short height, string pattern, ofstream & out_ptr)
{
	return 0;
}

void print_commands(string wrong_command)
{
	cerr << '<' << wrong_command << "> Is not a valid command" << endl << endl;
	cerr << "Commands:" << endl;
	cerr << "  square \t\t" << endl;
	cerr << "  right_triangle\tplaceholder" << endl;
	cerr << "  isoceles_triangle\tplaceholder" << endl;
}

void print_usage(void)
{
	cerr << endl;
}

int main(int argc, char *argv[])
{
	if (argc == 5)
	{
		//assign the
		string pattern = string(argv[1]);
		string string_height = string(argv[2]);
		int height = atoi(string_height.c_str());
		string command = string(argv[3]);
		//cout << pattern << height << command  << out_filename << endl;
		ofstream out_str(argv[4]);
		if(!out_str.good())
		{	
			cerr << "Failed to open output file: " << argv[4] <<endl;
			return 1; // indicate failure to open stream
		}
		//select from the commands available
		if (command == string("bat"))
		{
			cout << "Im batman" << endl;
		}
		else if (command == string("square"))
		{
			ofstream file(argv[4]);
			int code = output_square(height,pattern, out_str);
			return code;
		}
		else if (command == string("right_triangle"))
		{
			int code = output_right_triangle_moire(height,pattern,out_str);
			return code;
		}
		else if (command == string("isosceles_triangle"))
		{
			int code = output_isosceles_triangle(height, pattern, out_str);
			return code;
		}
		else if (command == string("circle"))
		{
			int code = output_ellipse_moire(height,height,pattern,out_str);
			return code;
		}
		else if (command == string("ellipse"))
		{
			int code = output_ellipse_moire(80,height,pattern,out_str);
			return code;
		}
		else //default
		{
			print_commands(command);
			exit(1);
		}
		return 0;

	}
	else if (argc == 1)
	{
		//will return NULL if a or b is larger than 0x7FFF
		unsigned short a = 0x7FFF;
		unsigned short b = 0x7FFF;

		unsigned short c = 30;
		EllipsePoint * tail = new EllipsePoint;
		EllipsePoint * head = calculate_ellipse(a,b,tail);
		if (head == NULL)
		{
			return 1;
		}
		EllipsePoint_print(tail);
		EllipsePoint_print(tail->prev);
		EllipsePoint_print(head);
		//clean up the ellipse

		return 0;
	}
}
