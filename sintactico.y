%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <ctype.h>
#include "y.tab.h"

#define VERBOSE 0
#define COLOR 0

#define MIN_INT -32768
#define MAX_INT 32767

#define MIN_FLOAT 0.002146
#define MAX_FLOAT 162136619726890008576.000000

#define TIPO_NULL 0
#define TIPO_NUMERO 1
#define TIPO_STRING 2

#define TREESIZE 20
#define TREEWIDTH 255

int yylex();
FILE  *yyin, *tsout;
char *yytext;

// estructura de nodos para arbol sintactico -----

struct node {
  char *value;
  struct node *left;
  struct node *right;
};

struct node *root = NULL;
struct node *Ap = NULL;
struct node *Cp = NULL;
struct node *Ep = NULL;
struct node *Tp = NULL;
struct node *Fp = NULL;

struct node *AUXp = NULL;

struct node *IFp = NULL;
struct node *COp = NULL;
struct node *ACp = NULL;
struct node *OPp = NULL;

struct node *BSp = NULL;
struct node *Sp = NULL;
struct node *Wp = NULL;

struct node *BSi = NULL;
struct node *BSd = NULL;



struct node *crearHoja(char *);
struct node *crearNodo(char *, struct node *, struct node *);

void print_t(struct node *);
int _print_t(struct node *, int, int, int, char s[TREESIZE][TREEWIDTH]);

void print_tx(struct node *);

char* _string;

//------------------------------------------------

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
int validaTipo = 0;
int posicionTabla = 0;
int posicionTipo = 0;
int asignacionConst = 0;
int cantVariables = 0;
int cantTipos = 0;

void validarTipo(int);

void escribirTabla(char *, char *, int, int);
int buscarSimbolo(char *);

void procesarSimbolo(char *, int);
void procesarID(char *);
void procesarINT(int);
void procesarSTRING(char *);
void procesarFLOAT(float);

void agregarTipo(char *);
void validarAsignacion(char *);
void validarVariables();

void escribirArchivo(void);
int yyerror();
void debug(char *);
void error(char *, char *);
void exito(char *);

%}

%union { char *strVal; }

%locations

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
  {exito("Iniciando compilacion ...");}
	programa
	{exito("\nCompilacion exitosa !!!\n");}
;

programa:
	{debug("Bloque de declaraciones");}
	bloque_declaracion
	{debug("Bloque de sentencias");}
	bloque_sentencias             { root = BSp; }
;

// declaracion de variables ---------------------------------------------------------------------------
bloque_declaracion:
	declaracion
	| bloque_declaracion declaracion
;

declaracion:
	DIM OP_MENOR variables OP_MAYOR AS OP_MENOR tipo_variables OP_MAYOR {validarVariables();}
;

variables:
	ID                  { procesarSimbolo(yylval.strVal, 0);} { debug("Regla 01: variables es ID");}
	| variables COMA ID { procesarSimbolo(yylval.strVal, 0);} { debug("Regla 02: variables es variables puntocoma id");}
;

tipo_variables:
	tipo
	| tipo_variables COMA tipo
;

tipo:
	FLOAT 				{agregarTipo("FLOAT");}			{debug("Regla 03: tipo es float");}
	| INTEGER 		{agregarTipo("INT");}				{debug("Regla 04: tipo es int");}
	| STRING 			{agregarTipo("STRING");}		{debug("Regla 05: tipo es string");}
	| BOOLEAN 		{agregarTipo("BOOLEAN");}		{debug("Regla 06: tipo es boolean");}
;
//------------------------------------------------------------------------------------------------------

// sentencias ------------------------------------------------------------------------------------------
bloque_sentencias:
	sentencia { BSp = Sp; }
	| bloque_sentencias sentencia { BSp = crearNodo("BS", BSp, Sp); }
;

sentencia:
	ciclo						 			{debug("Regla 07: sentencia es ciclo");}                      { Sp = Wp; }
	| if  					 			{debug("Regla 08: sentencia es if");}                         { Sp = IFp; }
	| asignacion 		 			{debug("Regla 09: sentencia es asignacion ");}                { Sp = Ap; }
	| operasignacion 			{debug("Regla 10: sentencia es operacion y asignacion ");}    { Sp = OPp; }
	| salida				 			{debug("Regla 11: sentencia es salida");}
	| entrada 			 			{debug("Regla 12: sentencia es entrada");}
	| constante      		 	{debug("Regla 13: sentencia es declaracion de constante");}
	| tipo 								{error("Uso de palabra reservada", ""); }
;

ciclo:
  WHILE P_A decision P_C L_A bloque_sentencias L_C
;

