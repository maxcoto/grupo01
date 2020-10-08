%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <ctype.h>
#include "y.tab.h"

int yylex();
FILE  *yyin, *tsout;

/*-- Estructura para la tabla de simbolos --*/
typedef struct {
	char nombre[30];
	char tipo[10];
	char valor[30];
	int longitud;
} t_ts;

t_ts tablaSimbolos[5000];

char *yytext;

int posicionTabla=0;
int cantComparaciones=0;
char tipoActual[10]={""};
int contvariableActual=0;
char tiposComparados[5000][10];
char listaVariables[50][2]={""};

int validarInt(int entero);
int validarString(char *str);
int validarFloat(float flotante);
int validarID(char *str);
int guardarEnTablaSimbolo(int num, char *yytext, char *valor);
void escribirTablaSimbolo(void);
int buscarEnTablaSimbolo(char *);
void existeEnTablaSimbolo(char *);
void guardarTipo();
int yyerror();

void validarTipos();

%}

%union { char *strVal; }

%token PUNTOCOMA DOSPUNTOS COMA
%token P_A P_C
%token L_A L_C
%token C_A C_C
%token OP_SUMA OP_RESTA OP_MUL OP_DIV
%token OP_ASIGNACION OP_ASIG_ESPECIAL OP_COMPARACION
%token OP_MENOR OP_MAYOR
%token OP_LOGICO OP_NEGACION
%token PUT GET
%token INTEGER FLOAT STRING
%token IF ELSE
%token DIM AS CONTAR CONST
%token WHILE
%token <strVal>TEXTO ENTERO REAL HEXADECIMAL BINARIO
%token <strVal>ID

%%

Inicio:
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

// Declaracion de variables
bloque_declaracion:
  DIM OP_MENOR variables OP_MAYOR AS OP_MENOR tipo_variables OP_MAYOR
;

variables:
	ID 									{printf("Variable: %s\n",yylval.strVal); validarID(yylval.strVal); guardarTipo();} {printf("Regla xx: variables es ID\n");}
	|variables COMA ID 	{printf("Variable: %s\n",yylval.strVal); validarID(yylval.strVal); guardarTipo();} {printf("Regla xx: variables es variable COMA ID\n");}
;

tipo_variables:
	tipo
	| tipo_variables COMA tipo
;

tipo:
	FLOAT 			{strcpy(tipoActual,"Float");}					{printf("Regla xx: tipo es FLOAT\n");}
	|INTEGER 		{strcpy(tipoActual,"Int");}						{printf("Regla xx: tipo es INTEGER\n");}
	|STRING 		{strcpy(tipoActual,"String");}				{printf("Regla xx: tipo es STRING\n");}
;

bloque_sentencias:
	sentencia
	|bloque_sentencias sentencia
;

sentencia:
	ciclo											{printf("Regla xx: sentencia es ciclo\n");}
	|if  											{printf("Regla xx: sentencia es if\n");}
	|asignacion 							{printf("Regla xx: sentencia es asignacion \n");}
	|salida										{printf("Regla xx: sentencia es salida\n");}
	|entrada 									{printf("Regla xx: sentencia es entrada\n");}
;

ciclo:
  WHILE P_A decision P_C L_A bloque_sentencias L_C
;

if:
	IF P_A decision P_C L_A bloque_sentencias L_C                           				{printf("Regla XX: IF.\n");}
	|IF P_A decision P_C sentencia                           												{printf("Regla XX: IF sentencia simple.\n");}
	|IF P_A decision P_C L_A bloque_sentencias L_C ELSE L_A bloque_sentencias L_C   {printf("Regla XX: IF - ELSE.\n");}
	// |IF P_A decision P_C sentencia ELSE sentencia																	  {printf("Regla XX: IF - ELSE simple.\n");}
;

asignacion:
  ID OP_ASIGNACION expresion PUNTOCOMA				  										{printf("Regla XX: Asignacion simple.\n");}
	| ID OP_ASIG_ESPECIAL expresion	PUNTOCOMA	  											{printf("Regla XX: Asignacion especial.\n");}
	| CONST asignacion														  					 				{printf("Regla XX: Asignacion CONST.\n"); validarID(yylval.strVal); guardarTipo();}
;

decision:
  condicion                                                         {printf("Regla XX: Decision simple.\n");}
  |condicion OP_LOGICO condicion                                    {printf("Regla XX: Decision multiple.\n");}
  |OP_NEGACION condicion                                            {printf("Regla XX: Decision negada.\n");}
;

