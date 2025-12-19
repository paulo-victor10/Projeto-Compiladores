%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

extern int linha;
extern FILE *yyin;
int yylex();
void yyerror(const char *s);

/* LISTA ENCADEADA E AST */

#define T_INT     1
#define T_REAL    2
#define T_STRING  3
#define T_VEC     4

typedef struct vars {
    char name[100];
    int type;
    double valor;           
    char str_val[256];      
    double *vetor;          
    int tam_vetor;
    struct vars *prox;
} VARIAVEL;

VARIAVEL *tabela_simbolos = NULL;

VARIAVEL* buscar_var(char *nome) {
    VARIAVEL *aux = tabela_simbolos;
    while(aux) {
        if(strcmp(aux->name, nome) == 0) return aux;
        aux = aux->prox;
    }
    return NULL;
}

VARIAVEL* criar_var(char *nome, int tipo, int tamanho) {
    VARIAVEL *v = buscar_var(nome);
    if(v) return v; 

    VARIAVEL *novo = (VARIAVEL*)malloc(sizeof(VARIAVEL));
    strcpy(novo->name, nome);
    novo->type = tipo;
    novo->valor = 0.0;
    novo->str_val[0] = '\0';
    novo->prox = tabela_simbolos;
    novo->tam_vetor = tamanho;
    
    if(tipo == T_VEC && tamanho > 0) {
        novo->vetor = (double*)calloc(tamanho, sizeof(double));
    } else {
        novo->vetor = NULL;
    }

    tabela_simbolos = novo;
    return novo;
}

/*  AST NODES */
typedef struct ast {
    int nodetype;
    struct ast *l;
    struct ast *r;
} Ast;

typedef struct numval {
    int nodetype;
    double number;
} NumVal;

typedef struct strval {
    int nodetype;
    char str[256];
} StrVal;

typedef struct varref {
    int nodetype;
    char name[100];
    Ast *index; 
} VarRef;

typedef struct flow {
    int nodetype;
    Ast *cond;
    Ast *tl; 
    Ast *el; 
} Flow;

typedef struct assign {
    int nodetype;
    char name[100];
    Ast *v;
    Ast *index;
} Assign;

/* PROTOTIPOS AST */
Ast* new_ast(int nt, Ast *l, Ast *r);
Ast* new_num(double d);
Ast* new_str(char *s);
Ast* new_ref(char *n, Ast *idx);
Ast* new_assign(char *n, Ast *val, Ast *idx);
Ast* new_flow(int nt, Ast *cond, Ast *tl, Ast *el);
double eval(Ast *a);
void free_ast(Ast *a);

/*  F-STRING */
void print_fstring_eval(const char *s, int newline) {
    const char *p = s;
    while(*p){ 
        if(*p == '{'){ 
            p++;
            char name[100];
            int i = 0;
            while(*p && *p != '}' && i < 99){
                name[i++] = *p++;
            }
            name[i] = '\0';
            if(*p == '}') p++;

            VARIAVEL *v = buscar_var(name);
            if(v) {
                if(v->type == T_STRING) printf("%s", v->str_val);
                else if(v->type == T_INT) printf("%.0f", v->valor);
                else printf("%.2f", v->valor);
            } else {
                printf("{%s}", name); 
            }
        } else {
            putchar(*p++);
        }
    }
    if(newline) putchar('\n');
}

%}

%union {
    double real;
    int inteiro;
    char string[256];
    struct ast *a;
}

%token <real> NUMBER_REAL NUMBER_INT
%token <string> STRING_LITERAL IDENTIFIER
%token BEGIN_PROGRAM END_PROGRAM 
%token READ_INPUT PRINT_OUTPUT PRINTLN_OUTPUT 
%token TYPE_REAL TYPE_INT TYPE_STRING
%token IF ELSE WHILE
%token SQRT_FUNC POW_FUNC
%token <inteiro> CMP

%right '='
%left CMP
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <a> stmt list expr print_list print_item

%%

program:
    BEGIN_PROGRAM list END_PROGRAM { if($2) { eval($2); free_ast($2); } }
    ;

list:
      stmt { $$ = $1; }
    | list stmt { $$ = new_ast('L', $1, $2); }
    ;

