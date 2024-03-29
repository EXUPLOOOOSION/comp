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

%token <str> TIDENTIFIER
%token <str> RIF RELSE

%type <str> S
%%
S : RIF S RELSE S {$$ = new string; *$$ = "IF {"+*$2+"} ELSE {"+*$4+"}"; cout <<"IF {"<<*$2 << "}ELSE {"<<*$4<<"}"<<endl;}
   | RIF S {$$ = new string; *$$ = "IF{*$2}"; cout <<"IF {"<<*$2<<"}"<<endl;}
   | TIDENTIFIER {$$ = new string; *$$ = "";}
   ;