// Condicion puede ser solo una variable ?? --> if(VARIABLE) { .. }
condicion:
	expresion OP_COMPARACION expresion                                {printf("Regla XX: Comparacion.\n");}
  |expresion OP_MAYOR expresion           		                      {printf("Regla XX: Comparacion.\n");}
	|expresion OP_MENOR expresion      			                          {printf("Regla XX: Comparacion.\n");}
;

expresion:
  termino                                                           {printf("Regla XX: Termino.\n");}
  |expresion OP_SUMA termino                                      	{printf("Regla XX: Expresion suma Termino.\n");}
  |expresion OP_RESTA termino                                      	{printf("Regla XX: Expresion resta Termino.\n");}
;

termino:
  factor                                                            {printf("Regla XX: Factor.\n");}
  |termino OP_MUL factor                                            {printf("Regla XX: Termino por Factor.\n");}
  |termino OP_DIV factor                                            {printf("Regla XX: Termino dividido Factor.\n");}
;

factor:
	ID 						{existeEnTablaSimbolo($1); strcpy(tiposComparados[cantComparaciones],tablaSimbolos[buscarEnTablaSimbolo($1)].tipo); cantComparaciones++;}
	|TEXTO 				{validarString(yylval.strVal); strcpy(tiposComparados[cantComparaciones], "String"); cantComparaciones++;}
	|ENTERO    		{validarInt(atoi(yylval.strVal)); strcpy(tiposComparados[cantComparaciones], "Int"); cantComparaciones++;}
	|REAL  				{validarFloat(atof(yylval.strVal)); strcpy(tiposComparados[cantComparaciones], "Float"); cantComparaciones++;}
	|HEXADECIMAL
	|BINARIO
	|P_A expresion P_C
	|CONTAR P_A expresion PUNTOCOMA lista P_C													{printf("Regla XX: Funcion Contar\n");}
;

lista:
	expresion
	|lista COMA expresion
	|C_A lista C_C
;

salida:
  PUT TEXTO PUNTOCOMA
  |PUT ID PUNTOCOMA
;

entrada:
  GET ID PUNTOCOMA
;

%%

int main(int argc,char *argv[]) //falta terminar
{
	if((yyin = fopen(argv[1], "rt")) == NULL){
		fprintf(stderr, "\nNo se puede abrir el archivo: %s\n", argv[1]);
		return 1;
  	}
  	else{
		if( (tsout = fopen("ts.txt", "wt")) == NULL){
			fprintf(stderr,"\nERROR: No se puede abrir o crear el archivo: %s\n", "ts.txt");
			fclose(yyin);
			return 1;
		}

		fprintf(tsout, "NOMBRE                        |   TIPO    |                VALOR                | L |\n");
		fprintf(tsout, "-------------------------------------------------------------------------------------\n");

		yyparse();

		escribirTablaSimbolo();
	}
	fclose(yyin);
	fclose(tsout);
	return 0;
}

int yyerror(void)
{
  fflush(stdout);
  printf("Error de sintaxis\n\n");
  fclose(yyin);
  fclose(tsout);
  exit (1);
}

//Funcion para validar ID
int validarID(char *str){
	int largo=strlen(str);
	if(largo > 20){
		printf("\nERROR: ID \"%s\" demasiado largo (<20)\n", str);
		yyerror();
	}

	// Compruebo que ID no exista ya en la tabla de simbolos
	if(buscarEnTablaSimbolo(str) != -1){
		printf("\nERROR: ID \"%s\" duplicado\n", str);
		yyerror();
	}
	guardarEnTablaSimbolo(1, str, str);
	return 1;
}

//Funcion para validar el rango de enteros
int validarInt(int entero){
	char var[32];
	if(entero < 0 || entero >= 32767){
		printf("\nERROR: Entero fuera de rango (-32768; 32767)\n");
		yyerror();
	}

	sprintf(var, "%d",entero);

	if(buscarEnTablaSimbolo(var) == -1) {
		guardarEnTablaSimbolo(2, var, "");
	}

	return 1;
}

//Funcion para validar string
int validarString(char *str){
	int a=0,i;
	char *aux = str;
  int largo = strlen(aux);
  char cadenaPura[30];

	if(largo > 30){
		printf("\nERROR: Cadena demasiado larga (<30)\n");
		yyerror();
	}

	for(i=1; i<largo-1;i++){
    cadenaPura[a]=str[i];
    a++;
  }

	cadenaPura[a--]='\0';

  if(buscarEnTablaSimbolo(cadenaPura) == -1) guardarEnTablaSimbolo(3, cadenaPura, "");

	return 1;
}


//Funcion para validar float
int validarFloat(float nro){
	char var[32];
	double limiteMin=pow(-1.17549,-38);
	double limiteMax=pow(3.40282,38);
	if(nro < limiteMin || nro > limiteMax){
		printf("\nERROR: Float fuera de rango (-1.17549e-38; 3.40282e38) \n");
		yyerror();
	}

	sprintf(var, "%.2f",nro);

	if(buscarEnTablaSimbolo(var) == -1) guardarEnTablaSimbolo(4, var,"");

	return 1;
}

