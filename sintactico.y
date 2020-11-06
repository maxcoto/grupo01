%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <ctype.h>
#include "y.tab.h"

#define VERBOSE 1
#define COLOR 0

#define MIN_INT -32768
#define MAX_INT 32767

#define MIN_FLOAT 0.002146
#define MAX_FLOAT 162136619726890008576.000000

#define TIPO_NULL 0
#define TIPO_NUMERO 1
#define TIPO_STRING 2

#define COUNT 10

int yylex();
FILE  *yyin, *tsout;
FILE * fp = NULL; /*graph*/

char *yytext;

// estructura de nodos para arbol sintactico -----

struct node {
  char *value;
  struct node *left;
  struct node *right;
};

struct node *root = NULL;
struct node *AsignacionP = NULL;
struct node *ConstanteP = NULL;
struct node *AuxConstanteP = NULL;
struct node *ExpresionP = NULL;
struct node *AuxExpresionP = NULL;
struct node *AuxExpresion2P = NULL;
struct node *AuxExpresion3P = NULL;
struct node *TerminoP = NULL;
struct node *AuxTerminoP = NULL;
struct node *FactorP = NULL;

struct node *IFp = NULL;
struct node *DecisionP = NULL;
struct node *CondicionP = NULL;
struct node *AuxCondicionP = NULL;
struct node *OperasignaP = NULL;
struct node *AuxOperasignaP = NULL;

//struct node *Lp = NULL;
struct node *BloqueSentenciaP = NULL;
//Auxiliares para bloque de sentencia - Izq y Der
struct node *AuxBloqueSentenciaP = NULL;
struct node *BloqueInternoP = NULL;
struct node *AuxBloqueInternoP = NULL;
struct node *BSi = NULL;
struct node *BSd = NULL;
struct node *SentenciaP = NULL;
struct node *CicloP = NULL;

struct node *EntradaP = NULL;
struct node *SalidaP = NULL;

struct node *ListaP = NULL;
struct node *AuxListaP = NULL;
struct node *ContarP = NULL;

struct node *crearHoja(char *);
struct node *crearNodo(char *, struct node *, struct node *);

void _print_h(struct node *, int);
void print_h(struct node *);

char* _string;
char* _string1;

//------------------------------------------------

struct Stack {
    int top;
    unsigned capacity;
    struct node** array;
};

struct Stack *stackDecision;
struct Stack *stackParentesis;

struct Stack* createStack(unsigned capacity);
int isFull(struct Stack* stack);
int isEmpty(struct Stack* stack);
void push(struct Stack* stack, struct node *item);
struct node* pop(struct Stack* stack);
struct node* peek(struct Stack* stack);
struct node *desapilar(struct Stack* stack, struct node* fp);

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
int yyerror(char *);
void debug(char *);
void error(char *, char *);
void exito(char *);

/*graph */
void _add_dot (struct node *root);
void crearArchivoDot(struct node * root);

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
	bloque_sentencias                        { root = BloqueSentenciaP; }
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
	FLOAT 				{agregarTipo("FLOAT");}			{}
	| INTEGER 		{agregarTipo("INT");}				{}
	| STRING 			{agregarTipo("STRING");}		{}
	| BOOLEAN 		{agregarTipo("BOOLEAN");}		{}
;
//------------------------------------------------------------------------------------------------------

// sentencias ------------------------------------------------------------------------------------------
bloque_sentencias:
	sentencia
  { 
    debug("Regla 01 bloque de sentencia simple");
    BloqueSentenciaP = SentenciaP; }
	| bloque_sentencias { AuxBloqueSentenciaP = BloqueSentenciaP; } sentencia
  {
    debug("Regla 02 bloque de sentencias");
    BloqueSentenciaP = crearNodo("BS", AuxBloqueSentenciaP, SentenciaP);
  }
;

bloque_interno:
  sentencia
  {
    debug("Regla 05 bloque interno simple");
    BloqueInternoP = SentenciaP;
  }
  | bloque_interno { AuxBloqueInternoP = BloqueInternoP; } sentencia
  {
    debug("Regla 06 bloque interno");
    BloqueInternoP = crearNodo("BI", AuxBloqueInternoP, SentenciaP);
  }