stmt:
      ';' { $$ = NULL; } 
    /* DECLARACOES */
    | TYPE_INT IDENTIFIER ';' { criar_var($2, T_INT, 0); $$ = NULL; }
    | TYPE_REAL IDENTIFIER ';' { criar_var($2, T_REAL, 0); $$ = NULL; }
    | TYPE_STRING IDENTIFIER ';' { criar_var($2, T_STRING, 0); $$ = NULL; }
    | TYPE_REAL IDENTIFIER '[' NUMBER_INT ']' ';' { criar_var($2, T_VEC, (int)$4); $$ = NULL; }
    | TYPE_INT IDENTIFIER '[' NUMBER_INT ']' ';' { criar_var($2, T_VEC, (int)$4); $$ = NULL; }

    /* ATRIBUICOES */
    | IDENTIFIER '=' expr ';' { $$ = new_assign($1, $3, NULL); }
    | IDENTIFIER '=' STRING_LITERAL ';' { $$ = new_assign($1, new_str($3), NULL); }
    | IDENTIFIER '[' expr ']' '=' expr ';' { $$ = new_assign($1, $6, $3); }

    /* CONTROLE DE FLUXO (FormChange / ClockUp) */
    | IF '(' expr ')' '{' list '}' { $$ = new_flow('I', $3, $6, NULL); }
    | IF '(' expr ')' '{' list '}' ELSE '{' list '}' { $$ = new_flow('I', $3, $6, $10); }
    | WHILE '(' expr ')' '{' list '}' { $$ = new_flow('W', $3, $6, NULL); }

    /* In/Out */
    | PRINT_OUTPUT '(' print_list ')' ';' { $$ = new_ast('P', $3, new_num(0)); }
    | PRINTLN_OUTPUT '(' print_list ')' ';' { $$ = new_ast('P', $3, new_num(1)); }
    
    | READ_INPUT '(' IDENTIFIER ')' ';' { $$ = new_ast('S', new_ref($3, NULL), NULL); }
    | READ_INPUT '(' IDENTIFIER '[' expr ']' ')' ';' { $$ = new_ast('S', new_ref($3, $5), NULL); }
    ;

print_list:
      print_item { $$ = $1; }
    | print_list ',' print_item { $$ = new_ast('l', $1, $3); }
    ;

print_item:
      expr { $$ = $1; }
    | STRING_LITERAL { $$ = new_str($1); }
    ;

expr:
      expr '+' expr { $$ = new_ast('+', $1, $3); }
    | expr '-' expr { $$ = new_ast('-', $1, $3); }
    | expr '*' expr { $$ = new_ast('*', $1, $3); }
    | expr '/' expr { $$ = new_ast('/', $1, $3); }
    | expr CMP expr { $$ = new_ast('0' + $2, $1, $3); } /* 1:==, 2:!= */
    | '(' expr ')'  { $$ = $2; }
    | SQRT_FUNC '(' expr ')' { $$ = new_ast('Q', $3, NULL); } 
    | POW_FUNC '(' expr ',' expr ')' { $$ = new_ast('^', $3, $5); }
    | IDENTIFIER { $$ = new_ref($1, NULL); }
    | IDENTIFIER '[' expr ']' { $$ = new_ref($1, $3); }
    | NUMBER_REAL { $$ = new_num($1); }
    | NUMBER_INT { $$ = new_num($1); }
    ;

%%

/* FUNCOES AST  */

Ast* new_ast(int nt, Ast *l, Ast *r) {
    Ast *a = malloc(sizeof(Ast));
    a->nodetype = nt; a->l = l; a->r = r;
    return a;
}
Ast* new_num(double d) {
    NumVal *a = malloc(sizeof(NumVal));
    a->nodetype = 'K'; a->number = d;
    return (Ast*)a;
}
Ast* new_str(char *s) {
    StrVal *a = malloc(sizeof(StrVal));
    a->nodetype = 'T'; strcpy(a->str, s);
    return (Ast*)a;
}
Ast* new_ref(char *n, Ast *idx) {
    VarRef *a = malloc(sizeof(VarRef));
    a->nodetype = 'V'; strcpy(a->name, n); a->index = idx;
    return (Ast*)a;
}
Ast* new_assign(char *n, Ast *val, Ast *idx) {
    Assign *a = malloc(sizeof(Assign));
    a->nodetype = '='; strcpy(a->name, n); a->v = val; a->index = idx;
    return (Ast*)a;
}
Ast* new_flow(int nt, Ast *cond, Ast *tl, Ast *el) {
    Flow *a = malloc(sizeof(Flow));
    a->nodetype = nt; a->cond = cond; a->tl = tl; a->el = el;
    return (Ast*)a;
}

