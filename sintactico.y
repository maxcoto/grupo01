%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <ctype.h>
#include "y.tab.h"

#define VERBOSE 0
#define COLOR 0

#define MIN_INT 0
#define MAX_INT 32767

#define MIN_FLOAT 0.002146
#define MAX_FLOAT 162136619726890008576.000000

#define TIPO_NULL 0
#define TIPO_NUMERO 1
#define TIPO_STRING 2

#define COUNT 10

int yylex();
FILE *yyin, *tsout, *pAsem;
FILE *fp = NULL;
char *yytext;

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
struct node *BloqueSentenciaP = NULL;
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
struct node *subArbol=NULL;
struct node *crearHoja(char *);
struct node *crearNodo(char *, struct node *, struct node *);

char* _comparacion;
char* _operasigna;
char* _decision;

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
struct node *desapilar(struct Stack* stack, struct node* fp);

typedef char*  t_dato;
typedef struct s_nodo {
  t_dato dato;
  struct s_nodo* sig;
} t_nodo;

typedef struct {
  t_nodo * fin;
  t_nodo * inicio;
} t_cola;

t_cola * crearCola ();
void encolar (t_cola * cola, t_dato * dato);
void desencolar (t_cola * cola, t_dato * dato);
int colaVacia (t_cola * cola);

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
int cantAux = 0;
t_cola *cola;

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
void addDot (struct node *root);
void crearArchivoDot(struct node * root);
char* strReplace(char* search, char* replace, char* subject);

struct node * arbolIzqConDosHijos( struct node * arbol);
void generarAssembler(struct node * arbol);
void reemplazarNodo(struct node *nodoViejo, char * aux );
char *pasarAssembler(struct node * arbol);

void imprimirHeaderAssembler();
void imprimirSimbolosAssembler();
void imprimirBodyAssembler();
void imprimirCodigoAssembler();
void imprimirFooterAssembler();

void intToString(int n, char s[]);
void reverseString(char s[]);

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
  { exito("Iniciando compilacion ..."); }
	programa
	{
    crearArchivoDot(root);
		generarAssembler(root);
    exito("\nCompilacion exitosa !!!\n");
  }
;

programa:
	{debug("Bloque de declaraciones");}
	bloque_declaracion
	{debug("Bloque de sentencias");}
	bloque_sentencias
  { root = BloqueSentenciaP; }
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
	FLOAT 				{agregarTipo("FLOAT");}			{debug("Regla 03: float");}
	| INTEGER 		{agregarTipo("INT");}				{debug("Regla 04: integer");}
	| STRING 			{agregarTipo("STRING");}		{debug("Regla 05: string");}
	| BOOLEAN 		{agregarTipo("BOOLEAN");}		{debug("Regla 06: boolean");}
;
//------------------------------------------------------------------------------------------------------

// sentencias ------------------------------------------------------------------------------------------
bloque_sentencias:
	sentencia
  {
    debug("Regla 07: sentencia simple");
    BloqueSentenciaP = SentenciaP; }
	| bloque_sentencias { AuxBloqueSentenciaP = BloqueSentenciaP; } sentencia
  {
    debug("Regla 08: bloque de sentencias");
    BloqueSentenciaP = crearNodo("BS", AuxBloqueSentenciaP, SentenciaP);
  }
;

bloque_interno:
  sentencia
  {
    debug("Regla 09: sentencia interna simple");
    BloqueInternoP = SentenciaP;
  }
  | bloque_interno { AuxBloqueInternoP = BloqueInternoP; } sentencia
  {
    debug("Regla 10: bloque interno");
    BloqueInternoP = crearNodo("BI", AuxBloqueInternoP, SentenciaP);
  }

sentencia:
	ciclo						 			{debug("Regla 11: sentencia es ciclo");}                      {SentenciaP = CicloP;}
	| if  					 			{debug("Regla 12: sentencia es if");}                         {SentenciaP = IFp;}
	| asignacion 		 			{debug("Regla 13: sentencia es asignacion ");}                {SentenciaP = AsignacionP;}
	| operasignacion 			{debug("Regla 14: sentencia es operacion y asignacion ");}    {SentenciaP = OperasignaP;}
	| salida				 			{debug("Regla 15: sentencia es salida");}                     {SentenciaP = SalidaP;}
	| entrada 			 			{debug("Regla 16: sentencia es entrada");}                    {SentenciaP = EntradaP;}
	| constante      		 	{debug("Regla 17: sentencia es declaracion de constante");}   {SentenciaP = ConstanteP;}
	| tipo 								{error("Uso de palabra reservada", ""); }
