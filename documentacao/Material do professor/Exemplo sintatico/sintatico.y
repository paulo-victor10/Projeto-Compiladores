%{
    #include<stdio.h>
    #include<string.h>

    float variaveis[26];

    int yylex();
    void yyerror (char *s){
        printf ("%s\n",s);
    }
   
%}

%union {
    int inteiro;
    char string[100];
    float real;
}

%token <real> NUM
%token <inteiro> VARS
%token <string> TXT

%token INI FIM MOSTRAR LEITURA MOSTRART

%left '+' '-'
%left '*' '/'

%type <real> E
%%

program: INI start FIM;

start: lst_cmdos start
    | lst_cmdos
    ;

lst_cmdos: VARS '=' E {
    variaveis[$1] = $3;
    }
    | MOSTRAR '(' lista ')' 
    | LEITURA '(' VARS ')' {
        scanf("%f",&variaveis[$3]);
    }
    ;

lista:          lista ',' E {printf("%.2f",$3);}
            |   E {printf("%.2f",$1);}
            |   lista ',' TXT {printf("%s",$3);}
            |   TXT {printf("%s",$1);}
            ;


E:      E '+' E {$$ = $1 + $3;}
    |   E '*' E {$$ = $1 * $3;}
    |   E '-' E {$$ = $1 - $3;}
    |   E '/' E {$$ = $1 / $3;}
    |   '(' E ')' {$$ = $2;}
    |   NUM {$$ = $1;}
    |   VARS{ $$ = variaveis[$1]; }
    ;

%%

#include "lex.yy.c"

int main(){
    yyin = fopen("codigofonte.txt","r");
    yyparse();
    fclose(yyin);
    return 0;
}

