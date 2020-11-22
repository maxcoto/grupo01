
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     PUNTOCOMA = 258,
     DOSPUNTOS = 259,
     COMA = 260,
     P_A = 261,
     P_C = 262,
     L_A = 263,
     L_C = 264,
     C_A = 265,
     C_C = 266,
     OP_SUMA = 267,
     OP_RESTA = 268,
     OP_MUL = 269,
     OP_DIV = 270,
     OP_ASIGNACION = 271,
     OP_ASIG_SUMA = 272,
     OP_ASIG_RESTA = 273,
     OP_ASIG_POR = 274,
     OP_ASIG_DIV = 275,
     OP_MENOR = 276,
     OP_MAYOR = 277,
     OP_COMP_MAY_IGUAL = 278,
     OP_COMP_MEN_IGUAL = 279,
     OP_COMP_IGUAL = 280,
     OP_COMP_DIST = 281,
     OP_AND = 282,
     OP_OR = 283,
     OP_NOT = 284,
     PUT = 285,
     GET = 286,
     INTEGER = 287,
     FLOAT = 288,
     STRING = 289,
     BOOLEAN = 290,
     IF = 291,
     ELSE = 292,
     DIM = 293,
     AS = 294,
     CONTAR = 295,
     CONST = 296,
     WHILE = 297,
     TEXTO = 298,
     ENTERO = 299,
     REAL = 300,
     ID = 301
   };
#endif
/* Tokens.  */
#define PUNTOCOMA 258
#define DOSPUNTOS 259
#define COMA 260
#define P_A 261
#define P_C 262
#define L_A 263
#define L_C 264
#define C_A 265
#define C_C 266
#define OP_SUMA 267
#define OP_RESTA 268
#define OP_MUL 269
#define OP_DIV 270
#define OP_ASIGNACION 271
#define OP_ASIG_SUMA 272
#define OP_ASIG_RESTA 273
#define OP_ASIG_POR 274
#define OP_ASIG_DIV 275
#define OP_MENOR 276
#define OP_MAYOR 277
#define OP_COMP_MAY_IGUAL 278
#define OP_COMP_MEN_IGUAL 279
#define OP_COMP_IGUAL 280
#define OP_COMP_DIST 281
#define OP_AND 282
#define OP_OR 283
#define OP_NOT 284
#define PUT 285
#define GET 286
#define INTEGER 287
#define FLOAT 288
#define STRING 289
#define BOOLEAN 290
#define IF 291
#define ELSE 292
#define DIM 293
#define AS 294
#define CONTAR 295
#define CONST 296
#define WHILE 297
#define TEXTO 298
#define ENTERO 299
#define REAL 300
#define ID 301




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 174 "sintactico.y"
 char *strVal; 


/* Line 1676 of yacc.c  */
#line 148 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
} YYLTYPE;
# define yyltype YYLTYPE /* obsolescent; will be withdrawn */
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif

extern YYLTYPE yylloc;

