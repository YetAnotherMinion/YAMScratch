CONFIG?=config.mk
include $(CONFIG)

BIN ?= bin
SRC ?= src
OBJ ?= obj
INC ?= inc
LDIR ?= lib

CC ?= gcc
CXX ?= clang++
export OMPI_CXX=clang++
export OMPI_CC=clang
#-Werror
CXXFLAGS = -Wall -Wextra --pedantic-errors -g -std=c++14
#add option to include mpi flags
MPICC_CXXFLAGS= $(CXXFLAGS)
MPICC_CXXFLAGS+= $(shell mpicc -showme:compile)

MPICC_LDFLAGS= $(LDFLAGS)
MPICC_LDFLAGS+= $(shell mpicc -showme:link)

LIBS = -L $(LDIR)

# Where to find user code.
USER_DIR = $(GTEST_DIR)/samples

# Flags passed to the preprocessor.
# Set Google Test's header directory as a system directory, such that
# the compiler doesn't generate warnings in Google Test headers.
CPPFLAGS += -isystem $(GTEST_DIR)/include -isystem $(GTEST_DIR) 

# Flags passed to the C++ compiler.
# 	Unused function is turned off because of the macros which implement generic types
# 	define everythin even if we only want to use one
CXXFLAGS += -g -Wall -Wextra -pthread --pedantic-errors -Wno-unused-function

# All tests produced by this Makefile.  Remember to add new tests you
# created to the list.
TESTS =

# All Google Test headers.  Usually you shouldn't change this
# definition.
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
				$(GTEST_DIR)/include/gtest/internal/*.h

# House-keeping build targets.
test : $(TESTS)

# Builds gtest.a and gtest_main.a.

# Usually you shouldn't tweak such internal variables, indicated by a
# trailing _.
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

# For simplicity and to avoid depending on Google Test's
# implementation details, the dependencies specified below are
# conservative and not optimized.  This is fine as Google Test
# compiles fast and for ordinary users its source rarely changes.
$(OBJ)/gtest-all.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
			$(GTEST_DIR)/src/gtest-all.cc -o $@

$(OBJ)/gtest_main.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
			$(GTEST_DIR)/src/gtest_main.cc -o $@

$(LDIR)/gtest.a : $(OBJ)/gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

$(LDIR)/gtest_main.a : $(OBJ)/gtest-all.o $(OBJ)/gtest_main.o
	$(AR) $(ARFLAGS) $@ $^

#========================================
# 			UTILITY FUNCTIONS
#========================================

#========================================
# 		CODE ABBEY PROBLEMS SETS
#========================================

1 : $(BIN)/1.out

$(BIN)/1.out : $(SRC)/1.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

65 : $(BIN)/65.out

$(BIN)/65.out : $(SRC)/65.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

clean :
	rm -vf $(TESTS) $(LDIR)/gtest.a $(LDIR)/gtest_main.a $(OBJ)/*.o $(BIN)/*
