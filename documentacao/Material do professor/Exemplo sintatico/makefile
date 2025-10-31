all : lexico.l sintatico.y
	clear
	flex -i lexico.l
	bison -d sintatico.y
	gcc sintatico.tab.c -o MeuPrimeiroCompilador -lfl -lm
	./MeuPrimeiroCompilador