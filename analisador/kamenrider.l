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
        start = 2; end = tam - 1;  //pula f
    } else if (s[0] == '\"' && s[tam-1] == '\"') {
        start = 1; end = tam - 1;  
    } else {
        start = 0; end = tam;
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

%option noyywrap
%x COMMENT

DIGITO      [0-9]
LETRA       [a-zA-Z_]
ID          {LETRA}({LETRA}|{DIGITO})*
REAL        {DIGITO}+\.{DIGITO}+
INT         {DIGITO}+

%%

[ \t\r]+                { }
\n                      { linha++; }

#.* { }
<INITIAL>">!"           { BEGIN(COMMENT); }
<COMMENT>"!<"           { BEGIN(INITIAL); }
<COMMENT>\n             { linha++; }
<COMMENT>.              { }

"StandingBy"            { return BEGIN_PROGRAM; }
"Complete"              { return END_PROGRAM; }

"henshin"               { return READ_INPUT; }
"riderkick"             { return PRINT_OUTPUT; }
"riderkickln"           { return PRINTLN_OUTPUT; }

"real"                  { return TYPE_REAL; }
"int"                   { return TYPE_INT; }
"string"                { return TYPE_STRING; }

"FormChange"            { return IF; }
"BaseForm"              { return ELSE; }
"ClockUp"               { return WHILE; }

"krb"                   { return SQRT_FUNC; /*esse é o kamen rider raiz de verdade*/} 
"krx"                   { return POW_FUNC; /*metal hero vestido de kamen rider*/ }

{REAL}                  { yylval.real = atof(yytext); return NUMBER_REAL; }
{INT}                   { yylval.real = atof(yytext); return NUMBER_INT; }

[fF]?\"([^"\n])*\"      {
                            char *s = remover_aspas(yytext);
                            strncpy(yylval.string, s, sizeof(yylval.string)-1);
                            yylval.string[sizeof(yylval.string)-1] = '\0';
                            free(s);
                            return STRING_LITERAL;
                        }

{ID}                    { 
                            strncpy(yylval.string, yytext, sizeof(yylval.string)-1);
                            yylval.string[sizeof(yylval.string)-1] = '\0';
                            return IDENTIFIER; 
                        }

"=="                    { yylval.inteiro = 1; return CMP; }
"!="                    { yylval.inteiro = 2; return CMP; }
">"                     { yylval.inteiro = 3; return CMP; }
"<"                     { yylval.inteiro = 4; return CMP; }
">="                    { yylval.inteiro = 5; return CMP; }
"<="                    { yylval.inteiro = 6; return CMP; }

"="                     { return '='; }
"+"                     { return '+'; }
"-"                     { return '-'; }
"*"                     { return '*'; }
"/"                     { return '/'; }
"("                     { return '('; }
")"                     { return ')'; }
"{"                     { return '{'; }
"}"                     { return '}'; }
"["                     { return '['; }
"]"                     { return ']'; }
","                     { return ','; }
";"                     { return ';'; }

.                       { printf("ERRO LEXICO: '%s' na linha %d\n", yytext, linha); }

%%