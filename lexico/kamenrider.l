%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int linha = 1;
%}

/* Estados */
%x COMMENT 

/* Definições Regulares */
LETRA       [a-zA-Z_]
DIGITO      [0-9]
ESPECIAL    [^a-zA-Z]

%%

#.* { /*comentario Ignorado em linha */ }

<INITIAL>">!"    { BEGIN(COMMENT); }
<COMMENT>"!<"    { BEGIN(INITIAL); }
<COMMENT>"\n"   { linha++; } 
<COMMENT>.      { /*Igorando comentario com quebra de linha (bloco)*/}

"StandingBy"        { printf("BEGIN_PROGRAM:\t\t%s\n", yytext); }
"Complete"           { printf("END_PROGRAM:\t\t%s\n", yytext); }
"henshin"            { printf("READ_INPUT:\t\t%s\n", yytext); }
"riderkick"         { printf("PRINT_OUTPUT:\t\t%s\n", yytext); }      

"++"        { printf("OP_INCREMENTO:\t\t%s\n", yytext); }
"+="        { printf("OP_ATRIBUICAO_COMPOSTA:\t%s\n", yytext); }
"--"        { printf("OP_DECREMENTO:\t\t%s\n", yytext); }
"-="        { printf("OP_ATRIBUICAO_COMPOSTA:\t%s\n", yytext); }
">="        { printf("OP_LOGICO:\t\t%s\n", yytext); }
"<="        { printf("OP_LOGICO:\t\t%s\n", yytext); }
"=="        { printf("OP_LOGICO:\t\t%s\n", yytext); }
"!="        { printf("OP_LOGICO:\t\t%s\n", yytext); }
"||"        { printf("OP_LOGICO:\t\t%s\n", yytext); }
"&&"        { printf("OP_LOGICO:\t\t%s\n", yytext); }

"&"         { printf("OP_MEMORIA: \t\t%s\n", yytext); }

"and"       { printf("OP_LOGICO:\t\t%s\n", yytext); }
"or"        { printf("OP_LOGICO:\t\t%s\n", yytext); }
"for"       { printf("REPETICAO:\t\t%s\n", yytext); }
"while"     { printf("REPETICAO:\t\t%s\n", yytext); }
"do"        { printf("REPETICAO:\t\t%s\n", yytext); }
"return"    { printf("RETURN:\t\t\t%s\n", yytext); }
"int"       { printf("TIPO:\t\t\t%s\n", yytext); }
"float"     { printf("TIPO:\t\t\t%s\n", yytext); }
"char"      { printf("TIPO:\t\t\t%s\n", yytext); }
"string"    { printf("TIPO:\t\t\t%s\n", yytext); }
"bool"      { printf("TIPO:\t\t\t%s\n", yytext); }
"true"      { printf("BOOLEANO:\t\t%s\n", yytext); }
"false"     { printf("BOOLEANO:\t\t%s\n", yytext); }
"if"        { printf("CONDICIONAL:\t\t%s\n", yytext); }
"else"      { printf("CONDICIONAL:\t\t%s\n", yytext); }


{LETRA}({LETRA}|{DIGITO})* { printf("ID:\t\t\t%s\n", yytext); }


{DIGITO}+\.{DIGITO}+        { printf("FLOAT:\t\t\t%s\n", yytext); }
{DIGITO}+                   { printf("INTEIRO:\t\t%s\n", yytext); }


\"([^"\n])*\"   { printf("STRING:\t\t\t%s\n", yytext); }
'([^'\n])'      { printf("CHAR:\t\t\t%s\n", yytext); }


"="         { printf("OP_ATRIBUICAO:\t\t%s\n", yytext); }
"+"         { printf("OP_ARITMETICO:\t\t%s\n", yytext); }
"*"         { printf("OP_ARITMETICO:\t\t%s\n", yytext); }
"-"         { printf("OP_ARITMETICO:\t\t%s\n", yytext); }
"/"         { printf("OP_ARITMETICO:\t\t%s\n", yytext); }
">"         { printf("OP_LOGICO:\t\t%s\n", yytext); }
"<"         { printf("OP_LOGICO:\t\t%s\n", yytext); }
"!"         { printf("OP_LOGICO:\t\t%s\n", yytext); }
"("         { printf("DELIMITADOR:\t\t%s\n", yytext); }
")"         { printf("DELIMITADOR:\t\t%s\n", yytext); }
"{"         { printf("DELIMITADOR:\t\t%s\n", yytext); }
"}"         { printf("DELIMITADOR:\t\t%s\n", yytext); }
","         { printf("DELIMITADOR:\t\t%s\n", yytext); }
";"         { printf("DELIMITADOR:\t\t%s\n", yytext); }
"\""        { printf("DELIMITADOR:\t\t%s\n", yytext); }
"'"         { printf("DELIMITADOR:\t\t%s\n", yytext); }


[ \t\r]+    { }
\n          { linha++; }


.           { printf("ERRO: Caractere nao reconhecido '%s' na linha %d\n", yytext, linha); }

%%


int yywrap() {
    return 1;
}

int main(int argc, char *argv[]) {
    FILE *arquivo;

    if (argc > 1) {
        arquivo = fopen(argv[1], "r");
        if (!arquivo) {
            printf("Erro ao abrir o arquivo %s\n", argv[1]);
            return 1;
        }
        yyin = arquivo;
        printf("=== Analise Lexica do arquivo: %s ===\n\n", argv[1]);
    } else {
        printf("=== Analise Lexica (entrada padrao) ===\n");
        printf("Digite o codigo (Ctrl+D para finalizar):\n\n");
    }

    yylex();

    if (argc > 1) {
        fclose(arquivo);
    }

    printf("\n=== Analise Lexica Concluida ===\n");
    return 0;
}