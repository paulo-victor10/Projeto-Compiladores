CC = gcc
FLEX = flex
BISON = bison
CFLAGS = -Wall -g
LDFLAGS = -lfl -lm

LEX_SRC = kamenrider.l
Y_SRC = kamenrider.y
EXEC = kamenrider
TEST = codigo.krd

all: $(EXEC)

kamenrider.tab.c kamenrider.tab.h: $(Y_SRC)
	$(BISON) -d $(Y_SRC)

lex.yy.c: $(LEX_SRC) kamenrider.tab.h
	$(FLEX) $(LEX_SRC)

$(EXEC): kamenrider.tab.c lex.yy.c
	$(CC) $(CFLAGS) kamenrider.tab.c lex.yy.c -o $(EXEC) $(LDFLAGS)

run: $(EXEC)
	./$(EXEC)

test: $(EXEC)
	./$(EXEC) $(TEST)

clean:
	rm -f lex.yy.c kamenrider.tab.c kamenrider.tab.h $(EXEC)

.PHONY: all run test clean
