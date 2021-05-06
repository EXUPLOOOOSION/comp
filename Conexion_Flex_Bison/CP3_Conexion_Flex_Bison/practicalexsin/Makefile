CFLAGS=-Wall

all: parser prueba

clean:
	rm parser.cpp parser.hpp parser tokens.cpp *~ 

parser.cpp: parser.y
	bison -d -o $@ $^

parser.hpp: parser.cpp

tokens.cpp: tokens.l parser.hpp
	lex -o $@ $^

parser: parser.cpp main.cpp tokens.cpp
	g++ $(CFLAGS) -o $@ *.cpp 

prueba:  parser ../pruebaMala1.in ../pruebaMala2.in ../pruebaBien1.in ../pruebaBien2.in
	./parser <../pruebaMala1.in
	./parser <../pruebaMala2.in
	./parser <../pruebaBien1.in
	./parser <../pruebaBien2.in
