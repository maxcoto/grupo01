/*
TODO
1) Que se guarde el tipo de variable en la impresion de la tablaSimbolos --------------ya--------------
2) Que se corrobore la correspondencia del tipo de dato
3) Que se valide que no se repiten las constantes
4) Aplicar tipos de constantes
*/


%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <ctype.h>
#include "y.tab.h"

#define MIN_INT -32768
#define MAX_INT 32767

#define MIN_FLOAT 0.002146
#define MAX_FLOAT 162136619726890008576.000000

int yylex();
FILE  *yyin, *tsout;
char *yytext;


// estructura para la tabla de simbolos ----------
typedef struct {
	char nombre[30];
	char tipo[10];
	char valor[30];
	int longitud;
	int es_const;
} t_ts;
//------------------------------------------------

t_ts tablaSimbolos[5000];
char tipo[10] = { "" };

int posicionTabla = 0;
int cantComparaciones = 0;
int posTipo=0;
int posId=0;

int contVariableActual = 0;
char tiposComparados[5000][10];
char listaVariables[50][2] = { "" };
char varTipo[2][100][50];

void escribirTabla(char *, char *, char *, int, int);
int buscarSimbolo(char *);
void existeSimbolo(char *);

void procesarID(char *, char *, int);
void procesarINT(int);
void procesarSTRING(char *);
void procesarFLOAT(float);

void guardarTipo();
void guardarConst(char *nombre);
void validarReasignacion(char *nombre);
void validarTipos();
void guardarId (char *id,int pos);
void guardarTipo (char *tipo,int pos);
void procesarT(char *tipo);


void escribirArchivo(void);
int yyerror();

%}

%union { char *strVal; }


%token PUNTOCOMA DOSPUNTOS COMA
%token P_A P_C
%token L_A L_C
%token C_A C_C
%token OP_SUMA OP_RESTA OP_MUL OP_DIV
%token OP_ASIGNACION 
%token OP_ASIG_SUMA OP_ASIG_RESTA OP_ASIG_POR OP_ASIG_DIV
%token OP_MENOR OP_MAYOR
%token OP_COMP_MAY_IGUAL OP_COMP_MEN_IGUAL
%token OP_COMP_IGUAL OP_COMP_DIST
%token OP_AND OP_OR OP_NOT
%token PUT GET
%token INTEGER FLOAT STRING BOOLEAN
%token IF ELSE
%token DIM AS CONTAR CONST
%token WHILE
%token <strVal>TEXTO ENTERO REAL
%token <strVal>ID

%%

inicio:
  {printf("\n\nINICIA COMPILACION\n\n");}
	programa
	{printf("\n\nCOMPILACION EXITOSA!\n\n\n");}
;

programa:
	{printf("Bloque de declaraciones\n\n");}
	bloque_declaracion
	{printf("\n\nBloque de sentencias\n");}
	bloque_sentencias
;

// declaracion de variables ---------------------------------------------------------------------------
bloque_declaracion:
	DIM OP_MENOR variables OP_MAYOR AS OP_MENOR tipo_variables OP_MAYOR
;

variables:
	ID                  { procesarID(yylval.strVal, tipo, 0);}  { printf("Regla 01: lista_var es ID\n");}
	| variables COMA ID { procesarID(yylval.strVal, tipo, 0); } { printf("Regla 02: lista_var es lista_var PUNTOCOMA ID\n"); }
;

tipo_variables:
	tipo
	| tipo_variables COMA tipo
;

tipo:
	FLOAT 				{strcpy(tipo,"FLOAT");procesarT(tipo);}			{printf("Regla 03: tipo es FLOAT\n");}
	| INTEGER 			{strcpy(tipo,"INT");procesarT(tipo);}			{printf("Regla 04: tipo es INTEGER\n");}
	| STRING 			{strcpy(tipo,"STRING");procesarT(tipo);}		{printf("Regla 05: tipo es STRING\n");}
;
//------------------------------------------------------------------------------------------------------

// sentencias ------------------------------------------------------------------------------------------
bloque_sentencias:
	sentencia
	| bloque_sentencias sentencia
;

sentencia:
	ciclo						{printf("Regla 06: sentencia es ciclo\n");}
	| if  					 	{printf("Regla 07: sentencia es if\n");}
	| asignacion 		 			{printf("Regla 08: sentencia es asignacion \n");}
	| operasignacion 				{printf("Regla 09: sentencia es operacion y asignacion \n");}
	| salida				 	{printf("Regla 10: sentencia es salida\n");}
	| entrada 			 		{printf("Regla 11: sentencia es entrada\n");}
	| constante      				{printf("Regla 12: sentencia es declaracion de constante\n");}
;

ciclo:
  WHILE P_A decision P_C L_A bloque_sentencias L_C
;

