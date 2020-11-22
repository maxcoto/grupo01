
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 1



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 1 "sintactico.y"

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

const char *stringName = "_string";
const char *etiquetaIF = "IF1";
const char *etiquetaELSE = "ELSE1";
struct node *lastParent = NULL;

t_ts tablaSimbolos[5000];
int validaTipo = 0;
int posicionTabla = 0;
int posicionTipo = 0;
int asignacionConst = 0;
int salidaString = 0;
int cantVariables = 0;
int cantTipos = 0;
int cantAux = 0;
int stringCount = 0;
t_cola *cola;

void validarTipo(int);

void escribirTabla(char *, char *, int, int);
int buscarSimbolo(char *);

void procesarSimbolo(char *, int);
void procesarID(char *);
char *procesarINT(float);
char *procesarFLOAT(float);
char *procesarSTRING(char *);

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
char *pasarAssembler(struct node *);

void imprimirHeaderAssembler();
void imprimirSimbolosAssembler();
void imprimirBodyAssembler();
void imprimirCodigoAssembler();
void imprimirFooterAssembler();

void intToString(int n, char s[]);
void reverseString(char s[]);



/* Line 189 of yacc.c  */
#line 247 "y.tab.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     PUNTOCOMA = 258,
     DOSPUNTOS = 259,
     COMA = 260,
     P_A = 261,
     P_C = 262,
     L_A = 263,
     L_C = 264,
     C_A = 265,
     C_C = 266,
     OP_SUMA = 267,
     OP_RESTA = 268,
     OP_MUL = 269,
     OP_DIV = 270,
     OP_ASIGNACION = 271,
     OP_ASIG_SUMA = 272,
     OP_ASIG_RESTA = 273,
     OP_ASIG_POR = 274,
     OP_ASIG_DIV = 275,
     OP_MENOR = 276,
     OP_MAYOR = 277,
     OP_COMP_MAY_IGUAL = 278,
     OP_COMP_MEN_IGUAL = 279,
     OP_COMP_IGUAL = 280,
     OP_COMP_DIST = 281,
     OP_AND = 282,
     OP_OR = 283,
     OP_NOT = 284,
     PUT = 285,
     GET = 286,
     INTEGER = 287,
     FLOAT = 288,
     STRING = 289,
     BOOLEAN = 290,
     IF = 291,
     ELSE = 292,
     DIM = 293,
     AS = 294,
     CONTAR = 295,
     CONST = 296,
     WHILE = 297,
     TEXTO = 298,
     ENTERO = 299,
     REAL = 300,
     ID = 301
   };
#endif
/* Tokens.  */
#define PUNTOCOMA 258
#define DOSPUNTOS 259
#define COMA 260
#define P_A 261
#define P_C 262
#define L_A 263
#define L_C 264
#define C_A 265
#define C_C 266
#define OP_SUMA 267
#define OP_RESTA 268
#define OP_MUL 269
#define OP_DIV 270
#define OP_ASIGNACION 271
#define OP_ASIG_SUMA 272
#define OP_ASIG_RESTA 273
#define OP_ASIG_POR 274
#define OP_ASIG_DIV 275
#define OP_MENOR 276
#define OP_MAYOR 277
#define OP_COMP_MAY_IGUAL 278
#define OP_COMP_MEN_IGUAL 279
#define OP_COMP_IGUAL 280
#define OP_COMP_DIST 281
#define OP_AND 282
#define OP_OR 283
#define OP_NOT 284
#define PUT 285
#define GET 286
#define INTEGER 287
#define FLOAT 288
#define STRING 289
#define BOOLEAN 290
#define IF 291
#define ELSE 292
#define DIM 293
#define AS 294
#define CONTAR 295
#define CONST 296
#define WHILE 297
#define TEXTO 298
#define ENTERO 299
#define REAL 300
#define ID 301




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 174 "sintactico.y"
 char *strVal; 


