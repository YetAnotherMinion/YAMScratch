#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <deque>
#include <queue>
#include <set>
#include <map>
#include <algorithm>
#include <functional>
#include <utility>
#include <cmath>
#include <cstdlib>
#include <ctime>
#include <cstdio>
#include <stdint.h>
#include <cstring>
#include <exception>

using namespace std;

#define REP(i,n) for((i)=0;(i)<(int)(n);(i)++)
#define foreach(c,itr) for(__typeof((c).begin()) itr=(c).begin();itr!=(c).end();itr++)

typedef long long ll;
#define MOD 1000003ll

#define ERROR_CODE 42
#define WALL_CHAR 'W'
#define NO_WALL 'Y'
#define PASSAGE_CHAR '_'
#define CORNER_CHAR '+'

/*this definition of struct should maintain the invariant
* that if cell A links to cell B, then cell B should correspondingly
* link back to cell A. The printing function relies on this being true
* This more complicated struct is chosen over a char array because we
* will need to find the shorted path when the maze is finished
*/
enum MazeDirections {LEFT=0, UP=1, RIGHT=2, DOWN=3};

struct MazeCell {
	MazeCell() {
		for(uint32_t ii = 0; ii < 4; ++ii) {
			this->connected[ii] = NULL;
			this->possible[ii] = NO_WALL;
		}
		distance = -1; /*set equal to max uint*/
		visited = 0; /*not visited*/
	}
	/*these pointers define the possible locations
	* of up, down, left, right*/
	struct MazeCell* connected[4];
	char possible[4];
	uint32_t visited;
	uint32_t distance;
};

struct Maze {
	/*the assumuption is the inital maze area will always be rectangular*/
	Maze(uint32_t w, uint32_t h) : width(w), height(h) {
		/*cells are stored in width*ii + jj row format*/
		this->cells = new struct MazeCell[width * height];
		/*now link all of the MazeCells into the shape of the walls*/
		for(uint32_t ii = 0; ii < height; ++ii) {
			for(uint32_t jj = 0; jj < width; ++jj) {
				uint32_t indx = ii * width + jj;
				/*top wall*/
				if(0 == ii){
					this->cells[indx].connected[UP] = NULL;
					this->cells[indx].possible[UP] = WALL_CHAR;
					if(0 == jj) {
						this->cells[indx].possible[UP] = NO_WALL;
					}
				} else {
					
				}
				/*left wall*/
				if(0 == jj) {
					this->cells[indx].connected[LEFT] = NULL;
					this->cells[indx].possible[LEFT] = WALL_CHAR;
				}
				/*bottom wall*/
				if((height-1) == ii) {
					this->cells[indx].connected[DOWN] = NULL;
					this->cells[indx].possible[DOWN] = WALL_CHAR;
					if(width-1 == jj) {
						this->cells[indx].possible[DOWN] = NO_WALL;
					}
				}
				/*right wall*/
				if((width-1) == jj) {
					this->cells[indx].connected[RIGHT] = NULL;
					this->cells[indx].possible[RIGHT] = WALL_CHAR;
				}
			}
		}
	}
	~Maze() {
		if(NULL != this->cells) {
			delete[] this->cells;
		}
	}

	void link(uint32_t A, uint32_t B, enum MazeDirections dir, char wall) {
		/*A is the source, linking to B*/
		MazeDirections opposite;
		switch(dir) {
			case LEFT:
				opposite = RIGHT;
				break;
			case RIGHT:
				opposite = LEFT;
				break;
			case UP:
				opposite = DOWN;
				break;
			case DOWN:
				opposite = UP;
				break;
		}
		this->cells[A].possible[dir] = wall;
		this->cells[B].possible[opposite] = wall;
		this->cells[A].connected[dir] = &(this->cells[B]);
		this->cells[B].connected[opposite] = &(this->cells[A]);
	}

