%{
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <stack>
#include <map>
#include <vector>
#include "mem/MemoryControl.h"
#include <utility>
#include <iostream>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

void yyerror(char * s);
int yylex(void);

MemoryControl* memory;

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
     struct environment* env = (struct environment *)malloc(sizeof(struct environment));
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
struct window{
     struct Point *size;
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
     struct component* c = (struct component *)malloc(sizeof(struct component));
     components[compnr++] = c;
     c->name = name;
     if (strcmp(name, "win")==0)
          c->value = (struct window *)malloc(sizeof(struct window));
     last_comp = c;
}

void exitComp()
{
     free(components[compnr]);
     compnr--;
     if (compnr>0)
          last_comp = components[compnr-1];
}

extern void createWindow(struct window *win);
extern void applyProperty(char* p, struct component* last, char* value);
extern int assign(char* identifier, Point* value, struct environment* env, int overwrite);
extern int getById(char* identifier, struct environment* env, struct environment* consts);
extern void printEnv(struct environment* env);
extern void debug();

%}

%union {
     int intval;
     char* strval;
     class Point* pval;
}

%token TIP BGIN END ASSIGN PROCENT POINT MAIN RETURN LOOP POOL IF FI FOR ROF IN ELSE PRINT

%token <intval> NR
%token <strval> PROPERTY
%token <strval> STRING
%token <strval> ID
%type <pval> expression
%type <pval> Point
%type <pval> position

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

define: '.' ID '=' expression ';' {
          //if (!assign($2, $4, consts, 0)) printf("Nu s-a putut asigna la identificatorul %s: exista deja o constanta cu acelasi nume\n", $2);
          if (memory->defineConstant(string($2), $4) == false)
               std::cout<<"Nu s-a putut asigna la identificatorul "<< $2 <<": exista deja o constanta cu acelasi nume\n"
     }
      | '.' ID '=' STRING ';'
      | function_decl
      | '#' ID '(' expression ';' ')' content
;

function_decl: 
      '.' ID '(' ')' {enterEnv();} '{' stmt_sequence '}' {printf("In functia %s am avut:\n", $2); printEnv(last_env); printf("Din care globale:\n"); memory->printConstants(); exitEnv();}
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
    | ID '=' expression ';'
    | RETURN expression ';'
    | RETURN expression ';'
    | RETURN STRING ';'
    | PRINT '(' expression ')' ';'{printf("Am printat: %d\n", $3->x);}
    ;

param_list: ID
          | ID ',' param_list
          ;

main_body: {enterComp("win");} MAIN '(' expression ';' ')' content {struct window *win = (struct window *)(last_comp->value);win->size=$4; createWindow(win); exitComp();}
         ;

content: ';'
       | '{' declaratii '}'
       | '{' '}'
       ;

declaratii:  declaratie
          | declaratie declaratii
	     ;

declaratie: ID ID '(' expression ';' position ')' content
          | ID ID '(' ';' position ')' content
          | ID '=' expression ';' 
          | ID '=' STRING ';'
          | PROPERTY '=' expression ';'
          | PROPERTY '=' STRING ';' {char* prop = ($1)+1; char* value = $3+1; value[strlen(value)-1]=0; applyProperty(prop, last_comp, value);}
          ;

position: POINT '=' expression
        | expression {$$ = $1;}
        ;

expression: expression '+' expression {Point& a=*($1); Point&b=*($3); $$ = a+b;}
          | expression '-' expression {Point& a=*($1); Point&b=*($3); $$ = a-b;}
          | expression '*' expression {Point& a=*($1); Point&b=*($3); $$ = a*b;}
          | expression '/' expression {Point& a=*($1); Point&b=*($3); $$ = a/b;}
          | '(' expression ')'
          | ID {$$ = new Point(getById($1, last_env, consts), 0);}
          | ID '[' NR ']'
          | NR {$$ = new Point($1, 0);}
          | PROCENT
          | ID '(' param_list_oncall ')'
          | ID '(' ')'
          | Point {struct Point *ans;  ans=$1; $$ = $1;}
          ;

Point: POINT 
   | '{' expression ',' expression '}' {struct Point *ans = (struct Point *)malloc(sizeof(struct Point)); ans->x=$2->x; ans->y=$4->x; $$ = ans;}
   ;

param_list_oncall: expression
                 | expression ',' param_list_oncall
                 ;

%%
void yyerror(char * s){
     printf("eroare: %s la linia:%d\n",s, yylineno);
}

int main(int argc, char** argv){
     yyin=fopen(argv[1],"r");
     struct environment* c = (struct environment *)malloc(sizeof(struct environment));
     consts = c;
     memory = new MemoryControl();
     enterEnv();
     yyparse();
     exitEnv();
} 
