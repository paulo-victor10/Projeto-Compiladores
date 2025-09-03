# Makefile para o analisador léxico KamenRider

CC = gcc
FLEX = flex
CFLAGS = -Wall -g
LDFLAGS = -lfl

# Arquivos
LEXER_SOURCE = kamenrider.l
LEXER_OUTPUT = lex.yy.c
EXECUTABLE = kamenrider
TEST_FILE = codigo.krd

# Regra principal
all: $(EXECUTABLE)

# Compilar o analisador léxico
$(EXECUTABLE): $(LEXER_SOURCE)
	@echo "=== Compilando analisador léxico KamenRider ==="
	$(FLEX) $(LEXER_SOURCE)
	$(CC) $(CFLAGS) $(LEXER_OUTPUT) -o $(EXECUTABLE) $(LDFLAGS)
	@echo "=== Compilação concluída ==="

# Executar teste com arquivo
test: $(EXECUTABLE)
	@echo "=== Executando teste com arquivo $(TEST_FILE) ==="
	./$(EXECUTABLE) $(TEST_FILE)

# Executar com entrada interativa
run: $(EXECUTABLE)
	@echo "=== Executando analisador (entrada interativa) ==="
	./$(EXECUTABLE)

# Limpar arquivos gerados
clean:
	@echo "=== Limpando arquivos gerados ==="
	rm -f $(LEXER_OUTPUT) $(EXECUTABLE)
	@echo "=== Limpeza concluída ==="

# Mostrar ajuda
help:
	@echo "Comandos disponíveis:"
	@echo "  make all    - Compila o analisador léxico"
	@echo "  make test   - Executa teste com arquivo codigo.krd"
	@echo "  make run    - Executa com entrada interativa"
	@echo "  make clean  - Remove arquivos gerados"
	@echo "  make help   - Mostra esta ajuda"

.PHONY: all test run clean help