if:
	IF P_A decision P_C L_A bloque_sentencias L_C                           		        {printf("Regla 11: IF.\n");}
	| IF P_A decision P_C sentencia                           				        {printf("Regla 12: IF sentencia simple.\n");}
	| IF P_A decision P_C L_A bloque_sentencias L_C ELSE L_A bloque_sentencias L_C    		{printf("Regla 13: IF - ELSE.\n");}
	| IF P_A decision P_C sentencia ELSE sentencia						        {printf("Regla 14: IF - ELSE simple.\n");} {printf("Regla XX: IF - ELSE simple.\n");}
;

asignacion:
  ID OP_ASIGNACION expresion PUNTOCOMA		 { validarReasignacion($1); }    {printf("Regla XX: Asignacion simple.\n");} 
;

constante:
	CONST nombre_constante OP_ASIGNACION expresion PUNTOCOMA
;

nombre_constante:
	ID   { procesarID(yylval.strVal, "CONST", 1); }  {printf("Regla 01: lista_var es ID CONSTANTE \n");}
;

operasignacion:
	ID operasigna expresion	PUNTOCOMA
;

operasigna:
	OP_ASIG_SUMA      	{printf("Regla XX: Asignacion y suma.\n");}
	| OP_ASIG_RESTA 	{printf("Regla XX: Asignacion y resta.\n");}
	| OP_ASIG_POR   	{printf("Regla XX: Asignacion y multiplicacion.\n");}
	| OP_ASIG_DIV     	{printf("Regla XX: Asignacion y division.\n");}
;

decision:
  condicion                          {printf("Regla 17: Decision simple.\n");}
  | condicion logico condicion
  | OP_NOT condicion                 {printf("Regla 19: Decision negada.\n");}
;

logico:
	OP_AND      {printf("Regla 18: Decision multiple AND.\n");}
	| OP_OR     {printf("Regla 18: Decision multiple OR.\n");}
;

condicion:
	expresion comparacion expresion
;

comparacion:
	OP_COMP_IGUAL                     	{printf("Regla 20: Comparacion IGUAL.\n");}
	| OP_COMP_DIST				{printf("Regla 20: Comparacion DISTINTO.\n");}
	| OP_MAYOR				{printf("Regla 20: Comparacion MAYOR.\n");}
	| OP_MENOR				{printf("Regla 20: Comparacion MENOR.\n");}
	| OP_COMP_MEN_IGUAL			{printf("Regla 20: Comparacion MENOR O IGUAL.\n");}
	| OP_COMP_MAY_IGUAL			{printf("Regla 20: Comparacion MAYOR O IGUAL.\n");}
;

expresion:
  termino                             	{printf("Regla 23: Termino.\n");}
  | expresion OP_SUMA termino           {printf("Regla 24: Expresion suma Termino.\n");}
  | expresion OP_RESTA termino          {printf("Regla 25: Expresion resta Termino.\n");}
;

termino:
  factor                                {printf("Regla 26: Factor.\n");}
  | termino OP_MUL factor               {printf("Regla 27: Termino por Factor.\n");}
  | termino OP_DIV factor               {printf("Regla 28: Termino dividido Factor.\n");}
;

factor:
	ID 						{existeSimbolo($1);}
	| TEXTO 					{procesarSTRING(yylval.strVal);}
	| ENTERO    					{procesarINT(atoi(yylval.strVal));}
	| REAL  					{procesarFLOAT(atof(yylval.strVal));}
	| BOOLEAN
	| P_A expresion P_C
	| CONTAR P_A expresion PUNTOCOMA lista P_C	{printf("Regla 29: Funcion Contar\n");}
;

lista:
	expresion
	| lista COMA expresion
	| C_A lista C_C
;

salida:
  PUT TEXTO PUNTOCOMA
  | PUT ID PUNTOCOMA
;

entrada:
  GET ID PUNTOCOMA
;

%%
// ----------------------------------------------------------------------------------

// funcion principal ----------------------------------------------------------------
int main(int argc,char *argv[]) {
	if((yyin = fopen(argv[1], "rt")) == NULL){
		fprintf(stderr, "\nNo se puede abrir el archivo: %s\n", argv[1]);
		return 1;
  } else {
		if((tsout = fopen("ts.txt", "wt")) == NULL){
			fprintf(stderr,"\nERROR: No se puede abrir o crear el archivo: %s\n", "ts.txt");
			fclose(yyin);
			return 1;
		}

		yyparse();
		escribirArchivo();
	}
	fclose(yyin);
	fclose(tsout);

	return 0;
}
//--------------------------------------------------------------------

// ejecucion de error ------------------------------------------------
int yyerror(void){
  fflush(stdout);
  printf("Error de sintaxis\n\n");
  fclose(yyin);
  fclose(tsout);
  exit(1);
}
//--------------------------------------------------------------------


