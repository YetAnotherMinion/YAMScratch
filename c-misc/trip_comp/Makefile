
INC = 

CPPFLAGS = 
# Flags passed to the C++ compiler.
CXXFLAGS += -g -Wall -Wextra -pthread --pedantic-errors --std=c++11

stage_0 : stage_0.cc
	g++ $(CPPFLAGS) $(CXXFLAGS) $(INC) $< -o $@


stage_1 : stage_1.cc
	g++ $(CPPFLAGS) $(CXXFLAGS) $(INC) $< -o $@