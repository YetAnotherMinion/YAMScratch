BIN = ./bin
OBJ = ./obj
SRC = ./src
INC = ./include
CFLAGS = -Wall -g --pedantic-errors -Wextra -std=c++0x
# $< is the source  $@ is the target

#LIST = $(BIN)/hw1
#LIST = $(BIN)/hw2
#LIST = $(BIN)/hw3
LIST = $(BIN)/hw1 $(BIN)/hw2 $(BIN)/hw3 $(BIN)/hw6 

all: $(LIST)

$(BIN)/hw1 : $(SRC)/hw1.cpp \
			$(SRC)/ellipse.cpp
	$(CXX) $(CFLAGS) -I $(INC) $^  -o $@ 

$(BIN)/hw2 : $(SRC)/hw2.cpp \
			$(SRC)/bowling_frame.cpp \
			$(SRC)/bowling_player.cpp \
			$(SRC)/bowling_game.cpp \
			$(SRC)/parser_bowling.cpp
	$(CXX) $(CFLAGS) -I $(INC) $^ -o $@

$(BIN)/hw3 : $(SRC)/main3.cpp
	$(CXX) $(CFLAGS) -I $(INC) $< -o $@



#======================================================

#compile and link with this step
$(BIN)/hw6 : $(OBJ)/hw6.o $(OBJ)/carcassonne_placeTile.o
	$(CXX) $(CFLAGS) $^ $(CFLAGS) -o $@


#compiles all of the object files here
$(OBJ)/hw6.o : $(SRC)/hw6.cpp
	$(CXX) $(CFLAGS) -I $(INC) -c $< -o $@


$(OBJ)/carcassonne_placeTile.o : $(SRC)/carcassonne_placeTile.cpp
	$(CXX) $(CFLAGS) -I $(INC) -c $< -o $@

clean:
	$(RM) $(LIST) $(OBJ)/*