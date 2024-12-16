CXX=gcc
CC=clang
SRC=src 
EXE=build

HEADERS = $(wildcard include/*.h) $(wildcard include/*.hpp)
SOURCES = src/HolyC.tab.cpp src/HolyC.yy.cpp
GRAMMAR = src/HolyC.l src/HolyC.ypp

LIBS=`llvm-config --libs core native  --ldflags ` -lpthread -ldl -lz -ltinfo
CFLAGS=-Wall -g  -DLEFTTORIGHT  `llvm-config --cxxflags` -std=c++20 

.PRECIOUS: $(SRC) $(INCLUDE) $(GRAMMAR)

all: yacc objects

yacc:
	bison -d src/HolyC.ypp
	mv HolyC.tab.cpp src/HolyC.tab.cpp
	mv HolyC.tab.hpp include/HolyC.tab.hpp

	flex src/HolyC.l
	mv lex.yy.c src/HolyC.yy.cpp

objects: $(HEADERS) $(SOURCES)
	$(CXX) -I./include/ $(SOURCES) $(CFLAGS) $(LIBS) -o HolyC
	mv HolyC build/
clean:
	rm -f src/HolyC.yy.cpp src/HolyC.tab.cpp include/HolyC.tab.hpp build/HolyC