;

ciclo:
  WHILE P_A decision P_C L_A bloque_interno L_C
  {
    debug("Regla 18: ciclo while");
    DecisionP = desapilar(stackDecision, DecisionP);
    CicloP = crearNodo("while", DecisionP, BloqueInternoP);
  }
;

if:
	IF P_A decision P_C L_A bloque_interno L_C
  {
    debug("Regla 19: if");
    DecisionP = desapilar(stackDecision, DecisionP);
    IFp = crearNodo("if", DecisionP, BloqueInternoP);
  }
	| IF P_A decision P_C sentencia
  {
    debug("Regla 20: if simple");
    DecisionP = desapilar(stackDecision, DecisionP);
    IFp = crearNodo("if", DecisionP, SentenciaP);
  }
	| IF P_A decision P_C L_A bloque_interno L_C { BSd = BloqueInternoP; } ELSE L_A bloque_interno L_C { BSi = BloqueInternoP; }
  {
    debug("Regla 21: if/else");
    DecisionP = desapilar(stackDecision, DecisionP);
    struct node *cuerpo = crearNodo("cuerpo", BSd, BSi);
    IFp = crearNodo("if", DecisionP, cuerpo);
  }
;

asignacion:
	ID OP_ASIGNACION expresion PUNTOCOMA
  {
    debug("Regla 22: Asignacion simple");
    validarAsignacion($1);
    AsignacionP = crearNodo(":=", crearHoja($1), ExpresionP);
  }
;

constante:
	CONST nombre_constante OP_ASIGNACION expresion PUNTOCOMA
  {
    debug("Regla 23: Declaracion de constante");
    ConstanteP = crearNodo("CONST", AuxConstanteP, ExpresionP);
  }
;

nombre_constante:
	ID
  {
    procesarSimbolo(yylval.strVal, 1);
    asignacionConst = 1;
    AuxConstanteP = crearHoja(yylval.strVal);
  }
;

operasignacion:
	ID {AuxOperasignaP = crearHoja(yylval.strVal);} operasigna expresion PUNTOCOMA
  {
    debug("Regla 25: Operacion con asignacion");
    OperasignaP = crearNodo(_comparacion, AuxOperasignaP, ExpresionP);
  }
;

operasigna:
	OP_ASIG_SUMA      {debug("Regla 26: Asignacion y suma");}             {_comparacion = "+=";}
	| OP_ASIG_RESTA 	{debug("Regla 27: Asignacion y resta");}            {_comparacion = "-=";}
	| OP_ASIG_POR   	{debug("Regla 28: Asignacion y multiplicacion");}   {_comparacion = "*=";}
	| OP_ASIG_DIV     {debug("Regla 29: Asignacion y division");}         {_comparacion = "/=";}
;

decision:
  condicion
  {
    debug("Regla 30: Decision simple");
    DecisionP = CondicionP;
    push(stackDecision, DecisionP);
  }
  | condicion {AuxCondicionP = CondicionP;} logico condicion
  {
    debug("Regla 31: Decision compuesta");
    DecisionP = crearNodo(_decision, AuxCondicionP, CondicionP);
    push(stackDecision, DecisionP);
  }
  | OP_NOT expresion {AuxExpresionP = ExpresionP;} comparacion expresion
  {
    debug("Regla 32: Decision negada");
    DecisionP = crearNodo("NOT", AuxExpresionP, ExpresionP);
    push(stackDecision, DecisionP);
  }
;

logico:
	OP_AND    {debug("Regla 33: Decision multiple and");}    {_decision = "AND";}
	| OP_OR   {debug("Regla 34: Decision multiple or");}     {_decision = "OR";}
;

condicion:
  expresion {AuxExpresionP = ExpresionP;} comparacion expresion
  {
    debug("Regla 35: Condicion");
    CondicionP = crearNodo(_comparacion, AuxExpresionP, ExpresionP);
  }
;

comparacion:
	OP_COMP_IGUAL         {debug("Regla 36: Comparacion igual");}          {_comparacion = "==";}
	| OP_COMP_DIST				{debug("Regla 37: Comparacion distinto");}       {_comparacion = "<>";}
	| OP_MAYOR						{debug("Regla 38: Comparacion mayor");}          {_comparacion = ">";}
	| OP_MENOR						{debug("Regla 39: Comparacion menor");}          {_comparacion = "<";}
	| OP_COMP_MEN_IGUAL		{debug("Regla 40: Comparacion menor o igual");}  {_comparacion = "<=";}
	| OP_COMP_MAY_IGUAL		{debug("Regla 41: Comparacion mayor o igual");}  {_comparacion = ">=";}