/* Line 214 of yacc.c  */
#line 379 "y.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
} YYLTYPE;
# define yyltype YYLTYPE /* obsolescent; will be withdrawn */
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 404 "y.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL \
	     && defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
  YYLTYPE yyls_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE) + sizeof (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   143

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  47
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  70
/* YYNRULES -- Number of rules.  */
#define YYNRULES  110
/* YYNRULES -- Number of states.  */
#define YYNSTATES  171

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   301

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     7,     8,     9,    14,    16,    19,
      28,    29,    32,    33,    38,    40,    44,    45,    48,    49,
      52,    53,    56,    57,    60,    62,    63,    67,    69,    70,
      74,    75,    78,    79,    82,    83,    86,    87,    90,    91,
      94,    95,    98,    99,   102,   104,   112,   120,   126,   127,
     128,   142,   147,   153,   155,   156,   162,   163,   166,   167,
     170,   171,   174,   175,   178,   180,   181,   186,   187,   193,
     194,   197,   198,   201,   202,   207,   208,   211,   212,   215,
     216,   219,   220,   223,   224,   227,   228,   231,   233,   234,
     239,   240,   245,   247,   248,   253,   254,   259,   261,   263,
     265,   267,   271,   272,   280,   282,   283,   288,   292,   296,
     300
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      48,     0,    -1,    -1,    49,    50,    -1,    -1,    -1,    51,
      53,    52,    64,    -1,    54,    -1,    53,    54,    -1,    38,
      21,    55,    22,    39,    21,    58,    22,    -1,    -1,    46,
      56,    -1,    -1,    55,     5,    46,    57,    -1,    59,    -1,
      58,     5,    59,    -1,    -1,    33,    60,    -1,    -1,    32,
      61,    -1,    -1,    34,    62,    -1,    -1,    35,    63,    -1,
      68,    -1,    -1,    64,    65,    68,    -1,    68,    -1,    -1,
      66,    67,    68,    -1,    -1,    76,    69,    -1,    -1,    77,
      70,    -1,    -1,    80,    71,    -1,    -1,    83,    72,    -1,
      -1,   115,    73,    -1,    -1,   116,    74,    -1,    -1,    81,
      75,    -1,    59,    -1,    42,     6,    90,     7,     8,    66,
       9,    -1,    36,     6,    90,     7,     8,    66,     9,    -1,
      36,     6,    90,     7,    68,    -1,    -1,    -1,    36,     6,
      90,     7,     8,    66,     9,    78,    37,     8,    66,     9,
      79,    -1,    46,    16,   105,     3,    -1,    41,    82,    16,
     105,     3,    -1,    46,    -1,    -1,    46,    84,    85,   105,
       3,    -1,    -1,    17,    86,    -1,    -1,    18,    87,    -1,
      -1,    19,    88,    -1,    -1,    20,    89,    -1,    96,    -1,
      -1,    96,    91,    93,    96,    -1,    -1,    29,   105,    92,
      98,   105,    -1,    -1,    27,    94,    -1,    -1,    28,    95,
      -1,    -1,   105,    97,    98,   105,    -1,    -1,    25,    99,
      -1,    -1,    26,   100,    -1,    -1,    22,   101,    -1,    -1,
      21,   102,    -1,    -1,    24,   103,    -1,    -1,    23,   104,
      -1,   108,    -1,    -1,   105,   106,    12,   108,    -1,    -1,
     105,   107,    13,   108,    -1,   111,    -1,    -1,   108,   109,
      14,   111,    -1,    -1,   108,   110,    15,   111,    -1,    46,
      -1,    43,    -1,    44,    -1,    45,    -1,     6,   105,     7,
      -1,    -1,    40,     6,   105,   112,     3,   113,     7,    -1,
     105,    -1,    -1,   113,   114,     5,   105,    -1,    10,   113,
      11,    -1,    30,    43,     3,    -1,    30,    46,     3,    -1,
      31,    46,     3,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   200,   200,   200,   210,   212,   210,   219,   220,   224,
     228,   228,   229,   229,   233,   234,   238,   238,   239,   239,
     240,   240,   241,   241,   247,   251,   251,   259,   264,   264,
     271,   271,   272,   272,   273,   273,   274,   274,   275,   275,
     276,   276,   277,   277,   278,   282,   291,   297,   303,   303,
     303,   313,   322,   330,   339,   339,   347,   347,   348,   348,
     349,   349,   350,   350,   354,   360,   360,   366,   366,   375,
     375,   376,   376,   380,   380,   388,   388,   389,   389,   390,
     390,   391,   391,   392,   392,   393,   393,   397,   402,   402,
     408,   408,   417,   422,   422,   429,   429,   438,   443,   447,
     452,   457,   462,   462,   473,   480,   480,   488,   492,   498,
     506
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "PUNTOCOMA", "DOSPUNTOS", "COMA", "P_A",
  "P_C", "L_A", "L_C", "C_A", "C_C", "OP_SUMA", "OP_RESTA", "OP_MUL",
  "OP_DIV", "OP_ASIGNACION", "OP_ASIG_SUMA", "OP_ASIG_RESTA",
  "OP_ASIG_POR", "OP_ASIG_DIV", "OP_MENOR", "OP_MAYOR",
  "OP_COMP_MAY_IGUAL", "OP_COMP_MEN_IGUAL", "OP_COMP_IGUAL",
  "OP_COMP_DIST", "OP_AND", "OP_OR", "OP_NOT", "PUT", "GET", "INTEGER",
  "FLOAT", "STRING", "BOOLEAN", "IF", "ELSE", "DIM", "AS", "CONTAR",
  "CONST", "WHILE", "TEXTO", "ENTERO", "REAL", "ID", "$accept", "inicio",
  "$@1", "programa", "$@2", "$@3", "bloque_declaracion", "declaracion",
  "variables", "$@4", "$@5", "tipo_variables", "tipo", "$@6", "$@7", "$@8",
  "$@9", "bloque_sentencias", "$@10", "bloque_interno", "$@11",
  "sentencia", "$@12", "$@13", "$@14", "$@15", "$@16", "$@17", "$@18",
  "ciclo", "if", "$@19", "$@20", "asignacion", "constante",
  "nombre_constante", "operasignacion", "$@21", "operasigna", "$@22",
  "$@23", "$@24", "$@25", "decision", "$@26", "$@27", "logico", "$@28",
  "$@29", "condicion", "$@30", "comparacion", "$@31", "$@32", "$@33",
  "$@34", "$@35", "$@36", "expresion", "$@37", "$@38", "termino", "$@39",
  "$@40", "factor", "$@41", "lista", "$@42", "salida", "entrada", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    47,    49,    48,    51,    52,    50,    53,    53,    54,
      56,    55,    57,    55,    58,    58,    60,    59,    61,    59,
      62,    59,    63,    59,    64,    65,    64,    66,    67,    66,
      69,    68,    70,    68,    71,    68,    72,    68,    73,    68,
      74,    68,    75,    68,    68,    76,    77,    77,    78,    79,
      77,    80,    81,    82,    84,    83,    86,    85,    87,    85,
      88,    85,    89,    85,    90,    91,    90,    92,    90,    94,
      93,    95,    93,    97,    96,    99,    98,   100,    98,   101,
      98,   102,    98,   103,    98,   104,    98,   105,   106,   105,
     107,   105,   108,   109,   108,   110,   108,   111,   111,   111,
     111,   111,   112,   111,   113,   114,   113,   113,   115,   115,
     116
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     0,     0,     4,     1,     2,     8,
       0,     2,     0,     4,     1,     3,     0,     2,     0,     2,
       0,     2,     0,     2,     1,     0,     3,     1,     0,     3,
       0,     2,     0,     2,     0,     2,     0,     2,     0,     2,
       0,     2,     0,     2,     1,     7,     7,     5,     0,     0,
      13,     4,     5,     1,     0,     5,     0,     2,     0,     2,
       0,     2,     0,     2,     1,     0,     4,     0,     5,     0,
       2,     0,     2,     0,     4,     0,     2,     0,     2,     0,
       2,     0,     2,     0,     2,     0,     2,     1,     0,     4,
       0,     4,     1,     0,     4,     0,     4,     1,     1,     1,
       1,     3,     0,     7,     1,     0,     4,     3,     3,     3,
       3
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     4,     1,     3,     0,     0,     5,     7,     0,
       0,     8,    10,     0,     0,     0,    18,    16,    20,    22,
       0,     0,     0,    54,    44,    25,    24,    30,    32,    34,
      42,    36,    38,    40,    11,     0,     0,     0,     0,     0,
      19,    17,    21,    23,     0,    53,     0,     0,     0,     0,
       0,    31,    33,    35,    43,    37,    39,    41,    12,     0,
     108,   109,   110,     0,     0,     0,    98,    99,   100,    97,
       0,    65,    73,    87,    92,     0,     0,    88,    56,    58,
      60,    62,     0,    26,    13,     0,    88,    67,     0,     0,
       0,     0,     0,     0,     0,     0,    88,     0,    51,    57,
      59,    61,    63,    88,     0,    14,   101,     0,    88,     0,
      47,    69,    71,     0,    81,    79,    85,    83,    75,    77,
       0,     0,     0,     0,     0,    52,     0,    55,     0,     9,
       0,     0,    28,    27,    70,    72,    66,    82,    80,    86,
      84,    76,    78,    74,    89,    91,    94,    96,    28,    15,
      68,     0,    46,     0,    45,     0,   104,   105,     0,    29,
     105,   103,     0,     0,   107,     0,     0,   106,    28,    49,
      50
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     2,     4,     5,    10,     7,     8,    13,    34,
      84,   104,    24,    41,    40,    42,    43,    25,    50,   132,
     153,   133,    51,    52,    53,    55,    56,    57,    54,    27,
      28,   158,   170,    29,    30,    46,    31,    49,    82,    99,
     100,   101,   102,    70,    90,   107,   113,   134,   135,    71,
      91,   120,   141,   142,   138,   137,   140,   139,    72,    92,
      93,    73,    94,    95,    74,   131,   157,   162,    32,    33
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -123
static const yytype_int8 yypact[] =
{
    -123,    10,  -123,  -123,  -123,   -30,    -9,   -30,  -123,   -20,
      79,  -123,  -123,    -2,   -16,   -15,  -123,  -123,  -123,  -123,
      60,    -4,    66,    61,  -123,    76,  -123,  -123,  -123,  -123,
    -123,  -123,  -123,  -123,  -123,    32,    41,    78,    81,    82,
    -123,  -123,  -123,  -123,     3,  -123,    70,     3,    19,    51,
      79,  -123,  -123,  -123,  -123,  -123,  -123,  -123,  -123,    67,
    -123,  -123,  -123,    19,    19,    90,  -123,  -123,  -123,  -123,
      75,    80,    21,    36,  -123,    19,    91,     2,  -123,  -123,
    -123,  -123,    19,  -123,  -123,     4,     0,    21,    19,    59,
      26,   105,    85,    86,    88,    92,     8,    95,  -123,  -123,
    -123,  -123,  -123,    11,     1,  -123,  -123,   105,    16,    79,
    -123,  -123,  -123,    19,  -123,  -123,  -123,  -123,  -123,  -123,
      19,    19,    19,    19,    19,  -123,    79,  -123,     4,  -123,
      19,   103,   107,  -123,  -123,  -123,  -123,  -123,  -123,  -123,
    -123,  -123,  -123,    21,    36,    36,  -123,  -123,   108,  -123,
      21,    12,    87,    79,  -123,    12,    21,   112,    96,  -123,
     111,  -123,   118,   124,  -123,    19,    79,    21,   125,  -123,
    -123
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -123,  -123,  -123,  -123,  -123,  -123,  -123,   128,  -123,  -123,
    -123,  -123,   -83,  -123,  -123,  -123,  -123,  -123,  -123,  -122,
    -123,   -10,  -123,  -123,  -123,  -123,  -123,  -123,  -123,  -123,
    -123,  -123,  -123,  -123,  -123,  -123,  -123,  -123,  -123,  -123,
    -123,  -123,  -123,    89,  -123,  -123,  -123,  -123,  -123,    24,
    -123,    31,  -123,  -123,  -123,  -123,  -123,  -123,   -47,  -123,
    -123,   -61,  -123,  -123,   -49,  -123,   -14,  -123,  -123,  -123
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -103
static const yytype_int16 yytable[] =
{
      26,    77,   105,    35,   148,    98,   128,   106,     6,    63,
       3,   125,     9,   -90,   127,   -90,    86,    87,    63,  -102,
      36,   -90,   155,   129,   -90,    63,    12,    37,    96,   -90,
      38,    39,    64,   -88,   -90,   103,    16,    17,    18,    19,
      83,   108,    45,    65,   168,   149,    66,    67,    68,    69,
     -93,   -95,    65,   111,   112,    66,    67,    68,    69,    65,
     144,   145,    66,    67,    68,    69,    44,   109,    78,    79,
      80,    81,    47,   143,   146,   147,    -6,    48,    58,   110,
      59,    60,    89,   150,    61,    62,    75,   -64,    85,    14,
      15,    16,    17,    18,    19,    20,    88,   121,    97,   122,
      21,    22,   123,   126,   156,    23,   151,   124,   156,    14,
      15,    16,    17,    18,    19,    20,   152,   154,   167,   161,
      21,    22,   164,   165,   -48,    23,   114,   115,   116,   117,
     118,   119,   166,   163,   169,    11,    76,   136,   130,     0,
       0,   160,     0,   159
};

static const yytype_int16 yycheck[] =
{
      10,    48,    85,     5,   126,     3,     5,     7,    38,     6,
       0,     3,    21,    13,     3,    13,    63,    64,     6,     3,
      22,    13,    10,    22,    13,     6,    46,    43,    75,    13,
      46,    46,    29,    12,    13,    82,    32,    33,    34,    35,
      50,    88,    46,    40,   166,   128,    43,    44,    45,    46,
      14,    15,    40,    27,    28,    43,    44,    45,    46,    40,
     121,   122,    43,    44,    45,    46,     6,     8,    17,    18,
      19,    20,     6,   120,   123,   124,     0,    16,    46,    89,
      39,     3,     7,   130,     3,     3,    16,     7,    21,    30,
      31,    32,    33,    34,    35,    36,     6,    12,     7,    13,
      41,    42,    14,     8,   151,    46,     3,    15,   155,    30,
      31,    32,    33,    34,    35,    36,     9,     9,   165,     7,
      41,    42,    11,     5,    37,    46,    21,    22,    23,    24,
      25,    26,     8,    37,     9,     7,    47,   113,   107,    -1,
      -1,   155,    -1,   153
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    48,    49,     0,    50,    51,    38,    53,    54,    21,
      52,    54,    46,    55,    30,    31,    32,    33,    34,    35,
      36,    41,    42,    46,    59,    64,    68,    76,    77,    80,
      81,    83,   115,   116,    56,     5,    22,    43,    46,    46,
      61,    60,    62,    63,     6,    46,    82,     6,    16,    84,
      65,    69,    70,    71,    75,    72,    73,    74,    46,    39,
       3,     3,     3,     6,    29,    40,    43,    44,    45,    46,
      90,    96,   105,   108,   111,    16,    90,   105,    17,    18,
      19,    20,    85,    68,    57,    21,   105,   105,     6,     7,
      91,    97,   106,   107,   109,   110,   105,     7,     3,    86,
      87,    88,    89,   105,    58,    59,     7,    92,   105,     8,
      68,    27,    28,    93,    21,    22,    23,    24,    25,    26,
      98,    12,    13,    14,    15,     3,     8,     3,     5,    22,
      98,   112,    66,    68,    94,    95,    96,   102,   101,   104,
     103,    99,   100,   105,   108,   108,   111,   111,    66,    59,
     105,     3,     9,    67,     9,    10,   105,   113,    78,    68,
     113,     7,   114,    37,    11,     5,     8,   105,    66,     9,
      79
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value, Location); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    YYLTYPE const * const yylocationp;
#endif
{
  if (!yyvaluep)
    return;
  YYUSE (yylocationp);
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep, yylocationp)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    YYLTYPE const * const yylocationp;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  YY_LOCATION_PRINT (yyoutput, *yylocationp);
  YYFPRINTF (yyoutput, ": ");
  yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yylsp, yyrule)
    YYSTYPE *yyvsp;
    YYLTYPE *yylsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       , &(yylsp[(yyi + 1) - (yynrhs)])		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, yylsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp)