	void print_maze() {
		/*do a hacky thing and use two char buffers*/
		uint32_t buff_sz = width*2 + 2;
		char* top_buffer = new char[buff_sz]; 
		char* middle_buffer = new char[buff_sz];
		char* bottom_buffer = NULL;
		/*memset to space for testing while printing
		* below should set every indx except for the 
		* null terminator*/
		memset(top_buffer, '#', buff_sz-1);
		top_buffer[buff_sz-1] = '\0';
		memset(middle_buffer, '#', buff_sz-1);
		middle_buffer[buff_sz-1] = '\0';
		for(uint32_t ii = 0; ii < this->height; ++ii) {
			for(uint32_t jj = 0; jj < this->width; ++jj) {
				uint32_t indx = ii * width + jj;
				char A, B;
				if(WALL_CHAR == this->cells[indx].possible[LEFT]) {
					middle_buffer[2*jj] = '|';
					if(WALL_CHAR == this->cells[indx].possible[UP]) {
						top_buffer[2*jj + 1] = '-';
						top_buffer[2*jj] = '+';
					} else {
						top_buffer[2*jj + 1] = PASSAGE_CHAR;
						top_buffer[2*jj] = '|';
					}
				} else {
					middle_buffer[2*jj] = PASSAGE_CHAR;
					if(WALL_CHAR == this->cells[indx].possible[UP]) {
						top_buffer[2*jj + 1] = '-';
						top_buffer[2*jj] = '-';
					} else {
						top_buffer[2*jj + 1] = PASSAGE_CHAR;
					}
				}
				/*===============================*/
				if(WALL_CHAR == this->cells[indx].possible[RIGHT]) {
					middle_buffer[2*jj + 2] = '|';
					if('-' == top_buffer[2*jj + 1]) {
						top_buffer[2*jj + 2] = '+';
					} else {
						top_buffer[2*jj + 2] = '|';
					}
				} else {
					middle_buffer[2*jj + 2] = PASSAGE_CHAR;
					if('-' == top_buffer[2*jj + 1]) {
						top_buffer[2*jj + 2] = '-';
					} else {
						top_buffer[2*jj + 2] = PASSAGE_CHAR;
					}
				}
				middle_buffer[2*jj + 1] = '0';
			}
			cout << top_buffer << endl;
			cout << middle_buffer << endl;
		}
		for(uint32_t ll = 0; ll < width; ++ll) {
			uint32_t indx = (height-1) * width + ll;
			if(WALL_CHAR == this->cells[indx].possible[DOWN]){
				top_buffer[2*jj+1] = '-';
				if(WALL_CHAR == this->cells[indx].possible[LEFT]) {
					top_buffer[2*jj] = '+';
				} else {
					top_buffer[2*jj] = '-';
				}
				if(WALL_CHAR == this->cells[indx].possible[RIGHT]) {
					top_buffer[2*jj + 2] = '+';
				} else {
					top_buffer[2*jj + 2] = '-';
				}
			} else {
				top_buffer[2*jj + 1] = PASSAGE_CHAR;
				if(WALL_CHAR == this->cells[indx].possible[RIGHT]) {
					if('+' == top_buffer[2*jj]) {
						
					}
				}
			}
		}
		cout << top_buffer << endl;
		delete[] top_buffer;
		delete[] middle_buffer;
		delete[] bottom_buffer;
	}

	uint32_t width;
	uint32_t height;
	struct MazeCell* cells = NULL;
};

enum MazeLengthSpec{EQUAL, LESS, GREATER, NOT_SET};



int main(int argc, char const *argv[])
{
	uint32_t width, height;
	width = 0;
	height = 0;
	/*there must be 3-5 arguments*/
	if(argc < 3 || argc > 4) {
		cout << "usage: generatemaze width height [[<|>]pathlength]" << endl;
		return ERROR_CODE;
	}
	width = atoi(argv[1]);
	if(0 == width) {
		cout << "width must be an integer in form of 1234.." << endl;
		return ERROR_CODE;
	}
	height = atoi(argv[2]);
	if(0 == height) {
		cout << "height must be an integer in form of 1234.." << endl;
		return ERROR_CODE;
	}
	/*desired maze length is 0 for no specification, however
	* we set it to max length so we can check for incorrect
	* integer arguments passed as target length which atoi
	* will return 0 when integer could not be parsed. Zero is
	* not a valid value for the target length anyway, so we don't
	* loose any information*/
	uint32_t length_limit = -1; /*only valid for unsigned types*/
	MazeLengthSpec length_flag = NOT_SET;
	/*check for a path length specification*/
	if(4 == argc) {
		/*inspect the first character of the fourth arg,
		* if it is '<' then enter less than mode*/
		switch(argv[0][0]) {
			case '<':
				length_flag = LESS;
				break;
			case '>':
				length_flag = GREATER;
				break;
			default:
				length_flag = EQUAL;
				break;

		}
		length_limit = atoi(argv[3]); /*atoi will ignore the delimeter character*/
	}
	/*check that a valid length limit was parsed by atoi*/
	if(0 == length_limit) {
		cout << "must enter a valid integer length in form [<|>]1234.." << endl;
		return ERROR_CODE;
	}
	/*now check that length limit is actually a valid length*/
	uint32_t max_limit, min_limit;
	min_limit = width + height -1;
	if((0 == width%2) && (0 == height%2)) {
		/*there will always be an awkward corner piece we cannot use*/
		max_limit = (width * height) - 2; 
	} else {
		max_limit = (width * height) - 1;
	}

	if(GREATER == length_flag) {
		/*requested minium path is greater size than size of spanning*/
		if((width * height)+1 < length_limit) {
			return ERROR_CODE;
		}
	} else if(EQUAL == length_flag) {

	} else if(LESS == length_flag) {
		/*check that minimum size is smaller than less-1*/
		if((width + height - 1) >= length_limit) {
			cout << "requested path length of less than" << length_limit
				<< " is smaller than physical minium of " << (width + height - 1)
				<< endl;
			return ERROR_CODE;
		}
	}
	Maze mymaze(width, height);
	mymaze.print_maze();
	return 0;
}
