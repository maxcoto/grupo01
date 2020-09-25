%{
#include <stdio.h>
#include <stdlib.h>
#include <curses.h>
FILE  *yyin;
int yylval;
char *yytext;
%}
%option noyywrap
%option yylineno

INTEGER            "Integer"
FLOAT              "Float"
DECVAR             "DECVAR"
ENDDEC             "ENDDEC"
WRITE              "write"
WHILE              "while"
A_PAREN            "("
C_PAREN            ")"
A_CORCH            "{"
C_CORCH            "}"
IF                 "if"
ELSE               "else"


DIGITO    [0-9]
LETRA     [a-zA-Z]
ENTERO    {DIGITO}+
GUIONB    [_]
REAL      {DIGITO}+"."{DIGITO}+
ID        {LETRA}({LETRA}|{DIGITO}|{GUIONB})*({LETRA}|{DIGITO})
TEXTO     \"(.)*\"

ASSIGN    ":"
SUM       "+"
MIN_EQ    "<="
MIN       "<"
MAY_EQ    ">="
MAY       ">"
NOT_EQ    "!="
EQ        "=="
DIVIDE    "/"
MULTIPLY  "*"
END       ";"


%%
{WRITE}            printf("\nWrite: %s\n", yytext);
{INTEGER}          printf("\nInteger: %s\n", yytext);
{FLOAT}            printf("\nFloat: %s\n", yytext);
{ENTERO}           printf("\nConstante entera: %s\n", yytext);
{WHILE}            printf("\nWhile: %s\n", yytext);
{TEXTO}            printf("\nTexto: %s\n", yytext);
{REAL}             printf("\nReal: %s\n", yytext);
{SUM}              printf("\nSuma: %s\n", yytext);
{DIVIDE}           printf("\nDivision: %s\n", yytext);
{MULTIPLY}         printf("\nMultiplicacion: %s\n", yytext);
{ASSIGN}           printf("\nAsignacion: %s\n", yytext);
{MIN_EQ}           printf("\nMenor igual: %s\n", yytext);
{MIN}              printf("\nMenor: %s\n", yytext);
{MAY_EQ}           printf("\nMayor igual: %s\n", yytext);
{MAY}              printf("\nMayor: %s\n", yytext);
{EQ}               printf("\nComparacion igual: %s\n", yytext);
{NOT_EQ}           printf("\nComparacion distinto: %s\n", yytext);
{END}              printf("\nPunto y coma: %s\n", yytext);
{A_PAREN}          printf("\nAbre Parentesis: %s\n", yytext);
{C_PAREN}          printf("\nCierra Parentesis: %s\n", yytext);
{A_CORCH}          printf("\nAbre corchete: %s\n", yytext);
{C_CORCH}          printf("\nCierra corchete: %s\n", yytext);
{IF}               printf("\nIf: %s\n", yytext);
{ELSE}             printf("\nElse: %s\n", yytext);
{DECVAR}           printf("\nDecvar: %s\n", yytext);
{ENDDEC}           printf("\nEnddec: %s\n", yytext);
{ID}               printf("\nId: %s\n", yytext);

"\n"
"\t"
%%

int main(int argc, char *argv[]) {

  if((yyin = fopen(argv[1], "rt")) == NULL) {
    printf("\nNo se pudo abrir el archivo: %s\n", argv[1]);
  } else {
    yylex();
  }

  fclose(yyin);
  return 0;
}

int yyerror(void)  {
  printf("\nSyntax error\n");
  system("Pause");
  exit(1);
}