#else
static void
yydestruct (yymsg, yytype, yyvaluep, yylocationp)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
    YYLTYPE *yylocationp;
#endif
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Location data for the lookahead symbol.  */
YYLTYPE yylloc;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.
       `yyls': related to locations.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    /* The location stack.  */
    YYLTYPE yylsa[YYINITDEPTH];
    YYLTYPE *yyls;
    YYLTYPE *yylsp;

    /* The locations where the error started and ended.  */
    YYLTYPE yyerror_range[2];

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yyls = yylsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;
  yylsp = yyls;

#if YYLTYPE_IS_TRIVIAL
  /* Initialize the default location before parsing starts.  */
  yylloc.first_line   = yylloc.last_line   = 1;
  yylloc.first_column = yylloc.last_column = 1;
#endif

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;
	YYLTYPE *yyls1 = yyls;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yyls1, yysize * sizeof (*yylsp),
		    &yystacksize);

	yyls = yyls1;
	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
	YYSTACK_RELOCATE (yyls_alloc, yyls);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;
  *++yylsp = yylloc;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

  /* Default location.  */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:

/* Line 1455 of yacc.c  */
#line 200 "sintactico.y"
    { exito("Iniciando compilacion ..."); }
    break;

  case 3:

/* Line 1455 of yacc.c  */
#line 202 "sintactico.y"
    {
    crearArchivoDot(root);
		generarAssembler(root);
    exito("\nCompilacion exitosa !!!\n");
  }
    break;

  case 4:

/* Line 1455 of yacc.c  */
#line 210 "sintactico.y"
    {debug("Bloque de declaraciones");}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 212 "sintactico.y"
    {debug("Bloque de sentencias");}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 214 "sintactico.y"
    { root = BloqueSentenciaP; }
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 224 "sintactico.y"
    {validarVariables();}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 228 "sintactico.y"
    { procesarSimbolo(yylval.strVal, 0);}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 228 "sintactico.y"
    { debug("Regla 01: variables es ID");}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 229 "sintactico.y"
    { procesarSimbolo(yylval.strVal, 0);}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 229 "sintactico.y"
    { debug("Regla 02: variables es variables puntocoma id");}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 238 "sintactico.y"
    {agregarTipo("FLOAT");}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 238 "sintactico.y"
    {debug("Regla 03: float");}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 239 "sintactico.y"
    {agregarTipo("INT");}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 239 "sintactico.y"
    {debug("Regla 04: integer");}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 240 "sintactico.y"
    {agregarTipo("STRING");}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 240 "sintactico.y"
    {debug("Regla 05: string");}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 241 "sintactico.y"
    {agregarTipo("BOOLEAN");}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 241 "sintactico.y"
    {debug("Regla 06: boolean");}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 248 "sintactico.y"
    {
    debug("Regla 07: sentencia simple");
    BloqueSentenciaP = SentenciaP; }
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 251 "sintactico.y"
    { AuxBloqueSentenciaP = BloqueSentenciaP; }
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 252 "sintactico.y"
    {
    debug("Regla 08: bloque de sentencias");
    BloqueSentenciaP = crearNodo("BS", AuxBloqueSentenciaP, SentenciaP);
  }
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 260 "sintactico.y"
    {
    debug("Regla 09: sentencia interna simple");
    BloqueInternoP = SentenciaP;
  }
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 264 "sintactico.y"
    { AuxBloqueInternoP = BloqueInternoP; }
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 265 "sintactico.y"
    {
    debug("Regla 10: bloque interno");
    BloqueInternoP = crearNodo("BI", AuxBloqueInternoP, SentenciaP);
  }
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 271 "sintactico.y"
    {debug("Regla 11: sentencia es ciclo");}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 271 "sintactico.y"
    {SentenciaP = CicloP;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 272 "sintactico.y"
    {debug("Regla 12: sentencia es if");}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 272 "sintactico.y"
    {SentenciaP = IFp;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 273 "sintactico.y"
    {debug("Regla 13: sentencia es asignacion ");}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 273 "sintactico.y"
    {SentenciaP = AsignacionP;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 274 "sintactico.y"
    {debug("Regla 14: sentencia es operacion y asignacion ");}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 274 "sintactico.y"
    {SentenciaP = OperasignaP;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 275 "sintactico.y"
    {debug("Regla 15: sentencia es salida");}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 275 "sintactico.y"
    {SentenciaP = SalidaP;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 276 "sintactico.y"
    {debug("Regla 16: sentencia es entrada");}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 276 "sintactico.y"
    {SentenciaP = EntradaP;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 277 "sintactico.y"
    {debug("Regla 17: sentencia es declaracion de constante");}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 277 "sintactico.y"
    {SentenciaP = ConstanteP;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 278 "sintactico.y"
    {error("Uso de palabra reservada", ""); }
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 283 "sintactico.y"
    {
    debug("Regla 18: ciclo while");
    DecisionP = desapilar(stackDecision, DecisionP);
    CicloP = crearNodo("while", DecisionP, BloqueInternoP);
  }
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 292 "sintactico.y"
    {
    debug("Regla 19: if");
    DecisionP = desapilar(stackDecision, DecisionP);
    IFp = crearNodo("if", DecisionP, BloqueInternoP);
  }
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 298 "sintactico.y"
    {
    debug("Regla 20: if simple");
    DecisionP = desapilar(stackDecision, DecisionP);
    IFp = crearNodo("if", DecisionP, SentenciaP);
  }
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 303 "sintactico.y"
    { BSd = BloqueInternoP; }
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 303 "sintactico.y"
    { BSi = BloqueInternoP; }
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 304 "sintactico.y"
    {
    debug("Regla 21: if/else");
    DecisionP = desapilar(stackDecision, DecisionP);
    struct node *cuerpo = crearNodo("cuerpo", BSd, BSi);
    IFp = crearNodo("if", DecisionP, cuerpo);
  }
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 314 "sintactico.y"
    {
    debug("Regla 22: Asignacion simple");
    validarAsignacion((yyvsp[(1) - (4)].strVal));
    AsignacionP = crearNodo(":=", crearHoja((yyvsp[(1) - (4)].strVal)), ExpresionP);
  }
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 323 "sintactico.y"
    {
    debug("Regla 23: Declaracion de constante");
    ConstanteP = crearNodo("CONST", AuxConstanteP, ExpresionP);
  }
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 331 "sintactico.y"
    {
    procesarSimbolo(yylval.strVal, 1);
    asignacionConst = 1;
    AuxConstanteP = crearHoja(yylval.strVal);
  }
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 339 "sintactico.y"
    {AuxOperasignaP = crearHoja(yylval.strVal);}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 340 "sintactico.y"
    {
    debug("Regla 25: Operacion con asignacion");
    OperasignaP = crearNodo(_comparacion, AuxOperasignaP, ExpresionP);
  }
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 347 "sintactico.y"
    {debug("Regla 26: Asignacion y suma");}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 347 "sintactico.y"
    {_comparacion = "+=";}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 348 "sintactico.y"
    {debug("Regla 27: Asignacion y resta");}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 348 "sintactico.y"
    {_comparacion = "-=";}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 349 "sintactico.y"
    {debug("Regla 28: Asignacion y multiplicacion");}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 349 "sintactico.y"
    {_comparacion = "*=";}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 350 "sintactico.y"
    {debug("Regla 29: Asignacion y division");}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 350 "sintactico.y"
    {_comparacion = "/=";}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 355 "sintactico.y"
    {
    debug("Regla 30: Decision simple");
    DecisionP = CondicionP;
    push(stackDecision, DecisionP);
  }
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 360 "sintactico.y"
    {AuxCondicionP = CondicionP;}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 361 "sintactico.y"
    {
    debug("Regla 31: Decision compuesta");
    DecisionP = crearNodo(_decision, AuxCondicionP, CondicionP);
    push(stackDecision, DecisionP);
  }
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 366 "sintactico.y"
    {AuxExpresionP = ExpresionP;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 367 "sintactico.y"
    {
    debug("Regla 32: Decision negada");
    DecisionP = crearNodo("NOT", AuxExpresionP, ExpresionP);
    push(stackDecision, DecisionP);
  }
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 375 "sintactico.y"
    {debug("Regla 33: Decision multiple and");}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 375 "sintactico.y"
    {_decision = "AND";}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 376 "sintactico.y"
    {debug("Regla 34: Decision multiple or");}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 376 "sintactico.y"
    {_decision = "OR";}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 380 "sintactico.y"
    {AuxExpresionP = ExpresionP;}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 381 "sintactico.y"
    {
    debug("Regla 35: Condicion");
    CondicionP = crearNodo(_comparacion, AuxExpresionP, ExpresionP);
  }
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 388 "sintactico.y"
    {debug("Regla 36: Comparacion igual");}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 388 "sintactico.y"
    {_comparacion = "==";}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 389 "sintactico.y"
    {debug("Regla 37: Comparacion distinto");}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 389 "sintactico.y"
    {_comparacion = "<>";}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 390 "sintactico.y"
    {debug("Regla 38: Comparacion mayor");}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 390 "sintactico.y"
    {_comparacion = ">";}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 391 "sintactico.y"
    {debug("Regla 39: Comparacion menor");}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 391 "sintactico.y"
    {_comparacion = "<";}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 392 "sintactico.y"
    {debug("Regla 40: Comparacion menor o igual");}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 392 "sintactico.y"
    {_comparacion = "<=";}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 393 "sintactico.y"
    {debug("Regla 41: Comparacion mayor o igual");}
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 393 "sintactico.y"
    {_comparacion = ">=";}
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 398 "sintactico.y"
    {
    debug("Regla 41: Expresion es termino");
    ExpresionP = TerminoP;
  }
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 402 "sintactico.y"
    { push(stackParentesis, ExpresionP); }
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 403 "sintactico.y"
    {
    debug("Regla 42: expresion suma termino");
    ExpresionP = desapilar(stackParentesis, ExpresionP);
    ExpresionP = crearNodo("+", ExpresionP, TerminoP);
  }
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 408 "sintactico.y"
    { push(stackParentesis, ExpresionP); }
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 409 "sintactico.y"
    {
    debug("Regla 43: expresion resta termino");
    ExpresionP = desapilar(stackParentesis, ExpresionP);
    ExpresionP = crearNodo("-", ExpresionP, TerminoP);
  }
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 418 "sintactico.y"
    {
    debug("Regla 44: termino es factor");
    TerminoP = FactorP;
  }
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 422 "sintactico.y"
    { push(stackParentesis, TerminoP); }
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 423 "sintactico.y"
    {
    debug("Regla 45: termino multiplica factor");

    TerminoP = desapilar(stackParentesis, TerminoP);
 	  TerminoP = crearNodo("*", TerminoP, FactorP);
  }
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 429 "sintactico.y"
    {push(stackParentesis, TerminoP) ;}
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 430 "sintactico.y"
    {
    debug("Regla 46: termino dividido factor");
    TerminoP = desapilar(stackParentesis, TerminoP);
    TerminoP = crearNodo("/", TerminoP, FactorP);
  }
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 439 "sintactico.y"
    {
    procesarID(yylval.strVal);
    FactorP = crearHoja(yylval.strVal);
  }
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 444 "sintactico.y"
    {
    FactorP = crearHoja(procesarSTRING(yylval.strVal));
  }
    break;

  case 99:

/* Line 1455 of yacc.c  */
#line 448 "sintactico.y"
    {
    char *result = procesarINT(atof(yylval.strVal));
    FactorP = crearHoja(result);
  }
    break;

  case 100:

/* Line 1455 of yacc.c  */
#line 453 "sintactico.y"
    {
    char *result = procesarFLOAT(atof(yylval.strVal));
    FactorP = crearHoja(result);
  }
    break;

  case 101:

/* Line 1455 of yacc.c  */
#line 458 "sintactico.y"
    {
    debug("Regla 47: expresion entre parentesis");
    FactorP = ExpresionP;
  }
    break;

  case 102:

/* Line 1455 of yacc.c  */
#line 462 "sintactico.y"
    { AuxExpresion2P = ExpresionP; }
    break;

  case 103:

/* Line 1455 of yacc.c  */
#line 463 "sintactico.y"
    {
    debug("Regla 48: funcion contar");
    struct node *cont = crearNodo(":=", crearHoja("@cont"), crearHoja("0"));
    struct node *aux  = crearNodo(":=", crearHoja("@aux"), AuxExpresion2P);
    struct node *init = crearNodo("init", aux, cont);
    FactorP = crearNodo("contar", init, ListaP);
  }
    break;

  case 104:

/* Line 1455 of yacc.c  */
#line 474 "sintactico.y"
    {
    debug("Regla 49: lista es expresion");
    struct node *compara = crearNodo("==", crearHoja("@aux"), ExpresionP);
    struct node *aumenta = crearNodo("+=", crearHoja("@cont"), crearHoja("1"));
    ListaP = crearNodo("if", compara, aumenta);
  }
    break;

  case 105:

/* Line 1455 of yacc.c  */
#line 480 "sintactico.y"
    { AuxListaP = ListaP; }
    break;

  case 106:

/* Line 1455 of yacc.c  */
#line 481 "sintactico.y"
    {
    debug("Regla 50: lista, lista");
    struct node *compara = crearNodo("==", crearHoja("@aux"), ExpresionP);
    struct node *aumenta = crearNodo("+=", crearHoja("@cont"), crearHoja("1"));
    struct node *condicion = crearNodo("if", compara, aumenta);
    ListaP = crearNodo("Lista", AuxListaP, condicion);
  }
    break;

  case 108:

/* Line 1455 of yacc.c  */
#line 493 "sintactico.y"
    {
    debug("Regla 51: salida por pantalla");
    salidaString = 1;
    SalidaP = crearNodo("IO", crearHoja("out"), crearHoja(procesarSTRING(yylval.strVal)));
  }
    break;

  case 109:

/* Line 1455 of yacc.c  */
#line 499 "sintactico.y"
    {
    debug("Regla 52: salida por pantalla - ID");
    SalidaP = crearNodo("IO", crearHoja("out"), crearHoja(yylval.strVal));
  }
    break;

  case 110:

/* Line 1455 of yacc.c  */
#line 507 "sintactico.y"
    {
    debug("Regla 53: entrada de datos");
    EntradaP = crearNodo("IO", crearHoja("in"), crearHoja(yylval.strVal));
  }
    break;



/* Line 1455 of yacc.c  */
#line 2661 "y.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;
  *++yylsp = yyloc;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }

  yyerror_range[0] = yylloc;

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval, &yylloc);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  yyerror_range[0] = yylsp[1-yylen];
  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;

      yyerror_range[0] = *yylsp;
      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp, yylsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;

  yyerror_range[1] = yylloc;
  /* Using YYLLOC is tempting, but would change the location of
     the lookahead.  YYLOC is available though.  */
  YYLLOC_DEFAULT (yyloc, (yyerror_range - 1), 2);
  *++yylsp = yyloc;

  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval, &yylloc);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp, yylsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 513 "sintactico.y"

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
char *procesarINT(float numero){
	char texto[32];
  char *_texto = (char *)malloc(100);

	if(numero < MIN_INT || numero >= MAX_INT){
		error("Entero fuera de rango:", "(0; 32767)");
	}

  sprintf(texto, "%f", numero);
  strcpy(_texto, "_");
  strcat(_texto, texto);

	if(buscarSimbolo(texto) == -1) {
		escribirTabla(_texto, texto, 0, 0);
	}

	if(asignacionConst == 1){
		agregarTipo("INT");
		asignacionConst = 0;
	} else {
		validarTipo(TIPO_NUMERO);
	}

	return _texto;
}
//--------------------------------------------------------------------
// valida y almacena strings -----------------------------------------
char *procesarSTRING(char *str){
	int a = 0;
	char *aux = str;
	int i;
  char texto[15];
  char *_texto = (char *)malloc(50);

  int largo = strlen(aux);
  char cadenaPura[30];

	if(largo > 30){
		error("Cadena demasiado larga:", "(<30)");
	}

  sprintf(texto, "%d", stringCount);
  strcpy(_texto, stringName);
  strcat(_texto, texto);
  stringCount++;

	for(i = 1; i<largo-1; i++){
    cadenaPura[a] = str[i];
    a++;
  }

	cadenaPura[a--]='\0';

  if(buscarSimbolo(cadenaPura) == -1){
		escribirTabla(_texto, cadenaPura, largo, 0);
	}

	if(asignacionConst == 1){
		agregarTipo("STRING");
		asignacionConst = 0;
	} else {
    if(salidaString == 1){
      salidaString = 0;
    } else {
      validarTipo(TIPO_STRING);
    }
	}

	return _texto;
}
//--------------------------------------------------------------------
// valida y almacena floats -----------------------------------------
char *procesarFLOAT(float numero){
  char texto[32];
  char *_texto = (char *)malloc(100);

	if(numero < MIN_FLOAT || numero > MAX_FLOAT){
		error("Float fuera de rango", "(-1.17549e-38; 3.40282e38)");
	}

  sprintf(texto, "%f", numero);
  strcpy(_texto, "_");
  strcat(_texto, texto);

	if(buscarSimbolo(texto) == -1){
		escribirTabla(_texto, texto, 0, 0);
	}

	if(asignacionConst == 1){
		agregarTipo("FLOAT");
		asignacionConst = 0;
	} else {
		validarTipo(TIPO_NUMERO);
	}

	return _texto;
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
		char tipo_str[14] = {""};
		strcpy(tipo_str, tablaSimbolos[i].tipo);
		if(tablaSimbolos[i].es_const) { strcat(tipo_str, " CONST"); }

		int longi = tablaSimbolos[i].longitud;
	  char longitud_texto[10] = {""};
		if(longi > 0) { sprintf(longitud_texto, "%d", longi - 2); }

		fprintf(tsout, "%-30s|\t%-14s|\t%-16s|\t%-8s\t\n", tablaSimbolos[i].nombre, tipo_str, tablaSimbolos[i].valor, longitud_texto);
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
    char *valor = strcmp(tablaSimbolos[i].valor, "") != 0 ? tablaSimbolos[i].valor : "?";

    if(tablaSimbolos[i].longitud > 0) {
      fprintf(pAsem, "%s\tdb\t\"%s\",'$',%d dup (?)\n", tablaSimbolos[i].nombre, valor, tablaSimbolos[i].longitud);
    } else {
      fprintf(pAsem, "%s\tdd\t%s\n", tablaSimbolos[i].nombre, valor);
    }
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
  fprintf(pAsem, "\n\nMOV AX,4c00h\n" );
  fprintf(pAsem, "int 21h\n" );
  fprintf(pAsem, "\nEND" );
}

/*---------------------------------------------------GENERAR ASSEMBLER-------------------------------------------*/
void generarAssembler(struct node *arbol){
	char *reemplazo = NULL;
  struct node *anterior = arbol;

  while(arbol->left && arbol->right){
		struct node *nodo = arbolIzqConDosHijos(arbol);
    //printf("asdasd"); // no tocar
    fflush(stdin);

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

struct node *arbolIzqConDosHijos( struct node *arbol){
	if(!arbol) return NULL;

	if(arbol->left && arbol->left->left && arbol->left->right){
    lastParent = arbol;
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
    char *dato2 = (char *)malloc(100);
   strcpy(dato2,"");

  char *dato = (char *)malloc(100);
  int salta = 0;

  if(strcmp(arbol->value, "if") == 0){
    strcpy(dato, etiquetaIF);
    strcat(dato, ":");
		strcat(dato, "\n");
    encolar(cola, &dato);
    return reemplazo;
  }

  if(lastParent != NULL){
    //char *dato2 = (char *)malloc(100);
    printf("\t\t\t\t\t lastParent: %s == arbol: %s \n",lastParent->right->value,arbol->value);

    if(strcmp(lastParent->value, "cuerpo") == 0 && lastParent->right==arbol){
      lastParent = NULL;
      strcpy(dato2, "JMP ");
      strcat(dato2, etiquetaIF);
      strcat(dato2, "\n");
      strcat(dato2, etiquetaELSE);
      strcat(dato2, ":");
      strcat(dato2, "\n\n");
     // encolar(cola, &dato2);
    }
  }

  if(
    strcmp(arbol->value, "<>") == 0 ||
    strcmp(arbol->value, "==") == 0 ||
    strcmp(arbol->value, ">")  == 0 ||
    strcmp(arbol->value, "<")  == 0 ||
    strcmp(arbol->value, ">=") == 0 ||
    strcmp(arbol->value, "<=") == 0
  ){
    strcpy(dato, "FLD ");
		strcat(dato, arbol->left->value);
    strcat(dato, "\n");
    strcat(dato, "FCOMP ");
    strcat(dato, arbol->right->value);
		strcat(dato, "\n");
    strcat(dato, "FSTSW AX");
    strcat(dato, "\n");
    strcat(dato, "SAHF");
		strcat(dato, "\n");
    salta = 1;
  }

  if(strcmp(arbol->value, "<>") == 0){
		strcat(dato, "JE");
	}

  if(strcmp(arbol->value, "==") == 0){
    strcat(dato, "JNE");
	}

  if(strcmp(arbol->value, ">") == 0){
    strcat(dato, "JNA");
	}

  if(strcmp(arbol->value, "<") == 0){
		strcat(dato, "JAE");
	}

  if(strcmp(arbol->value, ">=") == 0){
		strcat(dato, "JB");
	}

  if(strcmp(arbol->value, "<=") == 0){
		strcat(dato, "JA");
	}

  if(salta == 1){
    strcat(dato, " ");
    if(strcmp(lastParent->right->value, "cuerpo") == 0  &&  lastParent->right==arbol){
      strcat(dato, etiquetaELSE);
    } else {
      strcat(dato, etiquetaIF);
    }

    strcat(dato, "\n");
    encolar(cola, &dato);
    return reemplazo;
  }

  if(strstr(arbol->value, ":=")){
		  printf("\t\t\t\t llego asignacion y dato2: %s\n", dato2);
	  	strcpy(dato,dato2);
	  printf("\t\t\t\t llego asignacion y dato: %s\n", dato);
		strcat(dato, "FLD ");
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
    strcat(dato, "FLD ");
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
      strcpy(dato,"GetFloat ");
      strcat(dato,arbol->right->value);
      strcat(dato,"\n");
    } else {
      if( strstr(arbol->right->value, "_string") != NULL ) {
        strcpy(dato,"MOV DX, OFFSET ");
        strcat(dato,arbol->right->value);
        strcat(dato,"\n");
        strcat(dato,"MOV AH, 9\n");
        strcat(dato,"INT 21H\n");
      } else {
        strcpy(dato,"DisplayFloat ");
        strcat(dato,arbol->right->value);
        strcat(dato, ", 2\n");
      }
    }
    encolar(cola, &dato);
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

