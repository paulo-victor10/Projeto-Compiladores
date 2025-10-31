%{
    #include<string.h>
%}

DIG [0-9]+\.?[0-9]*
VARS [a-z]
INI "BEGIN"
FIM "END"
MOSTRAR "exibir"
LEITURA "ler"
TXT \".*\"

%%

{TXT} {
    //retirar as aspas duplas do yytext
    strcpy(yylval.string,yytext);
    return TXT;
}

{INI} {
    return INI;
}

{FIM} {
    return FIM;
}

{MOSTRAR} {
    return MOSTRAR;
}

{LEITURA} {
    return LEITURA;
}

{VARS} {
    yylval.inteiro = *yytext - 'a';
    return VARS;
}

{DIG} {
    yylval.real = atof(yytext);
    return NUM;
}


"+" {return '+';}
"-" {return '-';}
"*" {return '*';}
"/" {return '/';}
"(" {return '(';}
")" {return ')';}
"=" {return '=';}
"," {return ',';}
[\ \n\t]* {;}

%%