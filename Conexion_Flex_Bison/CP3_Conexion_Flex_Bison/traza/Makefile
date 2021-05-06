CFLAGS=-Wall

all: traza prueba

clean:
	rm traza traza.cpp *~

traza.cpp: traza.l traza.hpp
	lex -o $@ traza.l

traza: traza.cpp 
	g++ $(CFLAGS) -o $@ *.cpp -ll

prueba:  traza ../prueba1.in ../prueba2.in ../pruebamala1.in
	./traza <../prueba1.in
	./traza <../prueba2.in
	./traza <../pruebamala1.in
