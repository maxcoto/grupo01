%{
#include <stdio.h>
#include <stdlib.h>
#include <curses.h>

#include <string.h>
#include <conio.h>
#include <float.h>
#include "y.tab.h"

char *ptr;
long ret;
FILE  *yyin, *tsout;
%}

%option noyywrap
%option yylineno


DIGITO            [0-9]
LETRA             [a-zA-Z]
CONST_INT            {DIGITO}+
GUIONB            [_]
REAL              {DIGITO}+"."{DIGITO}+
ID                {LETRA}({LETRA}|{DIGITO}|{GUIONB})*({LETRA}|{DIGITO})
TEXTO             \"(.)*\"
BINARIO           "0b"[0-1]+
HEXADECIMAL       "0x"([a-f]|[A-F]|[0-9])+

CONST_STRING    [\"]({LETRA}|{DIGITO}|{CARACTER}|" ")*[\"]
CONST_FLOAT     {DIGITO}*["."]{DIGITO}*

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

{CONST_INT}          { printf("\nEntero: %s\n", yytext); return CONST_INT; }
{TEXTO}           { printf("\nString: %s\n", yytext); return TEXTO; }
{REAL}            { printf("\nReal: %s\n", yytext); return REAL; }
{BINARIO}         { printf("\nBinario: %s\n", yytext); return BINARIO; }
{HEXADECIMAL}     { printf("\nHexa: %s\n", yytext); return HEXADECIMAL; }

{ID}              { printf("\nId: %s\n", yytext); return ID; }

/*
  meter codiogo para los comentarios --> *- comentario -*
*/

{CONST_INT}{
	int nro = atoi(yytext);
	if(nro < 0 || nro > 65535) {
	    char msg[100];
		fprintf(stderr, "ERROR Lexico - Entero fuera de rango. Debe estar entre [0; 65535]\n");
		exit(1);
	}
	return CONST_INT;
}

{CONST_FLOAT}{
	double nro = atof(yytext);
	if(nro < 0 || nro > FLT_MAX) {
	    fprintf(stderr, "ERROR Lexico - Float fuera de rango. Debe estar entre [0; 3.40282e38]\n");
	    exit(1);
	}
    return CONST_FLOAT;
}

{CONST_STRING} {	
	int longitud = strlen(yytext);
	if(longitud > 32){ 	//en lugar de 30 verifica con 32 porque el string viene entre comillas
	    fprintf(stderr,  "ERROR Lexico - Cadena demasiado larga. Maximo permitido 30 caracteres\n");
		exit(1);
	}
    return CONST_STRING;	
}

/*Falta definir bien los comentarios
//Deberán estar delimitados por “*- “ y “-*” y podrán estar anidados en un solo nivel.

¡Regex!   { 
	char * comentarios;
	char * segundonivel;
	comentarios = (strstr(yytext,"*-"));
	//printf("Comentario: %s\n", comentarios);
	segundonivel = strstr(comentarios +2, "*-");
	//printf("Comentario segundonivel: %s\n", segundonivel);
	if(segundonivel != NULL){
		if(strstr(segundonivel+2,"*-") != NULL){
    		fprintf(stderr, "ERROR Lexico - No se permite un segundo nivel de comentarios\n");
			exit (1);
		}
	}
}
*/

"\n"
"\t"
%%
