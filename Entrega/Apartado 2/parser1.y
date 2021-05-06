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
%token <str> TPLUS TMINUS TMUL TDIV

%type <str> E
%type <str> T
%type <str> F

%start E

%%

E : E TPLUS T
  { cout << "<EPLUS>" << *$1 << "+" << *$3 << "<\\EPLUS>" << endl; $$ = new string; *$$ = "(" + *$1 + "+" + *$3 + ")"; }
  | E TMINUS T
  { cout << "<EMINUS>" << *$1 << "-" << *$3 << "<\\EMINUS>" << endl;$$ = new string; *$$ = "(" + *$1 + "-" + *$3 + ")"; }
  | T
  { cout << "<E>T<\\E>"<<endl;$$ = new string; *$$ = *$1;}
  
T : T TMUL F
  { cout << "<TMUL>" << *$1 << "*" << *$3 << "<\\TMUL>" << endl; $$ = new string; *$$ = "(" + *$1 + "*" + *$3 + ")"; }
  | T TDIV F
  { cout << "<TDIV>" << *$1 << "/" << *$3 << "<\\TDIV>" << endl; $$ = new string; *$$ = "(" + *$1 + "/" + *$3 + ")"; }
  | F
  { cout << "<T>F<\\T>"<<endl;$$ = new string;*$$ = *$1;}
  
F : TIDENTIFIER
  { $$ = $1; cout<<"<F> Id : "<< yytext << "<\\F>"<<endl;}
  | TINTEGER
  { $$ = $1; cout<<"<F> Ent : "<< yytext << "<\\F>"<<endl;}
  | TDOUBLE
  { $$ = $1; cout<<"<F> Real : "<< yytext << "<\\F>"<<endl;}
  ;


