%{
#include <stdio.h>
#include <stdlib.h>
#include <curses.h>
#include "y.tab.h"

FILE  *yyin, *tsout;
%}

%option noyywrap
%option yylineno

DIGITO            [0-9]
LETRA             [a-zA-Z]
GUIONB            [_]
ENTERO         		{DIGITO}+
REAL              {DIGITO}*"."{DIGITO}*
TEXTO             \"(.)*\"
BINARIO           "0b"[0-1]+
HEXADECIMAL       "0x"([a-f]|[A-F]|[0-9])+
ID                {LETRA}({LETRA}|{DIGITO}|{GUIONB})*({LETRA}|{DIGITO})

%%
";"			          { return PUNTOCOMA; }
":"			          { return DOSPUNTOS; }
","			          { return COMA; }
"("			          { return P_A; }
")"	    		      { return P_C; }
"{"			          { return L_A; }
"}"			          { return L_C; }
"["			          { return C_A; }
"]"			          { return C_C; }

"+"   		       	{ return OP_SUMA; }
"-"		          	{ return OP_RESTA; }
"*"		           	{ return OP_MUL; }
"/"			          { return OP_DIV; }

"+="     		      { return OP_ASIG_ESPECIAL; }
"-=" 		          { return OP_ASIG_ESPECIAL; }
"*=" 		          { return OP_ASIG_ESPECIAL; }
"/="     		      { return OP_ASIG_ESPECIAL; }

":="    		      { return OP_ASIGNACION; }

"<"	    		      { return OP_MENOR; }
">"			          { return OP_MAYOR; }
">="		          { return OP_COMPARACION; }
"<="    		      { return OP_COMPARACION; }
"=="		          { return OP_COMPARACION; }
"!="		          { return OP_COMPARACION; }

"AND"   		      { return OP_LOGICO; }
"OR"		          { return OP_LOGICO; }
"NOT"		          { return OP_NEGACION; }

"DIM"		          { return DIM; }
"AS"		          { return AS; }

"GET"	            { return GET; }
"PUT"             { return PUT; }

"IF"		          { return IF; }
"ELSE"		        { return ELSE; }
"WHILE"	    	    { return WHILE; }

"Integer"         { return INTEGER; }
"Float"           { return FLOAT; }
"STRING"    	    { return STRING; }
"CONST"           { return CONST; }

{ENTERO}       		{ printf("\nEntero: %s\n", yytext); return ENTERO; }
{TEXTO}           { printf("\nString: %s\n", yytext); return TEXTO; }
{REAL}            { printf("\nReal: %s\n", yytext); return REAL; }
{BINARIO}         { printf("\nBinario: %s\n", yytext); return BINARIO; }
{HEXADECIMAL}     { printf("\nHexa: %s\n", yytext); return HEXADECIMAL; }
{ID}              { printf("\nIdentificador: %s\n", yytext); return ID; }

"\n"
"\t"
%%
