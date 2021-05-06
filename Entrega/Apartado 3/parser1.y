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
%type <str> EP
%type <str> T
%type <str> TP
%type <str> F

%start E

%%

E : T EP
   {cout << "<E>"<<"(" << *$1 << *$2 << "</E>" << endl;$$ = new string; *$$ = "(" + *$1 + *$2;}
EP : TPLUS T EP
    { cout << "<E'PLUS>" <<"+" <<*$2 << *$3 << "</E'PLUS>" << endl;$$ = new string; *$$ = "+" + *$2 + *$3 + ")"; }
   | TMINUS T EP
   { cout << "<E'MINUS>" <<"-" <<*$2 << *$3 << "</E'MINUS>" << endl;$$ = new string; *$$ = "-" + *$2 + *$3 + ")"; }
   | /*void*/
   {cout << "<E'VACIO>" << endl;$$ = new string;}
   
T : F TP
   {cout << "<T>"<<"(" << *$1 << *$2 << "</T>"<<endl;$$ = new string; *$$ = "(" + *$1 + *$2;}
TP : TMUL F TP
   { cout << "<T'MUL>"<< "*" <<*$2 << *$3 << "</T'MUL>" << endl;$$ = new string; *$$ = "*" + *$2 + *$3 + ")"; }
   | TDIV F TP
   { cout << "<T'DIV>" << "/" <<*$2 << *$3 << "</T'DIV>" << endl;$$ = new string; *$$ = "/" + *$2 + *$3 + ")"; }
   |/*void*/
   {cout << "<T'VACIO>" << endl;$$ = new string;}
F  : TIDENTIFIER
  { $$ = $1; cout<<"<F> Id : "<< yytext << "</F>"<<endl;}
  | TINTEGER
  { $$ = $1; cout<<"<F> Ent : "<< yytext << "</F>"<<endl;}
  | TDOUBLE
  { $$ = $1; cout<<"<F> Real : "<< yytext << "</F>"<<endl;}
  ;


