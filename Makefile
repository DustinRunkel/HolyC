CXX=clang
CC=clang
SRC=src 
EXE=build

HEADERS = $(wildcard include/*.h) $(wildcard include/*.hpp)
SOURCES = src/HolyC.tab.cpp src/HolyC.yy.cpp
GRAMMAR = src/HolyC.l src/HolyC.y

LIBS=`llvm-config --libs core native --ldflags` -lpthread -ldl -lz -ltinfo
CFLAGS=-Wall -g  -DLEFTTORIGHT `llvm-config --cxxflags`

.PRECIOUS: $(SRC) $(INCLUDE) $(GRAMMAR)

all: yacc objects

yacc:
	bison -d src/HolyC.y
	mv HolyC.tab.c src/HolyC.tab.cpp
	mv HolyC.tab.h include/HolyC.tab.h

	flex src/HolyC.l
	mv lex.yy.c src/HolyC.yy.cpp

objects: $(HEADERS) $(SOURCES)
	$(CXX) -I./include/ $(SOURCES) $(CFLAGS) $(LIBS) -o HolyC
	mv HolyC build/
clean:
	rm -f src/HolyC.yy.cpp src/HolyC.tab.cpp include/HolyC.tab.h