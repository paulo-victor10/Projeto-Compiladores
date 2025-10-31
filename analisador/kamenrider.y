%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>


double variaveis[26];

int yylex();
void yyerror(const char *s){ fprintf(stderr, "SYNTAX ERROR: %s\n", s); }

extern FILE *yyin;

void print_real(double valor) {
    if (fabs(valor - (int)valor) < 1e-9) //muito proximo de ser inteiro
        printf("%.0f", valor); //printa sem casa decimal
    else
        printf("%.2f", valor);
}

void print_fstring(const char *s, int newline) {
    const char *p = s; //primeiro caractere de s
    while(*p){ //percorrendo s até o final, caractere por caractere

        if(*p == '{'){ //se achou uma chave vai copiar o que tem dentro dela pra name
            p++;
            char name[64];
            int i = 0;
            
            while(*p && *p != '}' && i < 63){
                name[i++] = *p++;
            }

            name[i] = '\0';
            if(*p == '}') p++;
            
            if(strlen(name) == 1 && name[0] >= 'a' && name[0] <= 'z'){ //se name for uma das variaveis reservadas a-z
                int idx = name[0] - 'a';
                print_real(variaveis[idx]); //printa o valor que tem naquele index correspondente a variavel
            } 
            else {
                printf("{%s}", name); //se for uma string entre chaves ele vai só printar normalmente
            }

        } else {
            putchar(*p++); //enquanto nao achou uma chave ele vai so printar caractere por caractere
        }
    }
    if(newline) putchar('\n');
}
%}


%union {
    double real;
    int integer;
    char string[256];
}

%left '+' '-'
%left '*' '/'
%token BEGIN_PROGRAM END_PROGRAM READ_INPUT PRINT_OUTPUT PRINTLN_OUTPUT REAL_TYPE
%token <integer> ID
%token <real> NUMBER
%token <string> STRING
%token <string> CHAR
%token SQRT_FUNC POW_FUNC
%token '(' ')' ',' ';' '='


%type <real> expr

%%

program:
    BEGIN_PROGRAM statements END_PROGRAM
    ;

statements:
    | statements statement
    ;

statement:
      declaration ';'
    | assignment ';'
    | read_stmt ';'
    | print_stmt ';'
    ;

declaration:
    REAL_TYPE var_list
    | REAL_TYPE init_list
    ;

init_list:
      ID '=' expr { variaveis[$1] = $3; }
    | init_list ',' ID '=' expr { variaveis[$3] = $5; }
    ;

var_list:
      ID { variaveis[$1] = 0.0; }
    | var_list ',' ID { variaveis[$3] = 0.0; }
    ;

assignment:
    ID '=' expr { variaveis[$1] = $3; }
    ;

read_stmt:
    READ_INPUT '(' ID ')' { if(scanf("%lf", &variaveis[$3]) != 1) variaveis[$3] = 0.0; }
    ;

print_stmt:
    PRINT_OUTPUT '(' print_list ')' { }
    | PRINTLN_OUTPUT '(' print_list ')' { putchar('\n'); /*imprime um único quebra de linha*/ }
    ;

print_list:
      print_item { }
    | print_list ',' print_item { }
    ;

print_item:
      STRING { print_fstring($1, 0); }
    | CHAR { print_fstring($1, 0); }
    | ID { print_real(variaveis[$1]); }
    | expr { print_real($1); }
    ;

expr:
      expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { $$ = $1 / $3; }
    | '(' expr ')'  { $$ = $2; }
    | SQRT_FUNC '(' expr ')' { $$ = sqrt($3); }
    | POW_FUNC '(' expr ',' expr ')' { $$ = pow($3, $5); }
    | NUMBER        { $$ = $1; }
    | ID            { $$ = variaveis[$1]; }
    ;

%%

int main(int argc, char *argv[]){
    if(argc > 1){
        FILE *f = fopen(argv[1], "r");
        if(!f){ fprintf(stderr, "Erro ao abrir arquivo %s\n", argv[1]); return 1; }
        yyin = f;
    }
    yyparse();
    return 0;
}
