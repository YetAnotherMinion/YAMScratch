CXX?=g++

CXXFLAGS= -g -Wall -Wextra --pedantic-errors -std=c++11

all: bin/d2.out

bin/d2.out : src/dijkstra_2.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

