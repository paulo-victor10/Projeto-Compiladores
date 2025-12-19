/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_KAMENRIDER_TAB_H_INCLUDED
# define YY_YY_KAMENRIDER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    NUMBER_REAL = 258,             /* NUMBER_REAL  */
    NUMBER_INT = 259,              /* NUMBER_INT  */
    STRING_LITERAL = 260,          /* STRING_LITERAL  */
    IDENTIFIER = 261,              /* IDENTIFIER  */
    BEGIN_PROGRAM = 262,           /* BEGIN_PROGRAM  */
    END_PROGRAM = 263,             /* END_PROGRAM  */
    READ_INPUT = 264,              /* READ_INPUT  */
    PRINT_OUTPUT = 265,            /* PRINT_OUTPUT  */
    PRINTLN_OUTPUT = 266,          /* PRINTLN_OUTPUT  */
    TYPE_REAL = 267,               /* TYPE_REAL  */
    TYPE_INT = 268,                /* TYPE_INT  */
    TYPE_STRING = 269,             /* TYPE_STRING  */
    IF = 270,                      /* IF  */
    ELSE = 271,                    /* ELSE  */
    WHILE = 272,                   /* WHILE  */
    SQRT_FUNC = 273,               /* SQRT_FUNC  */
    POW_FUNC = 274,                /* POW_FUNC  */
    CMP = 275,                     /* CMP  */
    UMINUS = 276                   /* UMINUS  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 140 "kamenrider.y"

    double real;
    int inteiro;
    char string[256];
    struct ast *a;

#line 92 "kamenrider.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_KAMENRIDER_TAB_H_INCLUDED  */