sentencia:
	ciclo						 			{debug("Regla 07: sentencia es ciclo");}                      {SentenciaP = CicloP;}
	| if  					 			{debug("Regla 08: sentencia es if");}                         {SentenciaP = IFp;}
	| asignacion 		 			{debug("Regla 09: sentencia es asignacion ");}                {SentenciaP = AsignacionP;}
	| operasignacion 			{debug("Regla 10: sentencia es operacion y asignacion ");}    {SentenciaP = OperasignaP;}
	| salida				 			{debug("Regla 11: sentencia es salida");}                     {SentenciaP = SalidaP;}
	| entrada 			 			{debug("Regla 12: sentencia es entrada");}                    {SentenciaP = EntradaP;}
	| constante      		 	{debug("Regla 13: sentencia es declaracion de constante");}   {SentenciaP = ConstanteP;}
	| tipo 								{error("Uso de palabra reservada", ""); }
;

ciclo:
  WHILE P_A decision P_C L_A bloque_interno L_C  {CicloP = crearNodo("while", DecisionP, BloqueInternoP);}
;

if:
	IF P_A decision P_C L_A bloque_interno L_C
  {
    debug("Regla 14: if");
    DecisionP = desapilar(stackDecision, DecisionP);
    IFp = crearNodo("if", DecisionP, BloqueInternoP);
  }
	| IF P_A decision P_C sentencia
  {
    debug("Regla 15: if simple");
    DecisionP = desapilar(stackDecision, DecisionP);
    IFp = crearNodo("if", DecisionP, SentenciaP);
  }
	| IF P_A decision P_C L_A bloque_interno L_C { BSd = BloqueInternoP; } ELSE L_A bloque_interno L_C { BSi = BloqueInternoP; }
  {
    debug("Regla 16: if/else");
    DecisionP = desapilar(stackDecision, DecisionP);
    struct node *cuerpo = crearNodo("cuerpo", BSd, BSi);
    IFp = crearNodo("if", DecisionP, cuerpo);
  }
;

asignacion:
	ID OP_ASIGNACION expresion PUNTOCOMA 
  {
    debug("Regla 18: Asignacion simple");
    validarAsignacion($1);
    AsignacionP = crearNodo(":=", crearHoja($1), ExpresionP);
  }
;

constante:
	CONST nombre_constante OP_ASIGNACION expresion PUNTOCOMA
  {
    debug("Regla 19: Declaracion de constante");
    ConstanteP = crearNodo("CONST", AuxConstanteP, ExpresionP);
  }
;

nombre_constante:
	ID
  { 
    debug("Regla 20: lista_var es id constante");
    procesarSimbolo(yylval.strVal, 1);
    asignacionConst = 1;
    AuxConstanteP = crearHoja(yylval.strVal);
  }
;

operasignacion:
	ID {AuxOperasignaP = crearHoja(yylval.strVal);} operasigna expresion PUNTOCOMA
  {
    OperasignaP = crearNodo(_string, AuxOperasignaP, ExpresionP);
  }
;

operasigna:
	OP_ASIG_SUMA      {debug("Regla 21: Asignacion y suma");}             {_string = "+=";}
	| OP_ASIG_RESTA 	{debug("Regla 22: Asignacion y resta");}            {_string = "-=";}
	| OP_ASIG_POR   	{debug("Regla 23: Asignacion y multiplicacion");}   {_string = "*=";}
	| OP_ASIG_DIV     {debug("Regla 24: Asignacion y division");}         {_string = "/=";}
;

decision:
  condicion
  {
    debug("Regla 25: Decision simple");
    DecisionP = CondicionP;
    push(stackDecision, DecisionP);
  }
  | condicion {AuxCondicionP = CondicionP;} logico condicion
  {
    debug("Regla 26: Decision compuesta");
    DecisionP = crearNodo(_string1, AuxCondicionP, CondicionP);
  }
  | OP_NOT expresion {AuxExpresionP = ExpresionP;} comparacion expresion
  {
    debug("Regla 26: Decision negada");
    DecisionP = crearNodo("NOT", AuxExpresionP, ExpresionP);
  }
;

logico:
	OP_AND      												{debug("Regla 27: Decision multiple and");}    {_string1 = "AND";}
	| OP_OR     												{debug("Regla 28: Decision multiple or");}     {_string1 = "OR";}
;

condicion:
  expresion {AuxExpresionP = ExpresionP;} comparacion expresion
  {
    CondicionP = crearNodo(_string, AuxExpresionP, ExpresionP);
  }
;

comparacion:
	OP_COMP_IGUAL         {debug("Regla 29: Comparacion igual");}          {_string = "==";}
	| OP_COMP_DIST				{debug("Regla 30: Comparacion distinto");}       {_string = "<>";}
	| OP_MAYOR						{debug("Regla 31: Comparacion mayor");}          {_string = ">";}
	| OP_MENOR						{debug("Regla 32: Comparacion menor");}          {_string = "<";}
	| OP_COMP_MEN_IGUAL		{debug("Regla 33: Comparacion menor o igual");}  {_string = "<=";}
	| OP_COMP_MAY_IGUAL		{debug("Regla 34: Comparacion mayor o igual");}  {_string = ">=";}
