CXX?=g++

CXXFLAGS= -g -Wall -Wextra --pedantic-errors -std=c++14

all: bin/quick_sort.out bin/insertion_sort.out

bin/quick_sort.out : src/quick_sort.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

bin/insertion_sort.out : src/insertion_sort.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