;

expresion:
  termino
  {
    debug("Regla 41: Expresion es termino");
    ExpresionP = TerminoP;
  }
  | expresion { push(stackParentesis, ExpresionP); } OP_SUMA termino
  {
    debug("Regla 42: expresion suma termino");
    ExpresionP = desapilar(stackParentesis, ExpresionP);
    ExpresionP = crearNodo("+", ExpresionP, TerminoP);
  }
  | expresion { push(stackParentesis, ExpresionP); } OP_RESTA termino
  {
    debug("Regla 43: expresion resta termino");
    ExpresionP = desapilar(stackParentesis, ExpresionP);
    ExpresionP = crearNodo("-", ExpresionP, TerminoP);
  }
;

termino:
  factor
  {
    debug("Regla 44: termino es factor");
    TerminoP = FactorP;
  }
  | termino { push(stackParentesis, TerminoP); } OP_MUL factor
  {
    debug("Regla 45: termino multiplica factor");

    TerminoP = desapilar(stackParentesis, TerminoP);
 	  TerminoP = crearNodo("*", TerminoP, FactorP);
  }
  | termino {push(stackParentesis, TerminoP) ;} OP_DIV factor
  {
    debug("Regla 46: termino dividido factor");
    TerminoP = desapilar(stackParentesis, TerminoP);
    TerminoP = crearNodo("/", TerminoP, FactorP);
  }
;

factor:
	ID 							{procesarID(yylval.strVal);}					{FactorP = crearHoja(yylval.strVal);}
	| TEXTO 				{procesarSTRING(yylval.strVal);}			{FactorP = crearHoja(yylval.strVal);}
	| ENTERO    		{procesarINT(atoi(yylval.strVal));}		{FactorP = crearHoja(yylval.strVal);}
	| REAL  				{procesarFLOAT(atof(yylval.strVal));} {FactorP = crearHoja(yylval.strVal);}
	| BOOLEAN
  | P_A expresion P_C
  {
    debug("Regla 47: expresion entre parentesis");
    FactorP = ExpresionP;
  }
	| CONTAR P_A expresion { AuxExpresion2P = ExpresionP; } PUNTOCOMA lista P_C
  {
    debug("Regla 48: funcion contar");
    struct node *cont = crearNodo(":=", crearHoja("@cont"), crearHoja("0"));
    struct node *aux  = crearNodo(":=", crearHoja("@aux"), AuxExpresion2P);
    struct node *init = crearNodo("init", aux, cont);
    FactorP = crearNodo("contar", init, ListaP);
  }
;

lista:
	expresion
  {
    debug("Regla 49: lista es expresion");
    struct node *compara = crearNodo("==", crearHoja("@aux"), ExpresionP);
    struct node *aumenta = crearNodo("+=", crearHoja("@cont"), crearHoja("1"));
    ListaP = crearNodo("if", compara, aumenta);
  }
	| lista { AuxListaP = ListaP; } COMA expresion
  {
    debug("Regla 50: lista, lista");
    struct node *compara = crearNodo("==", crearHoja("@aux"), ExpresionP);
    struct node *aumenta = crearNodo("+=", crearHoja("@cont"), crearHoja("1"));
    struct node *condicion = crearNodo("if", compara, aumenta);
    ListaP = crearNodo("Lista", AuxListaP, condicion);
  }
	| C_A lista C_C
;

salida:
  PUT TEXTO PUNTOCOMA
  {
    debug("Regla 51: salida por pantalla");
    SalidaP = crearNodo("IO", crearHoja("out"), crearHoja(yylval.strVal));
  }
  | PUT ID PUNTOCOMA
  {
    debug("Regla 52: salida por pantalla - ID");
    SalidaP = crearNodo("IO", crearHoja("out"), crearHoja(yylval.strVal));
  }
;

entrada:
  GET ID PUNTOCOMA
  {
    debug("Regla 53: entrada de datos");
    EntradaP = crearNodo("IO", crearHoja("in"), crearHoja(yylval.strVal));
  }
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

	if(left != NULL && right != NULL){
		izq = left;
		der = right;
	}

	(hoja)->value = nombre;
	(hoja)->right = der;
	(hoja)->left  = izq;

	return hoja;
}

