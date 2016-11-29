CXX?=g++

CXXFLAGS= -g -Wall -Wextra --pedantic-errors -std=c++14

all: bin/peer.out

bin/peer.out : src/pong-peer.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