if:
	IF P_A decision P_C L_A bloque_sentencias L_C                                       {debug("Regla 14: if");}             { IFp = crearNodo("if", COp, BSp); }
	| IF P_A decision P_C sentencia                                                     {debug("Regla 15: if simple");}      { IFp = crearNodo("if", COp, BSp); }
	| IF P_A decision P_C L_A bloque_sentencias L_C { BSd = BSp; } ELSE L_A bloque_sentencias L_C { BSi = BSp; } 	{debug("Regla 16: if/else");}    { IFp = crearNodo("if", COp, crearNodo("cuerpo", BSd, BSi)); }
;

asignacion:
	ID OP_ASIGNACION expresion PUNTOCOMA		 { validarAsignacion($1); }   {debug("Regla 18: Asignacion simple");}  			     { Ap = crearNodo(":=", crearHoja($1), Ep); }
;

constante:
	CONST nombre_constante OP_ASIGNACION expresion PUNTOCOMA           		{debug("Regla 19: Declaracion de constante");}
;

nombre_constante:
	ID   { procesarSimbolo(yylval.strVal, 1); asignacionConst=1; }  			{debug("Regla 20: lista_var es id constante");}    { Cp = crearNodo(":=", crearHoja($1), Ep); }
;

operasignacion:
	ID { AUXp = Fp; } operasigna expresion	PUNTOCOMA   {OPp = crearNodo (_string, AUXp, Ep);}
;

operasigna:
	OP_ASIG_SUMA      {debug("Regla 21: Asignacion y suma");}                    {_string = "+=";}
	| OP_ASIG_RESTA 	{debug("Regla 22: Asignacion y resta");}                   {_string = "-=";}
	| OP_ASIG_POR   	{debug("Regla 23: Asignacion y multiplicacion");}          {_string = "*=";}
	| OP_ASIG_DIV     {debug("Regla 24: Asignacion y division");}                {_string = "/=";}
;

decision:
  condicion                          	{debug("Regla 25: Decision simple");}
  | condicion logico condicion
  | OP_NOT condicion                 	{debug("Regla 26: Decision negada");}
;

logico:
	OP_AND      												{debug("Regla 27: Decision multiple and");}
	| OP_OR     												{debug("Regla 28: Decision multiple or");}
;

condicion:
  expresion { AUXp = Ep; } comparacion expresion         {COp = crearNodo (_string, AUXp, Ep);}
;

comparacion:
	OP_COMP_IGUAL                     		{debug("Regla 29: Comparacion igual");}          {_string = "==";}
	| OP_COMP_DIST												{debug("Regla 30: Comparacion distinto");}       {_string = "<>";}
	| OP_MAYOR														{debug("Regla 31: Comparacion mayor");}          {_string = ">";}
	| OP_MENOR														{debug("Regla 32: Comparacion menor");}          {_string = "<";}
	| OP_COMP_MEN_IGUAL										{debug("Regla 33: Comparacion menor o igual");}  {_string = "<=";}
	| OP_COMP_MAY_IGUAL										{debug("Regla 34: comparacion mayor o igual");}  {_string = ">=";}
;

expresion:
  termino                             	{debug("Regla 35: termino");}										 	{Ep = Tp;}
  | expresion OP_SUMA termino           {debug("Regla 36: expresion suma termino");}			{Ep = crearNodo("+", Ep, Tp);}
  | expresion OP_RESTA termino          {debug("Regla 37: expresion resta termino");}			{Ep = crearNodo("-", Ep, Tp);}
;

termino:
  factor                                {debug("Regla 38: factor");}											{Tp = Fp;}
  | termino OP_MUL factor               {debug("Regla 39: termino por Factor");}					{Tp = crearNodo("*", Tp, Fp);}
  | termino OP_DIV factor               {debug("Regla 40: termino dividido factor");}			{Tp = crearNodo("/", Tp, Fp);}
;

factor:
	ID 							{procesarID($1);}											{Fp = crearHoja($1);}
	| TEXTO 				{procesarSTRING(yylval.strVal);}			{Fp = crearHoja(yylval.strVal);}
	| ENTERO    		{procesarINT(atoi(yylval.strVal));}		{Fp = crearHoja(yylval.strVal);}
	| REAL  				{procesarFLOAT(atof(yylval.strVal));} {Fp = crearHoja(yylval.strVal);}
	| BOOLEAN
	| P_A expresion P_C                                   {Fp = Ep;}
	| CONTAR P_A expresion PUNTOCOMA lista P_C	          {debug("Regla 41: funcion contar");}
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


struct node *crearHoja(char *nombre){
	return crearNodo(nombre, NULL, NULL);
}

struct node *crearNodo(char *nombre, struct node *left, struct node *right){
	struct node *hoja;
	hoja = (struct node *) malloc(sizeof(struct node));
	(hoja)->value = nombre;
	(hoja)->left = left;
	(hoja)->right = right;
	return hoja;
}


