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
          if (memory->defineConstant(string($2), $4) == false)
               std::cout<<"Nu s-a putut asigna la identificatorul "<< $2 <<": exista deja o constanta cu acelasi nume\n"
     }
      | '.' ID '=' STRING ';'
      | function_decl
      | '#' ID '(' expression ';' ')' content
;

function_decl: 
      '.' ID '(' ')' {memory->enterEnv();} '{' stmt_sequence '}' {printf("In functia %s am avut:\n", $2); memory->printAll(); memory->exitEnv();}
      |'.' ID '(' param_list ')' {memory->enterEnv();} '{' stmt_sequence '}' {memory->exitEnv();}
;

stmt_sequence: stmt
             | stmt stmt_sequence
             ;

stmt: IF '(' expression ')' stmt_sequence FI
    | IF '(' expression ')' stmt_sequence ELSE stmt_sequence FI
    | LOOP '(' expression ')' stmt_sequence POOL
    | FOR '(' ID IN expression '~' expression ')' stmt_sequence ROF
    | ID '=' expression ';' {memory->assign(string($1), $3);}
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

expression: expression '+' expression {Point& a=*($1); Point& b=*($3); $$ = a+b;}
          | expression '-' expression {Point& a=*($1); Point& b=*($3); $$ = a-b;}
          | expression '*' expression {Point& a=*($1); Point& b=*($3); $$ = a*b;}
          | expression '/' expression {Point& a=*($1); Point& b=*($3); $$ = a/b;}
          | '(' expression ')'
          | ID '@' ID {Point *ans = new Point(0, 0);  $$ = ans;}
          | ID {$$ = memory->get(string($1));}
          | ID '[' NR ']'
          | NR {$$ = new Point($1, 0);}
          | PROCENT
          | ID '(' param_list_oncall ')' {Point *ans = new Point(0, 0);  $$ = ans;}
          | ID '(' ')' {Point *ans = new Point(0, 0);  $$ = ans;}
          | Point {Point *ans;  ans=$1; $$ = $1;}
          ;

Point: POINT 
   | '{' expression ',' expression '}' {$$ = new Point($2->toInt(), $4->toInt());}
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
     memory = new MemoryControl();
     yyparse();
} 
