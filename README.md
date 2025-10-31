# Projeto da Disciplina de Compiladores - IFCE Aracati

![Status](https://img.shields.io/badge/status-em%20andamento-yellow)

## 📖 Sobre o Projeto

Este repositório contém todos os materiais de estudo e o código-fonte para o projeto da disciplina de **Compiladores**, parte do curso de **Bacharelado em Ciência da Computação** no IFCE Campus Aracati.

O objetivo do projeto é aplicar os conceitos teóricos da construção de compiladores, passando por todas as etapas do processo: análise léxica, sintática, semântica e geração de código. A ferramenta principal utilizada para as fases iniciais é o **GALS - Gerador de Analisadores Léxicos e Sintáticos**.

## 📂 Estrutura do Repositório

* `/documentacao`: Contém os materiais de apoio, como livros, slides da disciplina e tutoriais das ferramentas.
* `/gals`: Contém o arquivo `.gals` com a especificação léxica e, futuramente, a especificação sintática do projeto.
* `/analisador`: Contém o código-fonte do analisador léxico (`.l`), analisador sintático (`.y`), um código de teste de entrada, o `makefile` e o executável da linguagem "KamenRider".
* `README.md`: Este arquivo com a descrição do projeto.

## 🚀 Andamento do Projeto

O desenvolvimento segue a ementa da disciplina, com as seguintes etapas planejadas:

-   [x] **Análise Léxica:** Definição dos tokens da linguagem (palavras-chave, operadores, identificadores, etc.).
-   [x] **Análise Sintática:** Implementação da gramática da linguagem para validação de estruturas.
-   [ ] **Análise Semântica:** Construção da árvore sintática e verificação de tipos e escopo.
-   [ ] **Geração de Código Intermediário.**
-   [ ] **Desenvolvimento do Mini-Compilador (Projeto Final).**

## 🔧 Como Compilar e Executar o Analisador Léxico

Para compilar e executar o analisador léxico, navegue até o diretório `/analisador` e utilize os seguintes comandos `make`:

* **Compilar o projeto:**
    ```bash
    make clean
    make
    ```

* **Executar o analisador com um arquivo de teste:**
    O comando abaixo executará o analisador utilizando o arquivo `codigo.krd` como entrada.
    ```bash
    make test
    ```

* **Executar em modo interativo:**
    Você pode inserir o código diretamente no terminal para ser analisado.
    ```bash
    make run
    ```

* **Limpar os arquivos gerados:**
    Remove o executável e outros arquivos gerados durante a compilação.
    ```bash
    make clean
    ```