int _print_t(struct node *tree, int is_left, int offset, int depth, char s[TREESIZE][TREEWIDTH]){
    char b[TREESIZE];
    int width = 5;

    if (!tree) return 0;

		printf("(%s)", tree->value);
    sprintf(b, "(%s)", tree->value);

    int left  = _print_t(tree->left,  1, offset,                depth + 1, s);
    int right = _print_t(tree->right, 0, offset + left + width, depth + 1, s);

    for (int i = 0; i < width; i++)
        s[2 * depth][offset + left + i] = b[i];

    if (depth && is_left) {

        for (int i = 0; i < width + right; i++)
            s[2 * depth - 1][offset + left + width/2 + i] = '-';

        s[2 * depth - 1][offset + left + width/2] = '+';
        s[2 * depth - 1][offset + left + width + right + width/2] = '+';

    } else if (depth && !is_left) {

        for (int i = 0; i < left + width; i++)
            s[2 * depth - 1][offset - width/2 + i] = '-';

        s[2 * depth - 1][offset + left + width/2] = '+';
        s[2 * depth - 1][offset - width/2 - 1] = '+';
    }

    return left + width + right;
}

void print_t(struct node *tree){
    char s[TREESIZE][TREEWIDTH];
    for (int i = 0; i < TREESIZE; i++)
        sprintf(s[i], "%80s", " ");

    _print_t(tree, 0, 0, 0, s);

    for (int i = 0; i < TREESIZE; i++)
        printf("%s\n", s[i]);
}


void print_tx(struct node *tree){
		if (!tree || !tree->left) return;
    printf("(%s): %s | %s \n", tree->value, tree->left->value, tree->right->value);
    print_tx(tree->left);
    print_tx(tree->right);
}


// funcion principal ----------------------------------------------------------------
int main(int argc,char *argv[]) {
	if((yyin = fopen(argv[1], "rt")) == NULL){
		fprintf(stderr, "\nNo se puede abrir el archivo: %s\n", argv[1]);
		return 1;
  } else {
		if((tsout = fopen("ts.txt", "wt")) == NULL){
			fprintf(stderr, "\nNo se puede abrir o crear el archivo: ts.txt\n");
			fclose(yyin);
			return 1;
		}

		yyparse();
		escribirArchivo();
	}


	print_tx(IFp);

	fclose(yyin);
	fclose(tsout);

	return 0;
}
//--------------------------------------------------------------------

// Validar tipo en las asignaciones ---------------------------------------------------------
void validarTipo(int tipoDato){
	if(validaTipo == TIPO_NULL){
		validaTipo = tipoDato;
	} else {
		if(validaTipo != tipoDato) {
			error("Tipos de datos incorrectos", "");
		}
	}
}

// escribir en la estructura de la tabla de simbolos -----------------
void escribirTabla(char *nombre, char *valor, int longitud, int es_const){
	strcpy(tablaSimbolos[posicionTabla].nombre, nombre);
	strcpy(tablaSimbolos[posicionTabla].valor, valor);
	tablaSimbolos[posicionTabla].longitud = longitud;
	tablaSimbolos[posicionTabla].es_const = es_const;
	posicionTabla++;

	if(es_const){ posicionTipo = posicionTabla - 1; }
}

//--------------------------------------------------------------------

// busca la posicion de un simbolo en la tabla de simbolos -----------
int buscarSimbolo(char *id){
	int i;
	for(i = 0; i<5000; i++){
		if(strcmp(id, tablaSimbolos[i].nombre) == 0){
			return i;
		}
	}
	return -1;
}
//--------------------------------------------------------------------

