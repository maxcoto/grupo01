%{
#include <stdio.h>
#include <stdlib.h>
#include <curses.h>

char *ptr;
long ret;
FILE  *yyin, *tsout;
%}

%option noyywrap
%option yylineno


DIGITO            [0-9]
LETRA             [a-zA-Z]
ENTERO            {DIGITO}+
GUIONB            [_]
REAL              {DIGITO}+"."{DIGITO}+
ID                {LETRA}({LETRA}|{DIGITO}|{GUIONB})*({LETRA}|{DIGITO})
TEXTO             \"(.)*\"
BINARIO           "0b"[0-1]+
HEXADECIMAL       "0x"([a-f]|[A-F]|[0-9])+

/* Falta lista de variables */

%%
";"			          { return PUNTOCOMA; }
":"			          { return DOSPUNTOS; }
","			          { return COMA; }
"("			          { return P_A; }
")"	    		      { return P_C; }
"{"			          { return L_A; }
"}"			          { return L_C; }

"+"   		       	{ return OP_SUMA; }
"-"		          	{ return OP_RESTA; }
"*"		           	{ return OP_MUL; }
"/"			          { return OP_DIV; }

"+="     		      { return OP_ASIG_ESPECIAL; }
"-=" 		          { return OP_ASIG_ESPECIAL; }
"*=" 		          { return OP_ASIG_ESPECIAL; }
"/="     		      { return OP_ASIG_ESPECIAL; }

":="    		      { return OP_ASIGNACION; }

"<"	    		      { return OP_COMPARACION; }
">"			          { return OP_COMPARACION; }
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

"INT"	    	      { return INT; }
"FLOAT"	    	    { return FLOAT; }
"STRING"    	    { return STRING; }

"IF"		          { return IF; }
"ELSE"		        { return ELSE; }
"ENDIF"           { return ENDIF; }
"WHILE"	    	    { return WHILE; }

"Integer"         { return INTEGER; }
"Float"           { return FLOAT; }
"CONST"           { return CONST; }

{ENTERO}          { printf("\nEntero: %s\n", yytext); return ENTERO; }
{TEXTO}           { printf("\nString: %s\n", yytext); return TEXTO; }
{REAL}            { printf("\nReal: %s\n", yytext); return REAL; }
{BINARIO}         { printf("\nBinario: %s\n", yytext); return BINARIO; }
{HEXADECIMAL}     { printf("\nHexa: %s\n", yytext); return HEXADECIMAL; }

{ID}              { printf("\nId: %s\n", yytext); return ID; }

/*
  meter codiogo para los comentarios --> *- comentario -*
*/

"\n"
"\t"
%%
