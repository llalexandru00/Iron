/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TIP = 258,
    BGIN = 259,
    END = 260,
    ASSIGN = 261,
    PROCENT = 262,
    POINT = 263,
    MAIN = 264,
    RETURN = 265,
    LOOP = 266,
    POOL = 267,
    IF = 268,
    FI = 269,
    FOR = 270,
    ROF = 271,
    IN = 272,
    ELSE = 273,
    PRINT = 274,
    NR = 275,
    PROPERTY = 276,
    STRING = 277,
    ID = 278
  };
#endif
/* Tokens.  */
#define TIP 258
#define BGIN 259
#define END 260
#define ASSIGN 261
#define PROCENT 262
#define POINT 263
#define MAIN 264
#define RETURN 265
#define LOOP 266
#define POOL 267
#define IF 268
#define FI 269
#define FOR 270
#define ROF 271
#define IN 272
#define ELSE 273
#define PRINT 274
#define NR 275
#define PROPERTY 276
#define STRING 277
#define ID 278

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 76 "fe.y" /* yacc.c:1909  */

     int intval;
     struct tuple *tupleval;
     char* strval;

#line 106 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