// valida y almacena IDs ---------------------------------------------
void procesarSimbolo(char *texto, int es_const){
	int pos = buscarSimbolo(texto);

	if(pos != -1){
		error("ID duplicado:", texto);
	}

	escribirTabla(texto, "", 0, es_const);

	cantVariables++;

	return;
}
//--------------------------------------------------------------------
void procesarID(char *simbolo){
	int pos = buscarSimbolo(simbolo);

	if(pos == -1){
		error("ID no declarado:", simbolo);
	}

	if(strcmp(tablaSimbolos[pos].tipo, "INT") == 0){
		validarTipo(TIPO_NUMERO);
	}

	if(strcmp(tablaSimbolos[pos].tipo, "STRING") == 0){
		validarTipo(TIPO_STRING);
	}

	if(strcmp(tablaSimbolos[pos].tipo, "FLOAT") == 0){
		validarTipo(TIPO_NUMERO);
	}
}
//--------------------------------------------------------------------
// valida y almacena enteros -----------------------------------------
void procesarINT(int numero){
	char texto[32];
	sprintf(texto, "%d", numero);

	int pos = buscarSimbolo(texto);

	if(numero < MIN_INT || numero >= MAX_INT){
		error("Entero fuera de rango:", "(-32768; 32767)");
	}

	if(pos == -1) {
		escribirTabla(texto, texto, 0, 0);
	}

	if(asignacionConst == 1){
		agregarTipo("INT");
		asignacionConst = 0;
	} else {
		validarTipo(TIPO_NUMERO);
	}

	return;
}
//--------------------------------------------------------------------
// valida y almacena strings -----------------------------------------
void procesarSTRING(char *str){
	int a = 0;
	char *aux = str;
	int i;

  int largo = strlen(aux);
  char cadenaPura[30];

	if(largo > 30){
		error("Cadena demasiado larga:", "(<30)");
	}

	for(i = 1; i<largo-1; i++){
    cadenaPura[a] = str[i];
    a++;
  }

	cadenaPura[a--]='\0';

  if(buscarSimbolo(cadenaPura) == -1){
		escribirTabla(cadenaPura, cadenaPura, largo, 0);
	}

	if(asignacionConst == 1){
		agregarTipo("STRING");
		asignacionConst = 0;
	} else {
		validarTipo(TIPO_STRING);
	}

	return;
}
//--------------------------------------------------------------------
// valida y almacena floats -----------------------------------------
void procesarFLOAT(float numero){
	char texto[32];

	if(numero < MIN_FLOAT || numero > MAX_FLOAT){
		error("Float fuera de rango", "(-1.17549e-38; 3.40282e38)");
	}

	sprintf(texto, "%f", numero);

	if(buscarSimbolo(texto) == -1){
		escribirTabla(texto, texto, 0, 0);
	}

	if(asignacionConst == 1){
		agregarTipo("FLOAT");
		asignacionConst = 0;
	} else {
		validarTipo(TIPO_NUMERO);
	}

	return;
}
//--------------------------------------------------------------------
void agregarTipo(char *tipo){
	strcpy(tablaSimbolos[posicionTipo].tipo, tipo);
	posicionTipo++;
	cantTipos++;
}
// valida la reasignacion de constantes ------------------------------
void validarAsignacion(char *nombre){
	int pos = buscarSimbolo(nombre);
	if(pos != -1){
		if(tablaSimbolos[pos].es_const){
			error("Reasignacion de constante", "");
		}
	} else {
		error("Variable no declarada", "");
	}

	if(
		strcmp(tablaSimbolos[pos].tipo, "STRING") == 0 &&
		validaTipo != TIPO_STRING
	){
		error("Asignacion de tipo de dato erronea", "");
	}

	if(
		(strcmp(tablaSimbolos[pos].tipo, "INT") == 0 ||
		 strcmp(tablaSimbolos[pos].tipo, "FLOAT") == 0) &&
		validaTipo != TIPO_NUMERO
	){
		error("Asignacion de tipo de dato erronea", "");
	}

	validaTipo = TIPO_NULL;
}
//--------------------------------------------------------------------
void validarVariables(){
	if(cantTipos != cantVariables){
		error("Declaracion de variables erroneas.", "No coincide la cantidad de elementos");
	} else {
		cantTipos = 0;
		cantVariables = 0;
	}
}
//--------------------------------------------------------------------

// almacena la tabla de simbolos en un archivo
void escribirArchivo(){
	fprintf(tsout, "NOMBRE                         |   TIPO         | VALOR           | LONGITUD \n");
	fprintf(tsout, "----------------------------------------------------------------------------\n");
	int i;

	for(i = 0; i<posicionTabla; i++){
		char *guion = strcmp(tablaSimbolos[i].tipo, "") ? " " : "_";
		char tipo_str[14] = {""};
		strcpy(tipo_str, tablaSimbolos[i].tipo);
		if(tablaSimbolos[i].es_const) { strcat(tipo_str, " CONST"); }

		int longi = tablaSimbolos[i].longitud;
	  char longitud_texto[10] = {""};
		if(longi > 0) { sprintf(longitud_texto, "%d", longi - 2); }

		fprintf(tsout, "%s%-30s|\t%-14s|\t%-16s|\t%-8s\t\n", guion, tablaSimbolos[i].nombre, tipo_str, tablaSimbolos[i].valor, longitud_texto);
	}
}
//--------------------------------------------------------------------

// function para imprimir en modo explicito las reglas ---------------
void debug(char* texto){
	if(VERBOSE){
		printf("\n%s", texto);
		fflush(stdout);
	}
}
// ----------------------------------------------------------------------

// function para imprimir errores en color rojo -----------------------
void error(char *texto, char *valor){
	if(COLOR) printf("\033[0;31m");
	printf("\n\n[ERROR]: %s %s", texto, valor);
	yyerror();
}
// --------------------------------------------------------------------

// function para imprimir mensajes en verde  --------------------------
void exito(char *texto){
	if(COLOR) printf("\033[0;32m");
	printf("\n%s\n", texto);
	if(COLOR) printf("\033[0;0m");
}
// --------------------------------------------------------------------
