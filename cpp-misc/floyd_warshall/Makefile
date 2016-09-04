CXX?=g++

CXXFLAGS= -g -Wall -Wextra --pedantic-errors -std=c++11

all: bin/fw.out

bin/fw.out : src/floyd_warshall.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