void crearArchivoDot(struct node * root){
	fp = fopen("intermedia.dot","w");
	fprintf(fp, " ");
	fp = fopen("intermedia.dot", "a");
	fprintf(fp, " digraph G { \n");

	addDot (root);
	fprintf(fp,"}");
    fclose(fp);
	const char * cmd1 = " dot intermedia.dot -Tpng -o intermedia.png ";
	system(cmd1);
}

/*Agrega nodo a .dot*/
void addDot (struct node *root) {
  if (root == NULL) return;
  char* value;
	if (root -> left != NULL){
    value = strReplace("\"", "'", root->left->value);
		fprintf(fp, "\"%p_%s\"->\"%p_%s\" \n",root,root->value, root->left,value);
    addDot(root->left);
	}
	if (root -> right != NULL){
    value = strReplace("\"", "'", root->right->value);
		fprintf(fp, "\"%p_%s\"->\"%p_%s\" \n",root,root->value, root->right,value);
		addDot(root->right);
	}
}

// funcion principal ----------------------------------------------------------------
int main(int argc,char *argv[]) {
	if((yyin = fopen(argv[1], "rt")) == NULL){
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
		return 1;
  } else {
		if((tsout = fopen("ts.txt", "wt")) == NULL){
			printf("\nNo se puede abrir o crear el archivo: ts.txt\n");
			fclose(yyin);
			return 1;
		}
		if((pAsem = fopen("final.asm","wt")) == NULL){
			printf("\nNo se puede abrir o crear el archivo: assemble.asm\n");
			fclose(yyin);
			return 1;
		}

    cola = crearCola();
    stackDecision = createStack(100);
    stackParentesis = createStack(100);

		yyparse();
		escribirArchivo();
	}

	fclose(yyin);
	fclose(tsout);
	fclose(pAsem);
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
		error("Entero fuera de rango:", "(0; 32767)");
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
		char *guion = ((strcmp(tablaSimbolos[i].tipo, "") != 0) || strcmp(tablaSimbolos[i].valor, "") == 0) ? " " : "_";
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

// --------------------------------------------------------------------

char* strReplace(char* search, char* replace, char* subject) {
	int i, j, k;

	int searchSize = strlen(search);
	int replaceSize = strlen(replace);
	int size = strlen(subject);

	char* ret;

	if (!searchSize) {
		ret = malloc(size + 1);
		for (i = 0; i <= size; i++) {
			ret[i] = subject[i];
		}
		return ret;
	}

	int retAllocSize = (strlen(subject) + 1) * 2;
	ret = malloc(retAllocSize);

	int bufferSize = 0;
	char* foundBuffer = malloc(searchSize);

	for (i = 0, j = 0; i <= size; i++) {
		if (retAllocSize <= j + replaceSize) {
			retAllocSize *= 2;
			ret = (char*) realloc(ret, retAllocSize);
		}
		else if (subject[i] == search[bufferSize]) {
			foundBuffer[bufferSize] = subject[i];
			bufferSize++;

			if (bufferSize == searchSize) {
				bufferSize = 0;
				for (k = 0; k < replaceSize; k++) {
					ret[j++] = replace[k];
				}
			}
		}
		else {
			for (k = 0; k < bufferSize; k++) {
				ret[j++] = foundBuffer[k];
			}
			bufferSize = 0;

			ret[j++] = subject[i];
		}
	}

	free(foundBuffer);
	return ret;
}

void imprimirHeaderAssembler(){
  fprintf(pAsem, "include macros2.asm\n");
  fprintf(pAsem, "include number.asm\n");
  fprintf(pAsem, ".MODEL LARGE\n.386\n.STACK 200h\n\n.DATA\n");
}

void imprimirSimbolosAssembler(){
	int i;
	for(i = 0; i<posicionTabla; i++){
		char *guion = strcmp(tablaSimbolos[i].valor, "") == 0 ? "" : "_";
    char *valor = strcmp(tablaSimbolos[i].valor, "") != 0 ? tablaSimbolos[i].valor : "?";

    //int longi = tablaSimbolos[i].longitud;
	  //char longitud_texto[10] = {""};
		//if(longi > 0) { sprintf(longitud_texto, "%d", longi - 2); }

		fprintf(pAsem, "%s%s\tdd\t%s\n", guion, tablaSimbolos[i].nombre, valor); //, longitud_texto);
	}
}

void imprimirBodyAssembler(){
  fprintf(pAsem,"\n.CODE");
  fprintf(pAsem,"\nSTART:");
	fprintf(pAsem,"\nMOV AX, @DATA");
	fprintf(pAsem,"\nMOV DS, AX");
	fprintf(pAsem,"\nMOV ES, AX\n\n");
}

void imprimirCodigoAssembler(){
	char *dato = (char *)malloc(sizeof(char)*100);
	while(!colaVacia(cola)){
    desencolar(cola, &dato);
    fprintf(pAsem, "%s", dato);
	}
}

void imprimirFooterAssembler(){
  fprintf(pAsem,"MOV AX,4c00h\n" );
  fprintf(pAsem,"int 21h\n" );
  fprintf(pAsem,"\nEND" );
}

/*---------------------------------------------------GENERAR ASSEMBLER-------------------------------------------*/
void generarAssembler(struct node *arbol){
	char *reemplazo = NULL;

  while(arbol->left && arbol->right){
		struct node * nodo = arbolIzqConDosHijos(arbol);
    printf(""); // no tocar

		if(nodo){
			reemplazo = pasarAssembler(nodo);
      reemplazarNodo(nodo, reemplazo);
		}
	}

	imprimirHeaderAssembler();
	imprimirSimbolosAssembler();
  imprimirBodyAssembler();
  imprimirCodigoAssembler();
  imprimirFooterAssembler();
}

void reemplazarNodo(struct node *nodo, char * aux ){
	free(nodo->left);
	free(nodo->right);
	nodo->left = NULL;
	nodo->right = NULL;
	nodo->value = aux;
}

struct node *arbolIzqConDosHijos( struct node * arbol){
	if(!arbol) return NULL;

	if(arbol->left && arbol->left->left && arbol->left->right){
		return arbolIzqConDosHijos(arbol->left);
	} else if	(arbol->right && arbol->right->left && arbol->right->right){
		return arbolIzqConDosHijos(arbol->right);
	}

	return arbol;
}

char *pasarAssembler(struct node *arbol){
  char *cant;
  intToString(cantAux, cant);
  int cantDigitos = strlen(cant);
  char *reemplazo = (char *)malloc(5+cantDigitos);
  strcpy(reemplazo, "@aux");
  strcat(reemplazo, cant);

  char *dato = (char *)malloc(100);

  if(strcmp(arbol->value, "<>") == 0){
    strcpy(dato, "CMP ");
		strcat(dato, arbol->left->value);
    strcat(dato, ",");
    strcat(dato, arbol->right->value);
		strcat(dato, "\n");
		strcat(dato, "JE");
		strcat(dato, "\n");
    encolar(cola, &dato);
    return reemplazo;
	}
  
  if(strcmp(arbol->value, "==") == 0){
    strcpy(dato, "CMP ");
		strcat(dato, arbol->left->value);
    strcat(dato, ",");
    strcat(dato, arbol->right->value);
		strcat(dato, "\n");
		strcat(dato, "JNE");
		strcat(dato, "\n");
    encolar(cola, &dato);
    return reemplazo;
	}
  
  if(strcmp(arbol->value, ">") == 0){
    strcpy(dato, "CMP ");
		strcat(dato, arbol->left->value);
    strcat(dato, ",");
    strcat(dato, arbol->right->value);
		strcat(dato, "\n");
		strcat(dato, "JNA");
		strcat(dato, "\n");
    encolar(cola, &dato);
    return reemplazo;
	}
  
  if(strcmp(arbol->value, "<") == 0){
    strcpy(dato, "CMP ");
		strcat(dato, arbol->left->value);
    strcat(dato, ",");
    strcat(dato, arbol->right->value);
		strcat(dato, "\n");
		strcat(dato, "JAE");
		strcat(dato, "\n");
    encolar(cola, &dato);
    return reemplazo;
	}
  
  if(strcmp(arbol->value, ">=") == 0){
    strcpy(dato, "CMP ");
		strcat(dato, arbol->left->value);
    strcat(dato, ",");
    strcat(dato, arbol->right->value);
		strcat(dato, "\n");
		strcat(dato, "JB");
		strcat(dato, "\n");
    encolar(cola, &dato);
    return reemplazo;
	}
  
  if(strcmp(arbol->value, "<=") == 0){
    strcpy(dato, "CMP ");
		strcat(dato, arbol->left->value);
    strcat(dato, ",");
    strcat(dato, arbol->right->value);
		strcat(dato, "\n");
		strcat(dato, "JA");
		strcat(dato, "\n");
    encolar(cola, &dato);
    return reemplazo;
	}
  
  if(strstr(arbol->value, ":=")){
		strcpy(dato, "FLD ");
		strcat(dato, arbol->right->value);
		strcat(dato, "\n");
		strcat(dato, "FSTP ");
		strcat(dato, arbol->left->value);
		strcat(dato, "\n");
		encolar(cola, &dato);
    return reemplazo;
	}
  
  if( strstr(arbol->value,"+")){
		strcpy(dato, "FLD ");
		strcat(dato, arbol->left->value);
    strcat(dato, "\n");
    strcpy(dato, "FLD ");
		strcat(dato, arbol->right->value);
		strcat(dato, "\n");
		strcat(dato, "FADD");
		strcat(dato, "\n");
		strcat(dato, "FSTP ");
		strcat(dato, reemplazo);
		strcat(dato, "\n\n");
		encolar(cola, &dato);
	  escribirTabla(reemplazo, "", 0, 0);
		cantAux++;
    return reemplazo;
	}
  
  if( strstr(arbol->value,"*")){
		strcpy(dato, "FLD ");
		strcat(dato, arbol->left->value);
		strcat(dato, "\n");
		strcat(dato, "FMUL ");
		strcat(dato, arbol->right->value);
		strcat(dato, "\n");
		strcat(dato, "FSTP ");
		strcat(dato, reemplazo);
		strcat(dato, "\n\n");
		encolar(cola, &dato);
		escribirTabla(reemplazo, "", 0, 0);
		cantAux++;
    return reemplazo;
	}
  
  if(strstr(arbol->value,"/")){
		strcpy(dato,"FLD ");
		strcat(dato,arbol->left->value);
		strcat(dato, "\n");
		strcat(dato, "FDIV ");
		strcat(dato, arbol->right->value);
		strcat(dato, "\n");
		strcat(dato, "FSTP ");
	  strcat(dato, reemplazo);
		strcat(dato, "\n\n");
		encolar(cola, &dato);
		escribirTabla(reemplazo, "", 0, 0);
		cantAux++;
    return reemplazo;
	}
  
  if( strstr(arbol->value,"-")){
		strcpy(dato,"FLD ");
		strcat(dato,arbol->left->value);
		strcat(dato,"\n");
		strcat(dato,"FSUB ");
		strcat(dato,arbol->right->value);
		strcat(dato,"\n");
		strcat(dato,"FSTP ");
		strcat(dato,reemplazo);
		strcat(dato,"\n\n");
		encolar(cola, &dato);
		escribirTabla(reemplazo, "", 0, 0);
		cantAux++;
    return reemplazo;
	}
  
  if(strstr(arbol->value,"IO")){
    if(strstr(arbol->left->value,"in")){
      fprintf(pAsem,"\nsoy get\n");
    } else {
    	fprintf(pAsem,"\n\tMOV DX, OFFSET %s \n",arbol->right->value);
    	fprintf(pAsem,"\tMOV AH, 9\n");
    	fprintf(pAsem,"\tINT 21H\n");
    }
  }	else {
		reemplazo = "ninguna";
  }
  
  return reemplazo;
}

t_cola *crearCola(){
	t_cola * cola = (t_cola*)malloc(sizeof(t_cola));
  cola->inicio = cola->fin = NULL;
	return cola;
}

void encolar(t_cola * cola, t_dato * dato){
  t_nodo * nue = (t_nodo*)malloc(sizeof(t_nodo));
  if (nue == NULL) return;
  nue->dato = *dato;
  nue->sig = NULL;

  if(cola->inicio){
    cola->fin->sig = nue;
  } else {
    cola->inicio = nue;
  }

  cola->fin = nue;
}

void desencolar(t_cola * cola, t_dato * dato){
  if(cola->inicio == NULL) return;
  t_nodo * nae;
  nae = cola->inicio;
  *dato = nae->dato;
  cola->inicio = nae->sig;
  free(nae);
  if (cola->inicio == NULL) cola->fin = NULL;
}

int colaVacia(t_cola * cola){
  return cola->inicio == NULL ? 1 : 0;
}

void intToString(int n, char s[]){
  int i, sign;

  if ((sign = n) < 0)  /* record sign */
     n = -n;          /* make n positive */
  i = 0;
  do {       /* generate digits in reverse order */
     s[i++] = n % 10 + '0';   /* get next digit */
  } while ((n /= 10) > 0);     /* delete it */
  if (sign < 0)
     s[i++] = '-';
  s[i] = '\0';
  reverseString(s);
}

void reverseString(char s[]){
  int i, j;
  char c;
  for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
    c = s[i];
    s[i] = s[j];
    s[j] = c;
  }
}
