%{

#include <stdio.h>
FILE  *yyin;

#define APAR "("
#define CPAR ")"

#define ASIG ":="
#define MAS  "+"
#define MEN  "-"
#define DIV  "/"
#define POR  "*"
#define END  ";"

%}


%token ID
%token CTE
%left MAS MEN
%left POR DIV
%right IGUAL
%token APAR
%token CPAR
%token MAS
%token MENOS
%token POR
%token DIV
%token NUM


%%

e : e MAS e
| e MEN e
| e POR e
| e DIV e
| MEN e %prec POR
| CPAR e APAR
| ID
| NUM
;

%%


int yylex(void){
  //yyval = posicion en tabla de simbolos(token)
  //return = token
}

int yyerror(char * s) {
  fprintf(stderr, "%s\n", s);
}

int main(int argc, char *argv[]) {

  if((yyin = fopen(argv[1], "rt")) == NULL) {
    printf("\nNo se pudo abrir el archivo: %s\n", argv[1]);
  } else {
    yyparse();
    while (feof(yyin)== 0){
      //yyparse();
    }
    fclose(yyin);
  }

  return 0;
}








