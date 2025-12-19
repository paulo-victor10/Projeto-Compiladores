CC = gcc
FLEX = flex
BISON = bison
CFLAGS = -Wall -lm

EXEC = kamenrider
TEST = codigo.krd

all: $(EXEC)

# AQUI ESTAVA O ERRO: Adicionamos lex.yy.c ao comando do gcc
$(EXEC): kamenrider.tab.c lex.yy.c
	$(CC) kamenrider.tab.c lex.yy.c -o $(EXEC) $(CFLAGS)

kamenrider.tab.c: kamenrider.y
	$(BISON) -d kamenrider.y

# Garante que o bison rode antes do flex para criar o .h
lex.yy.c: kamenrider.l kamenrider.tab.c
	$(FLEX) kamenrider.l

run: $(EXEC)
	./$(EXEC) $(TEST)

clean:
	rm -f lex.yy.c kamenrider.tab.c kamenrider.tab.h $(EXEC)

.PHONY: all run clean