;

expresion:
  termino                             	                                      {debug("expresion = termino");}									{ExpresionP = TerminoP;}
  | expresion {AuxExpresion3P = ExpresionP;} OP_SUMA termino                  {debug("Regla 36: expresion suma termino");}		{ExpresionP = crearNodo("+", AuxExpresion3P, TerminoP);}
  //| P_A expresion P_C {AuxExpresion3P = ExpresionP;} OP_SUMA P_A termino P_C  {debug("Regla 36: expresion suma termino");}		{ExpresionP = crearNodo("+", AuxExpresion3P, TerminoP);}
  | expresion {AuxExpresion3P = ExpresionP;} OP_RESTA termino                 {debug("Regla 37: expresion resta termino");} 	{ExpresionP = crearNodo("-", AuxExpresion3P, TerminoP);}
  //| P_A expresion P_C {AuxExpresion3P = ExpresionP;} OP_RESTA P_A termino P_C {debug("Regla 37: expresion resta termino");}		{ExpresionP = crearNodo("-", AuxExpresion3P, TerminoP);}
;

termino:
  factor
  {
    debug("\ntermino = factor");
    printf("\nfactor: %p %s", FactorP, FactorP->value);
    TerminoP = FactorP;
    push(stackParentesis, FactorP);
  }
  | termino /* {if(TerminoP == FactorP){ TerminoP = desapilar(stackParentesis, FactorP); }} {AuxTerminoP = TerminoP;}*/ OP_MUL factor
  {
    debug("\ntermino * factor");
    //if(TerminoP == FactorP){
      FactorP = desapilar(stackParentesis, FactorP);
      //TerminoP = peek(stackParentesis);
      //push(stackParentesis, FactorP);
      //TerminoP = AuxTerminoP;
      //FactorP  = peek(stackParentesis);
    //}
    //FactorP = desapilar(stackParentesis, FactorP);
    printf("\nfactor: %p %s", FactorP, FactorP->value);
    printf("\ntermin: %p %s", TerminoP, TerminoP->value);
    TerminoP = crearNodo("*", TerminoP, FactorP);
  }
  | termino OP_DIV factor       {debug("Regla 40: termino dividido factor");}		{TerminoP = crearNodo("/", TerminoP, FactorP);}
;

factor:
	ID 							{procesarID(yylval.strVal);}					{FactorP = crearHoja(yylval.strVal);}
	| TEXTO 				{procesarSTRING(yylval.strVal);}			{FactorP = crearHoja(yylval.strVal);}
	| ENTERO    		{procesarINT(atoi(yylval.strVal));}		{FactorP = crearHoja(yylval.strVal); /*push(stackParentesis, FactorP);*/}
	| REAL  				{procesarFLOAT(atof(yylval.strVal));} {FactorP = crearHoja(yylval.strVal);}
	| BOOLEAN
  | P_A expresion P_C
  {
    debug("\n( exp )");
    printf("\nfactor: %p %s", ExpresionP, ExpresionP->value);
    FactorP = ExpresionP;
    push(stackParentesis, FactorP);
  }
	| CONTAR P_A expresion { AuxExpresion2P = ExpresionP; } PUNTOCOMA lista P_C
  {
    debug("Regla 41: funcion contar");
    struct node *cont = crearNodo(":=", crearHoja("@cont"), crearHoja("0"));
    struct node *aux  = crearNodo(":=", crearHoja("@aux"), AuxExpresion2P);
    struct node *init = crearNodo("init", aux, cont);
    FactorP = crearNodo("contar", init, ListaP);
  }
;

// FactorP = crearNodo("()", ExpresionP, crearHoja("NULL"));


lista:
	expresion
  {
    struct node *compara = crearNodo("==", crearHoja("@aux"), ExpresionP);
    struct node *aumenta = crearNodo("+=", crearHoja("@cont"), crearHoja("1"));
    ListaP = crearNodo("if", compara, aumenta);
  }
	| lista { AuxListaP = ListaP; } COMA expresion
  {
    struct node *compara = crearNodo("==", crearHoja("@aux"), ExpresionP);
    struct node *aumenta = crearNodo("+=", crearHoja("@cont"), crearHoja("1"));
    struct node *condicion = crearNodo("if", compara, aumenta);
    ListaP = crearNodo("Lista", AuxListaP, condicion);
  }
	| C_A lista C_C
;