double eval(Ast *a) {
    if(!a) return 0;
    double v1;
    VARIAVEL *var;

    switch(a->nodetype) {
        case 'K': return ((NumVal*)a)->number;
        
        case 'T': 
            return 0;

        case 'V': /* Uso de Variável */
            var = buscar_var(((VarRef*)a)->name);
            if(!var) { printf("Erro: Var '%s' nao declarada!\n", ((VarRef*)a)->name); return 0; }
            if(var->type == T_VEC) {
                int idx = (int)eval(((VarRef*)a)->index);
                if(idx < 0 || idx >= var->tam_vetor) { printf("Erro: SegFault Array\n"); return 0; }
                return var->vetor[idx];
            }
            return var->valor;

        case '=': /* Atribuicao */
            var = buscar_var(((Assign*)a)->name);
            if(!var) { printf("Erro: Var '%s' nao existe!\n", ((Assign*)a)->name); return 0; }
            
            /* Se for atribuicao de string literal */
            if( ((Assign*)a)->v->nodetype == 'T' ) {
                if(var->type == T_STRING) {
                    strcpy(var->str_val, ((StrVal*)((Assign*)a)->v)->str);
                } else {
                    printf("Erro: Atribuindo string para nao-string\n");
                }
                return 0;
            }

            v1 = eval(((Assign*)a)->v);
            if(var->type == T_VEC) {
                int idx = (int)eval(((Assign*)a)->index);
                 if(idx < 0 || idx >= var->tam_vetor) return 0;
                 var->vetor[idx] = v1;
            } else {
                var->valor = v1;
            }
            return v1;

        case '+': return eval(a->l) + eval(a->r);
        case '-': return eval(a->l) - eval(a->r);
        case '*': return eval(a->l) * eval(a->r);
        case '/': return eval(a->l) / eval(a->r);
        case '^': return pow(eval(a->l), eval(a->r)); /* POW_FUNC */
        case 'Q': return sqrt(eval(a->l)); /* SQRT_FUNC */
        
        /* Logica */
        case '0'+1: return eval(a->l) == eval(a->r);
        case '0'+2: return eval(a->l) != eval(a->r);
        case '0'+3: return eval(a->l) > eval(a->r);
        case '0'+4: return eval(a->l) < eval(a->r);
        case '0'+5: return eval(a->l) >= eval(a->r);
        case '0'+6: return eval(a->l) <= eval(a->r);

        case 'I': /* IF / FormChange */
            if( eval(((Flow*)a)->cond) != 0 ) {
                if(((Flow*)a)->tl) eval(((Flow*)a)->tl);
            } else {
                if(((Flow*)a)->el) eval(((Flow*)a)->el);
            }
            return 0;

        case 'W': /* WHILE / ClockUp */
            while( eval(((Flow*)a)->cond) != 0 ) {
                if(((Flow*)a)->tl) eval(((Flow*)a)->tl);
            }
            return 0;

        case 'L': eval(a->l); eval(a->r); return 0; /* Lista de statements */
        case 'l': eval(a->l); eval(a->r); return 0; /* Lista de prints */

        case 'P': /* PRINT (riderkick) */
            
            {
                /* Percorrer a arvore de prints a->l */
                Ast *curr = a->l;
                /* Logica simplificada: avalia recursivamente. Se for T, imprime fstring. Se K/V, imprime num. */
                
                /* Função auxiliar para processar nós de print sem quebra de linha */
                void print_node(Ast *n) {
                    if(!n) return;
                    if(n->nodetype == 'l') { print_node(n->l); print_node(n->r); return; }
                    
                    if(n->nodetype == 'T') {
                        print_fstring_eval(((StrVal*)n)->str, 0);
                    } else if(n->nodetype == 'V' && buscar_var(((VarRef*)n)->name)->type == T_STRING) {
                        printf("%s", buscar_var(((VarRef*)n)->name)->str_val);
                    } else {
                        double val = eval(n);
                        /* Verifica se é inteiro */
                        if(fabs(val - (int)val) < 1e-9) printf("%.0f", val);
                        else printf("%.2f", val);
                    }
                }
                print_node(curr);
                
                if(((NumVal*)a->r)->number == 1) printf("\n");
            }
            return 0;

        case 'S': /* SCANF (henshin) */
            var = buscar_var(((VarRef*)a->l)->name);
            if(var) {
                if(var->type == T_STRING) {
                    char buff[256];
                    scanf(" %[^\n]s", buff);
                    strcpy(var->str_val, buff);
                } else {
                    double val;
                    scanf("%lf", &val);
                    if(var->type == T_VEC) {
                        int idx = (int)eval(((VarRef*)a->l)->index);
                        var->vetor[idx] = val;
                    } else {
                        var->valor = val;
                    }
                }
            }
            return 0;
            
        default: printf("Erro interno: node %c\n", a->nodetype); return 0;
    }
}

void free_ast(Ast *a) {
    if(!a) return;
    free(a);
}

void yyerror(const char *s){
    fprintf(stderr, "ERRO SINTATICO: %s na linha %d\n", s, linha);
}

int validar_ext(const char *s) {
    const char *ext = strrchr(s, '.');
    return (ext && strcmp(ext, ".krd") == 0);
}

int main(int argc, char **argv){
    if(argc > 1){
        if(!validar_ext(argv[1])) {
             printf("Erro: Arquivo deve ser .krd\n"); return 1; 
        }
        FILE *f = fopen(argv[1], "r");
        if(!f){ printf("Erro ao abrir arquivo\n"); return 1; }
        yyin = f;
    }
    yyparse();
    return 0;
}