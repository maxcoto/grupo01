%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include <conio.h>
#include <float.h>
#include <math.h>
#include "y.tab.h"

#define COLOR 0

FILE  *yyin, *tsout;
int yylex();
int yyerror(char *);
%}

%option noyywrap
%option yylineno

DIGITO			[0-9]
LETRA				[a-zA-Z]
GUIONB			[_]

ENTERO			    {DIGITO}+
REAL				{DIGITO}*"."{DIGITO}*
TEXTO				\"(.)*\"
ID					{LETRA}|{LETRA}({LETRA}|{DIGITO}|{GUIONB})*({LETRA}|{DIGITO})
ESPACIO     " "

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

"+="				{ return OP_ASIG_SUMA; }
"-="				{ return OP_ASIG_RESTA; }
"*="				{ return OP_ASIG_POR; }
"/="				{ return OP_ASIG_DIV; }

":="				{ return OP_ASIGNACION; }

"<"					{ return OP_MENOR; }
">"					{ return OP_MAYOR; }
">="				{ return OP_COMP_MAY_IGUAL; }
"<="				{ return OP_COMP_MEN_IGUAL; }
"=="				{ return OP_COMP_IGUAL; }
"!="				{ return OP_COMP_DIST; }
"<>"				{ return OP_COMP_DIST; }

"AND"				{ return OP_AND; }
"and"				{ return OP_AND; }
"OR"				{ return OP_OR; }
"or"				{ return OP_OR; }
"NOT"				{ return OP_NOT; }
"not"				{ return OP_NOT; }

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
"String"		{ return STRING; }

"contar"		{ return CONTAR; }
"CONST"			{ return CONST; }

"true"      { return BOOLEAN; }
"false"     { return BOOLEAN; }


{ENTERO} {
	yylval.strVal = strdup(yytext);
	return ENTERO;
}
{TEXTO} {
	yylval.strVal = strdup(yytext);
	return TEXTO;
}
{REAL} {
	yylval.strVal = strdup(yytext);
	return REAL;
}
{ID} {
	yylval.strVal = strdup(yytext);
	return ID;
}

\*\-(\\.|[^"\\])*\-\* {
	char * comentarios;
	char * segundonivel;

	//Busca el fin de comentario en la cadena, si no lo encuentra devuelve puntero a null.
	comentarios = (strstr(yytext,"-*"));

	segundonivel = strstr(comentarios +2, "-*");
	if(segundonivel != NULL){
		if(strstr(segundonivel+2,"-*") != NULL){
			fprintf(stderr, "ERROR Lexico - No se permite un segundo nivel de comentarios\n");
			exit(1);
		}
	}
}

"\n"
"\t"
{ESPACIO}
.						{
							char msg[300];
							sprintf(msg, "ERROR Lexico");
							yyerror(msg);
						}
%%

// ejecucion de error ------------------------------------------------
int yyerror(char *mensaje){
  fflush(stdout);
	if(COLOR) printf("\033[0;31m");
  if(strcmp(mensaje, "syntax error") == 0)
  	printf("\n\n[LINEA]: %d ---> sintaxis incorrecta.\n\n", yylineno);
  else{
		if(strcmp(mensaje, "ERROR Lexico") == 0)
			printf("\n\nERROR Lexico - [LINEA]: %d ---> Caracter \'%s\' invalido.\n\n",yylineno, yytext);
		else
			printf("\n\nError - [LINEA]: %d ---> %s.\n\n", yylineno, mensaje);
	}
  fclose(yyin);
  fclose(tsout);
  exit(1);
}
//--------------------------------------------------------------------
