%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

extern void createWindow();
extern void applyProperty();
extern int assign();
extern int checkFree();
extern int getById();
extern void printEnv();

struct environment{
     char *identifiers[256];
     int ints[256];
     int nrints;
};
struct environment* envs[256];
struct environment* last_env;
struct environment* consts;
int envnr;

void enterEnv()
{
     struct environment* env = (void *)malloc(sizeof(struct environment));
     envs[envnr++] = env;
     last_env = env;
}

void exitEnv()
{
     free(envs[envnr]);
     envnr--;
     if (envnr>0)
          last_env = envs[envnr-1];
}


struct tuple{int x, y;};
struct window{
     struct tuple *size;
     char* caption;
};
struct component{
     char* name;
     void* value;
};

struct component* components[256];
struct component* last_comp;
int compnr;

void enterComp(char* name)
{
     struct component* c = (void *)malloc(sizeof(struct component));
     components[compnr++] = c;
     c->name = name;
     if (strcmp(name, "win")==0)
          c->value = (void *)malloc(sizeof(struct window));
     last_comp = c;
}

void exitComp()
{
     free(components[compnr]);
     compnr--;
     if (compnr>0)
          last_comp = components[compnr-1];
}

%}

%union {
     int intval;
     struct tuple *tupleval;
     char* strval;
}

%token TIP BGIN END ASSIGN PROCENT POINT MAIN RETURN LOOP POOL IF FI FOR ROF IN ELSE PRINT

%token <intval> NR
%token <strval> PROPERTY
%token <strval> STRING
%token <strval> ID
%type <intval> expression
%type <tupleval> tup_expression
%type <tupleval> tup
%type <tupleval> position

%start progr
%left '+' '-'
%left '*' '/'
%%

progr: multiple_define main_body
     | main_body
     ;

multiple_define: define
               | define multiple_define
               ;

define: '.' ID '=' tup_expression ';'
      | '.' ID '=' expression ';' {if (!assign($2, $4, consts, 0)) printf("Nu s-a putut asigna la identificatorul %s: exista deja o constanta cu acelasi nume\n", $2);}
      | '.' ID '=' STRING ';'
      | function_decl
      | '#' ID '(' tup_expression ';' ')' content
;

function_decl: 
      '.' ID '(' ')' {enterEnv();} '{' stmt_sequence '}' {printf("In functia %s am avut:\n", $2); printEnv(last_env); printf("Din care globale:\n"); printEnv(consts); exitEnv();}
      |'.' ID '(' param_list ')' {enterEnv();} '{' stmt_sequence '}' {exitEnv();}
;

stmt_sequence: stmt
             | stmt stmt_sequence
             ;

stmt: IF '(' expression ')' stmt_sequence FI
    | IF '(' expression ')' stmt_sequence ELSE stmt_sequence FI
    | LOOP '(' expression ')' stmt_sequence POOL
    | FOR '(' ID IN expression '~' expression ')' stmt_sequence ROF
    | ID '=' expression ';' {assign($1, $3, last_env, 1);}
    | ID '=' tup_expression ';'
    | RETURN expression ';'
    | RETURN tup_expression ';'
    | RETURN STRING ';'
    | PRINT '(' expression ')' ';'{printf("Am printat: %d\n", $3);}
    ;

param_list: ID
          | ID ',' param_list
          ;

main_body: {enterComp("win");} MAIN '(' tup_expression ';' ')' content {struct window *win = (struct window *)(last_comp->value); win->size=$4; createWindow(win); exitComp();}
         ;

content: ';'
       | '{' declaratii '}'
       | '{' '}'
       ;

declaratii:  declaratie
          | declaratie declaratii
	     ;

declaratie: ID ID '(' tup_expression ';' position ')' content
          | ID ID '(' ';' position ')' content
          | ID '=' expression ';' 
          | ID '=' tup_expression ';'
          | ID '=' STRING ';'
          | PROPERTY '=' expression ';'
          | PROPERTY '=' tup_expression ';'
          | PROPERTY '=' STRING ';' {char* prop = ($1)+1; char* value = $3+1; value[strlen(value)-1]=0; applyProperty(prop, last_comp, value);}
          ;

position: POINT '=' tup_expression
        | tup_expression {$$ = $1;}
        ;

tup_expression: tup_expression '+' tup_expression
          | tup_expression '-' tup_expression
          | tup_expression '*' tup_expression
          | tup_expression '/' tup_expression
          | '(' tup_expression ')' {$$ = $2;}
          | ID
          | ID '[' NR ']'
          | tup {struct tuple *ans;  ans=$1; $$ = $1;}
          ;

expression: expression '+' expression {$$ = $1 + $3;}
          | expression '-' expression {$$ = $1 - $3;}
          | expression '*' expression {$$ = $1 * $3;}
          | expression '/' expression {$$ = $1 / $3;}
          | '(' expression ')'
          | ID {$$ = getById($1, last_env, consts);}
          | ID '[' NR ']'
          | NR {$$ = $1;}
          | PROCENT
          | ID '(' param_list_oncall ')'
          | ID '(' ')'
          ;

tup: POINT 
   | '{' expression ',' expression '}' {struct tuple *ans = malloc(sizeof(struct tuple)); ans->x=$2; ans->y=$4; $$ = ans;}
   ;

param_list_oncall: expression
                 | expression ',' param_list_oncall
                 ;

%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
     yyin=fopen(argv[1],"r");
     struct environment* c = (void *)malloc(sizeof(struct environment));
     consts = c;
     enterEnv();
     yyparse();
     exitEnv();
} 