//Validar que los tipos de datos sean compatibles
void validarTipos(){
	int flgOK=1;
	int flgNumerico=0;
	int x;
	printf("\nComparacion\n");
	for(x=0;x<cantComparaciones;x++){
		printf("TIPO: %s\n",tiposComparados[x]);

		if(x==0){
			if(strcmp(tiposComparados[x],"String")!=0)
				flgNumerico=1;
		}
		else{
			if((flgNumerico == 0 && (strcmp(tiposComparados[x],"Int")==0 || strcmp(tiposComparados[x],"Float")==0)) || (flgNumerico == 1 && strcmp(tiposComparados[x],"String")==0)){
				//Si (no es numerico pero me vienen enteros o float) ó (si es numerico y me viene un string) = ERROR
				flgOK=0;
				break;
			}
		}
	}

	if(flgOK==1){
		printf("Comparacion OK\n");
	}
	else{
		printf("\nERROR: Tipos de dato incompatibles\n");
		yyerror();
	}
}

/* -- FUNCIONES TABLA DE SIMBOLOS -- */

//Funcion para guardar en la Tabla de Simbolos
int guardarEnTablaSimbolo(int num, char *str, char *valor ) {
	switch(num){
		case 1:  // ID
				strcpy(tablaSimbolos[posicionTabla].nombre,str);
				posicionTabla++;
				break;

		case 2: // INT
				strcpy(tablaSimbolos[posicionTabla].nombre,str);
				strcpy(tablaSimbolos[posicionTabla].valor,str);
				strcpy(tablaSimbolos[posicionTabla].tipo,"CteInt");
				posicionTabla++;
				break;

		case 3: // STRING
				strcpy(tablaSimbolos[posicionTabla].nombre,str);
				strcpy(tablaSimbolos[posicionTabla].valor,str);
				tablaSimbolos[posicionTabla].longitud=strlen(str);
				strcpy(tablaSimbolos[posicionTabla].tipo,"CteStr");
				posicionTabla++;
				break;

		case 4: // FLOAT
				strcpy(tablaSimbolos[posicionTabla].nombre,str);
				strcpy(tablaSimbolos[posicionTabla].valor,str);
				strcpy(tablaSimbolos[posicionTabla].tipo,"CteFloat");
				posicionTabla++;
				break;

		default:
				break;
	}
}

//Funcion para actualizar el tipo de una variable en la tabla de simbolos
void guardarTipo(){
    int pos=buscarEnTablaSimbolo(listaVariables[contvariableActual]);
    if(pos!=-1) strcpy(tablaSimbolos[pos].tipo,tipoActual);
}

//Funcion para buscar la posicion de un simbolo en la tabla de simbolos
int buscarEnTablaSimbolo(char *id){
	int i;
	for(i=0; i<5000; i++){
		if(strcmp(id,tablaSimbolos[i].nombre)==0)
			return i;
	}
	return -1;
}

//Funcion para comprobar que un simbolo existe en la tabla de simbolos
void existeEnTablaSimbolo(char *id){
	if(buscarEnTablaSimbolo(id)==-1){
		printf("\nERROR: ID \"%s\" no declarado\n", id);
		yyerror();
	}
}

//Funcion para crear la ts de simbolos en un archivo, en base a la Tabla declarada
void escribirTablaSimbolo(){
	int i;
	for(i=0; i<posicionTabla; i++){
		if(strcmp(tablaSimbolos[i].tipo,"") != 0 &&
			strcmp(tablaSimbolos[i].tipo,"Cte") != 0 &&
			strcmp(tablaSimbolos[i].tipo,"CteFloat") !=0 &&
			strcmp(tablaSimbolos[i].tipo,"CteInt") != 0 &&
			strcmp(tablaSimbolos[i].tipo,"CteStr")!= 0){
			//si es ID
			fprintf(tsout, "%-30s|  %-7s  |                  -               	| - |\n", tablaSimbolos[i].nombre, tablaSimbolos[i].tipo);
		}else{ //Si es cte
			if(tablaSimbolos[i].longitud>0){
				fprintf(tsout, "_%-29s|           |              %-16s	|%03d|\n", tablaSimbolos[i].nombre, tablaSimbolos[i].valor, tablaSimbolos[i].longitud);
			}else{
				fprintf(tsout, "_%-29s|           |              %-16s	| - |\n", tablaSimbolos[i].nombre, tablaSimbolos[i].valor);
			}
		}
	}
}
