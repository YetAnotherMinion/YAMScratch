CXX?=g++

CXXFLAGS= -g -Wall -Wextra --pedantic-errors -std=c++14

all: bin/reverse-words.out

bin/reverse-words.out : src/reverse-words.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

