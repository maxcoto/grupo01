%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include <conio.h>
#include <float.h>
#include <math.h>
#include "y.tab.h"

FILE  *yyin, *tsout;
%}

%option noyywrap
%option yylineno

DIGITO			[0-9]
LETRA				[a-zA-Z]
GUIONB			[_]

ENTERO			{DIGITO}+
REAL				{DIGITO}*"."{DIGITO}*
TEXTO				\"(.)*\"
ID					{LETRA}({LETRA}|{DIGITO}|{GUIONB})*({LETRA}|{DIGITO})

%%
";"					{ return PUNTOCOMA; }
":"					{ return DOSPUNTOS; }
","					{ return COMA; }
"("					{ return P_A; }
")"					{ return P_C; }
"{"					{ return L_A; }
"}"					{ return L_C; }
"["					{ return C_A; }
"]"					{ return C_C; }

"+"					{ return OP_SUMA; }
"-"					{ return OP_RESTA; }
"*"					{ return OP_MUL; }
"/"					{ return OP_DIV; }

"+="				{ return OP_ASIG_ESPECIAL; }
"-="				{ return OP_ASIG_ESPECIAL; }
"*="				{ return OP_ASIG_ESPECIAL; }
"/="				{ return OP_ASIG_ESPECIAL; }

":="				{ return OP_ASIGNACION; }

"<"					{ return OP_MENOR; }
">"					{ return OP_MAYOR; }
">="				{ return OP_COMPARACION; }
"<="				{ return OP_COMPARACION; }
"=="				{ return OP_COMPARACION; }
"!="				{ return OP_COMPARACION; }
"<>"				{ return OP_COMPARACION; }

"AND"				{ return OP_LOGICO; }
"and"				{ return OP_LOGICO; }
"OR"				{ return OP_LOGICO; }
"or"				{ return OP_LOGICO; }
"NOT"				{ return OP_NEGACION; }
"not"				{ return OP_NEGACION; }

"DIM"				{ return DIM; }
"AS"				{ return AS; }

"GET"				{ return GET; }
"PUT"				{ return PUT; }

"IF"				{ return IF; }
"if"				{ return IF; }
"ELSE"			{ return ELSE; }
"else"			{ return ELSE; }
"WHILE"			{ return WHILE; }
"while"			{ return WHILE; }

"Integer"		{ return INTEGER; }
"Float"			{ return FLOAT; }
"STRING"		{ return STRING; }

"contar"		{ return CONTAR; }
"COSNT"			{ return CONST; }


{ENTERO} {
	printf("\nEntero: %s\n", yytext);
	yylval.strVal = strdup(yytext);
	return ENTERO;
}
{TEXTO} {
	printf("\nString: %s\n", yytext);
	yylval.strVal = strdup(yytext);
	return TEXTO;
}
{REAL} {
	printf("\nReal: %s\n", yytext);
	yylval.strVal = strdup(yytext);
	return REAL;
}
{ID} {
	printf("\nIdentificador: %s\n", yytext);
	yylval.strVal = strdup(yytext);
	return ID;
}

\*\-(\\.|[^"\\])*\-\* { 
	char * comentarios;
	char * segundonivel;
	comentarios = (strstr(yytext,"-*")); //Busca el fin de comentario en la cadena, si no lo encuentra devuelve puntero a null.
	printf("Comentario: %s\n", yytext);
	segundonivel = strstr(comentarios +2, "-*");
	if(segundonivel != NULL){
		if(strstr(segundonivel+2,"-*") != NULL){
			fprintf(stderr, "ERROR Lexico - No se permite un segundo nivel de comentarios\n");
			exit (1);
		}
	}
}

"\n"
"\t"
%%
