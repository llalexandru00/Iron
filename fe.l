%{
#include <stdio.h>
#include "y.tab.h"
%}

%%
"int"|"float"|"char"|"string" {return TIP;}
"begin_progr" {return BGIN;}
"end_progr" {return END;}
"main" {return MAIN;}
"return" {return RETURN;}
"in" {return IN;}
"for" {return FOR;}
"rof" {return ROF;}
"loop" {return LOOP;}
"pool" {return POOL;}
"if" {return IF;}
"else" {return ELSE;}
"fi" {return FI;}
"print" {return PRINT;}
(\$|\^)[0-9]+ {return POINT;}
\$[_a-zA-Z][_a-zA-Z0-9]* {yylval.strval=strdup(yytext); return PROPERTY;}
\".*\" {yylval.strval=strdup(yytext); return STRING;}
[_a-zA-Z][_a-zA-Z0-9]* {yylval.strval=strdup(yytext); return ID;}
":=" {return ASSIGN;}
[0-9]+\% {return PROCENT;}
[0-9]+ {yylval.intval=atoi(yytext); return NR;}
[ \t] ;
. {return yytext[0];}

 