// valida y almacena IDs ---------------------------------------------
void procesarID(char *texto, char *tipo, int es_const){
	int pos = buscarSimbolo(texto);
	
	if(pos != -1){
		printf("\nERROR: ID \"%s\" duplicado\n", texto);
		yyerror();
	}
	guardarId(texto,posId);
	escribirTabla(texto, tipo, "", 0, es_const);
  	strcpy(tablaSimbolos[pos].tipo, tipo);

	return;
}
//--------------------------------------------------------------------

//----almacena el tipo de dato----------------------------------------
void procesarT(char *tipo){
	strcpy(tablaSimbolos[posTipo].tipo, tipo);
	guardarTipo(tipo,posTipo);
	return;
}
//--------------------------------------------------------------------

//guarda la variable con su tipo de dato-------------------------------
void guardarId (char *id,int pos){ 
    strcpy(varTipo[0][pos],tipo);
    posId++;
}
void guardarTipo (char *tipo,int pos){ 
    strcpy(varTipo[1][pos],tipo);
    posTipo++;
}
//---------------------------------------------------------------------


// valida y almacena enteros -----------------------------------------
void procesarINT(int numero){
	char texto[32];

	if(numero < MIN_INT || numero >= MAX_INT){
		printf("\nERROR: Entero fuera de rango (-32768; 32767)\n");
		yyerror();
	}

	sprintf(texto, "%d", numero);

	if(buscarSimbolo(texto) == -1) {
		escribirTabla(texto, "", texto, 0, 0);
	}

	return;
}
//--------------------------------------------------------------------

// valida y almacena strings -----------------------------------------
void procesarSTRING(char *str){
	int a = 0;
	char *aux = str;
	
  int largo = strlen(aux);
  char cadenaPura[30];
	
	if(largo > 30){
		printf("\nERROR: Cadena demasiado larga (<30)\n");
		yyerror();
	}
	
	int i;
	for(i=1; i<largo-1; i++){
    cadenaPura[a] = str[i];
    a++;
  }
	
	cadenaPura[a--]='\0';
	
  if(buscarSimbolo(cadenaPura) == -1){
		escribirTabla(cadenaPura, "", cadenaPura, largo, 0);
	}
	
	return;
}
//--------------------------------------------------------------------



// valida y almacena floats -----------------------------------------
void procesarFLOAT(float numero){
	char texto[32];

	if(numero < MIN_FLOAT || numero > MAX_FLOAT){
		printf("\nERROR: Float fuera de rango (-1.17549e-38; 3.40282e38) \n");
		yyerror();
	}

	sprintf(texto, "%.2f", numero);

	if(buscarSimbolo(texto) == -1){
		escribirTabla(texto, "", texto, 0, 0);
	}

	return;
}
//--------------------------------------------------------------------


// valida la reasignacion de constantes ------------------------------
void validarReasignacion(char *nombre){
	int pos = buscarSimbolo(nombre);
	if(pos != -1){
		if(tablaSimbolos[pos].es_const){
			printf("\nERROR: Reasignacion de constante\n");
			yyerror();
		}
	}
}
//--------------------------------------------------------------------


// escribir en la estructura de la tabla de simbolos -----------------
void escribirTabla(char *nombre, char *tipo, char *valor, int longitud, int es_const){
	strcpy(tablaSimbolos[posicionTabla].nombre, nombre);
	strcpy(tablaSimbolos[posicionTabla].valor, valor);
	tablaSimbolos[posicionTabla].longitud = longitud;
	strcpy(tablaSimbolos[posicionTabla].tipo, tipo);
	tablaSimbolos[posicionTabla].es_const = es_const;
	posicionTabla++;
}
//--------------------------------------------------------------------

// busca la posicion de un simbolo en la tabla de simbolos -----------
int buscarSimbolo(char *id){
	int i;
	for(i=0; i<5000; i++){
		if(strcmp(id, tablaSimbolos[i].nombre) == 0){
			return i;
		}
	}
	return -1;
}
//--------------------------------------------------------------------

// comprueba que un simbolo existe en la tabla de simbolos -----------
void existeSimbolo(char *id){
	if(buscarSimbolo(id) == -1){
		printf("\nERROR: ID \"%s\" no declarado\n", id);
		yyerror();
	}
}
//--------------------------------------------------------------------

// almacena la tabla de simbolos en un archivo
void escribirArchivo(){
	fprintf(tsout, "NOMBRE                         |   TIPO  | VALOR            | LONGITUD\n");
	fprintf(tsout, "----------------------------------------------------------------------\n");
	
	int i;
	for(i=0; i<posicionTabla; i++){
		char *guion = strcmp(tablaSimbolos[i].tipo, "ID") ? "_" : " ";
		fprintf(tsout, "%s%-30s|\t%-7s|\t%-16s|\t%d\n", guion, tablaSimbolos[i].nombre, tablaSimbolos[i].tipo, tablaSimbolos[i].valor, tablaSimbolos[i].longitud);
	}
}
//--------------------------------------------------------------------
