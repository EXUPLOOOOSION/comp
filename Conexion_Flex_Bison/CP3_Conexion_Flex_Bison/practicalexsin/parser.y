%{
   #include <stdio.h>
   #include <iostream>
   #include <vector>
   #include <string>
   using namespace std; 

   extern int yylex();
   extern int yylineno;
   extern char *yytext;
   void yyerror (const char *msg) {
     printf("line %d: %s at '%s'\n", yylineno, msg, yytext) ;
   }

%}

/* 
   qué atributos tienen los tokens 
*/
%union {
    string *str ; 
}

/* 
   declaración de tokens. Esto debe coincidir con tokens.l 
*/
%token <str> TIDENTIFIER TINTEGER TDOUBLE
%token <str> TDECDOUBLE TDECINT
%token <str> TMUL TSUM TRES TDIV
%token <str> TLE TE TGE TNE TG TL
%token <str> TPAROUT TPARINOUT
%token <str> TSEMIC TASSIG TCOMMA TLEFTB TRIGHTB TLEFTP TRIGHTP
%token <str> RPROGRAM RPROCEDURE RPRINTF RWHILEFOREVER RSKIPIF RUNTIL RELSE REXIT RREAD RDO RIF

%type <str> programa
%type <str> lista_sentencias
%type <str> sentencia
%type <str> expr
%type <str> declaraciones
%type <str> lista_de_ident
%type <str> resto_lista_id
%type <str> tipo
%type <str> declaracion_proc
%type <str> procedures
%type <str> argumentos
%type <str> lista_de_param
%type <str> resto_lis_de_param
%type <str> clase_par
%type <str> variable

%start programa

%left TSUM TRES
%left TMUL TDIV

%%

programa : RPROGRAM TIDENTIFIER declaraciones procedures TLEFTB lista_sentencias TRIGHTB
        
lista_de_ident : TIDENTIFIER resto_lista_id

resto_lista_id : TCOMMA TIDENTIFIER resto_lista_id
            | /*vacio*/ {$$=0;}

tipo : TDECINT
      |TDECDOUBLE

procedures : declaracion_proc procedures
            |/*vasio*/ {$$=0;}

declaracion_proc : RPROCEDURE TIDENTIFIER argumentos
                  declaraciones
                  procedures
                  TLEFTB
                  lista_sentencias
                  TRIGHTB

argumentos : TLEFTP lista_de_param TRIGHTP
            |/*vasio*/ {$$=0;}

lista_de_param : tipo clase_par lista_de_ident resto_lis_de_param
               |/*vasio*/ {$$=0;}

clase_par : TPAROUT | TLE | TPARINOUT;

resto_lis_de_param : TSEMIC tipo clase_par lista_de_ident resto_lis_de_param
                     |/*vasio*/ {$$=0;}

declaraciones : tipo lista_de_ident TSEMIC declaraciones
               |/*vasio*/ {$$=0;}

lista_sentencias : sentencia lista_sentencias
                  |/*vasio*/ {$$=0;}

sentencia :  TIDENTIFIER TASSIG expr TSEMIC
            | RIF expr TLEFTB lista_sentencias TRIGHTB TSEMIC
            | RWHILEFOREVER TLEFTB lista_sentencias TRIGHTB TSEMIC
            | RDO TLEFTB lista_sentencias TRIGHTB RUNTIL expr RELSE TLEFTB lista_sentencias TRIGHTB TSEMIC
            | RSKIPIF expr TSEMIC
            | REXIT TSEMIC
            | RREAD TLEFTP variable TRIGHTP TSEMIC
            | RPRINTF TLEFTP expr TRIGHTP TSEMIC
variable : TIDENTIFIER

expr : expr TE expr
      | expr TG expr
      | expr TL expr
      | expr TGE expr
      | expr TLE expr
      | expr TNE expr
      | expr TSUM expr
      | expr TRES expr
      | expr TMUL expr
      | expr TDIV expr
      | variable
      | TINTEGER
      | TDOUBLE
      | TLEFTP expr TRIGHTP
      ;


