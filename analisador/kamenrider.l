%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kamenrider.tab.h"

int linha = 1;

char* remover_aspas(const char* s){
    int tam = strlen(s);
    if (tam < 2){
        char *scopy = malloc(1);
        if (scopy) scopy[0] = '\0';
        return scopy;
    }

    int start = 0;   
    int end = tam-1; 

    
    if ((s[0] == 'f' || s[0] == 'F') && s[1] == '\"') {
        start = 2;      //pula f
        end = tam - 1;  
    } else if (s[0] == '\"' && s[tam-1] == '\"') {
        start = 1;      
        end = tam - 1;  
    } else {
        
        start = 0;
        end = tam;
    }

    int newlen = end - start;
    if (newlen < 0) newlen = 0;
    char *scopy = malloc(newlen + 1);
    if (!scopy) return NULL;
    if (newlen > 0) memcpy(scopy, s + start, newlen);
    scopy[newlen] = '\0';
    return scopy;
}
%}

%x COMMENT

DIGITO      [0-9]
LETRA       [a-zA-Z_]
ID_LET      [a-z]
INT_PART    {DIGITO}+
REAL_PART   {DIGITO}+\.{DIGITO}+

%%

#.*                     { }
<INITIAL>">!"           { BEGIN(COMMENT); }
<COMMENT>"!<"           { BEGIN(INITIAL); }
<COMMENT>\n             { linha++; }
<COMMENT>.              { }

"StandingBy"            { return BEGIN_PROGRAM; }
"Complete"              { return END_PROGRAM; }
"henshin"               { return READ_INPUT; }
"riderkickln"           { return PRINTLN_OUTPUT; }
"riderkick"             { return PRINT_OUTPUT; }
"real"                  { return REAL_TYPE; }
"krb"                   { return SQRT_FUNC; /*esse é o kamen rider raiz de verdade*/ }
"krx"                   { return POW_FUNC; /*metal hero vestido de kamen rider*/ }

{REAL_PART}             { yylval.real = atof(yytext); return NUMBER; }
{INT_PART}              { yylval.real = atof(yytext); return NUMBER; }

[fF]?\"([^"\n])*\"      {
                            char *s = remover_aspas(yytext);
                            strncpy(yylval.string, s, sizeof(yylval.string)-1);
                            yylval.string[sizeof(yylval.string)-1] = '\0';
                            free(s);
                            return STRING;
}


'([^'\n])'              {
                            char tmp[2];
                            tmp[0] = yytext[1];
                            tmp[1] = '\0';
                            strncpy(yylval.string, tmp, sizeof(yylval.string) - 1);
                            yylval.string[sizeof(yylval.string) - 1] = '\0';
                            return CHAR;
                        }

{ID_LET}({LETRA}|{DIGITO})* {
                            yylval.integer = yytext[0] - 'a';
                            return ID;
                        }

"("                      { return '('; }
")"                      { return ')'; }
","                      { return ','; }
";"                      { return ';'; }
"="                      { return '='; }
"+"                      { return '+'; }
"-"                      { return '-'; }
"*"                      { return '*'; }
"/"                      { return '/'; }




[ \t\r]+                 { }
\n                       { linha++; }

.                        { printf("ERRO: Caractere nao reconhecido '%s' na linha %d\n", yytext, linha); }

%%

int yywrap() { return 1; }
