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

prueba:  parser Pruebas/pruebaMala1.in Pruebas/pruebaMala2.in Pruebas/pruebaBien1.in Pruebas/pruebaBien2.in
	./parser <Pruebas/pruebaMala1.in
	./parser <Pruebas/pruebaMala2.in
	./parser <Pruebas/pruebaBien1.in
	./parser <Pruebas/pruebaBien2.in