salida:
  PUT TEXTO PUNTOCOMA {SalidaP = crearNodo("IO", crearHoja("out"), crearHoja(yylval.strVal));}
  | PUT ID PUNTOCOMA  {SalidaP = crearNodo("IO", crearHoja("out"), crearHoja(yylval.strVal));}
;

entrada:
  GET ID PUNTOCOMA    {EntradaP = crearNodo("IO", crearHoja("in"), crearHoja(yylval.strVal));}
;

%%
// ----------------------------------------------------------------------------------

struct node *desapilar(struct Stack* stack, struct node* fp){
  struct node *n = pop(stack);
  if(n) return n;
  return fp;
}

struct node *crearHoja(char *nombre){
	return crearNodo(nombre, NULL, NULL);
}

struct node *crearNodo(char *nombre, struct node *left, struct node *right){
	struct node *hoja;
	hoja = (struct node *) malloc(sizeof(struct node));

  struct node *izq = NULL;
	struct node *der = NULL;
	
  if(left!=NULL){
		izq = (struct node *) malloc(sizeof(struct node));
		izq->value = left->value;
		izq->left  = left->left;
		izq->right = left->right;
	}

  if(right != NULL ){
		der = (struct node *) malloc(sizeof(struct node));
		der->value = right->value;
		der->right = right->right;
		der->left  = right->left;
	}

	(hoja)->value = nombre;
	(hoja)->right = der;
	(hoja)->left  = izq;

	return hoja;
}

void _print_h(struct node *root, int space) {
	int i;
  if (root == NULL) return;
  space += COUNT;
  _print_h(root->right, space);
  printf("\n");
  for (i = COUNT; i < space; i++) printf(" ");
  printf("%p %s \n", root,root->value);
  _print_h(root->left, space);
}

void print_h(struct node *root){
  _print_h(root, 0);
  printf("\n\n");
}

void crearArchivoDot(struct node * root){
	fp = fopen("intermedia.dot","w");
	fprintf(fp, " ");
	fp = fopen("intermedia.dot", "a");
	fprintf(fp, " digraph G { \n");

	_add_dot (root);
	fprintf(fp,"}");
    fclose(fp); 
	const char * cmd1 = " dot intermedia.dot -Tpng -o intermedia.png "; 
	system(cmd1); 
}

/*Agrega nodo a .dot*/
void _add_dot (struct node *root) {
  if (root == NULL) return;
	if (root -> left != NULL){
		fprintf(fp, "\"%p_%s\"->\"%p_%s\" \n",root,root->value, root->left,root->left->value);
    	_add_dot(root->left);
	}
	if (root -> right != NULL){
		fprintf(fp, "\"%p_%s\"->\"%p_%s\" \n",root,root->value, root->right,root->right->value);
		_add_dot(root->right);
	}
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

    stackDecision = createStack(100);
    stackParentesis = createStack(100);

		yyparse();
		escribirArchivo();
	}

  print_h(root);
  crearArchivoDot(root);

  printf("\n\n--------------------------------------------------------------------------------------------------------------------------------------------");


  // codigo temporal para ver la pila que estoy usando -------------
  struct node *n = pop(stackParentesis);
  while(n){
    print_h(n);
    printf("----------------------------------------------------------------------------");
    n = pop(stackParentesis);
  }
  // ---------------------------------------------------------------

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
	char mensaje[1000];
	sprintf(mensaje,texto,valor);
	yyerror(mensaje);
}
// --------------------------------------------------------------------

// function para imprimir mensajes en verde  --------------------------
void exito(char *texto){
	if(COLOR) printf("\033[0;32m");
	printf("\n%s\n", texto);
	if(COLOR) printf("\033[0;0m");
}
// --------------------------------------------------------------------

// Funciones de pila de punteros  ----------------------------------------
struct Stack* createStack(unsigned capacity) {
  struct Stack* stack = (struct Stack*)malloc(sizeof(struct Stack));
  stack->capacity = capacity;
  stack->top = -1;
  stack->array = (struct node**)malloc(stack->capacity * sizeof(struct node));
  return stack;
}

int isFull(struct Stack* stack) {
  return stack->top == stack->capacity - 1;
}

int isEmpty(struct Stack* stack) {
  return stack->top == -1;
}

void push(struct Stack* stack, struct node *item) {
  if (isFull(stack)) return;
  stack->array[++stack->top] = item;
}

struct node* pop(struct Stack* stack) {
  if (isEmpty(stack)) return NULL;
  return stack->array[stack->top--];
}

struct node* peek(struct Stack* stack) { 
    if (isEmpty(stack)) return NULL; 
    return stack->array[stack->top];
} 
// --------------------------------------------------------------------
