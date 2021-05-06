%{
   #include <stdio.h>
   #include <iostream>
   #include <vector>
   #include <string>
   using namespace std; 

   bool faulty = false;

   extern int yylex();
   extern int yylineno;
   extern char *yytext;
   void yyerror (const char *msg) {
     printf("line %d: %s  '%s'\n", yylineno, msg, yytext) ;
     faulty = true;
   }
   #include "Codigo.hpp"
   #include "Exp.hpp"
   
   Codigo codigo;
   expresionstruct makecomparison(std::string &s1, std::string &s2, std::string &s3) ;
   expresionstruct makearithmetic(std::string &s1, std::string &s2, std::string &s3) ;
   vector<int> *unir(vector<int> vec1, vector<int> vec2);
%}

/* 
   qué atributos tienen los tokens 
*/



%union {
    string *str ; 
    vector<string> *list ;
    
    int number ;
    vector<int> *numlist;
    expresionstruct *expr;
    sentencestruct *sent;
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
%type <sent> lista_sentencias
%type <sent> sentencia_pero_me_cago_en_bison
%type <expr> expr
%type <str> declaraciones
%type <list> lista_de_ident
%type <list> resto_lista_id
%type <str> tipo
%type <str> declaracion_proc
%type <str> procedures
%type <str> argumentos
%type <str> lista_de_param
%type <str> resto_lis_de_param
%type <str> clase_par
%type <str> variable
%type <number> M
%type <sent> sentencia
%type <str> operador_artimetico;

%start programa
%left TG TE TL TLE TGE
%left TSUM TRES
%left TMUL TDIV


%%

programa : RPROGRAM TIDENTIFIER declaraciones procedures TLEFTB lista_sentencias TRIGHTB {codigo.anadirInstruccion("halt;");if (!faulty)codigo.escribir();}
        
lista_de_ident : TIDENTIFIER resto_lista_id {$$ = $2; $$->push_back(*$1);}

resto_lista_id : TCOMMA TIDENTIFIER resto_lista_id {$$ = $3; $$->push_back(*$2);} 
            | /*vacio*/ {$$= new vector <string>;}

tipo : TDECINT {$$ = new string; *$$="ent";}
      |TDECDOUBLE {$$ = new string; *$$="real";}

procedures : declaracion_proc procedures
            |/*vasio*/ {$$=0;}

declaracion_proc : RPROCEDURE TIDENTIFIER {codigo.anadirInstruccion("proc "+*$2+";");} argumentos
                  declaraciones
                  procedures
                  TLEFTB
                  lista_sentencias
                  TRIGHTB {codigo.anadirInstruccion("endproc;");}

argumentos : TLEFTP lista_de_param TRIGHTP
            |/*vasio*/ {$$=0;}

lista_de_param : tipo clase_par lista_de_ident {codigo.anadirParametros(*$3, *$2, *$1);} resto_lis_de_param 
               |/*vasio*/ {$$=0;}

clase_par : TPAROUT {$$ = new string; *$$ = "out";}| TLE {$$ = new string; *$$ = "in";}| TPARINOUT{$$ = new string; *$$ = "in out";};

resto_lis_de_param : TSEMIC tipo clase_par lista_de_ident {codigo.anadirParametros(*$4, *$3, *$2);}  resto_lis_de_param 
                     |/*vasio*/ {$$=0;}

declaraciones : tipo lista_de_ident TSEMIC {codigo.anadirDeclaraciones(*$2, *$1);} declaraciones
               | error lista_de_ident TSEMIC {yyerror("falta tipo en declaraciones");} declaraciones {$$ = 0;}
               | tipo error TSEMIC {yyerror("error en los identificadores o falta de ellos");} declaraciones
               | tipo lista_de_ident error {yyerror("expected ';' before");} declaraciones
               |/*vasio*/ {$$=0;}

lista_sentencias : sentencia lista_sentencias {
                        
                        $$ = new sentencestruct;
                        $$->skips = *unir($1->skips, $2->skips);
                        $$->exits = *unir($1->exits, $2->exits);
                        // delete $1; delete $2;
                       }
                  | error TSEMIC lista_sentencias {yyerror("lmao");}
                  |/*vasio*/ {$$= new sentencestruct;}

            ;
sentencia : sentencia_pero_me_cago_en_bison TSEMIC {$$ = $1;}
            | sentencia_pero_me_cago_en_bison error{yyerror("expected ';' before"); $$ = new sentencestruct;}
            | error TSEMIC {yyerror("error sintáctico antes de"); $$ = new sentencestruct;}
            ;
sentencia_pero_me_cago_en_bison :  TIDENTIFIER TASSIG expr {$$=new sentencestruct; codigo.anadirInstruccion(*$1+":="+$3->str +";");}
            |TIDENTIFIER TASSIG error {yyerror("falta parte derecha de asignacion");$$ = new sentencestruct;}
            | RIF expr TLEFTB M lista_sentencias TRIGHTB {$$=new sentencestruct;
                                                                  $$->exits = $5->exits;
                                                                  $$->skips = $5->skips;
                                                                  codigo.completarInstrucciones($2->trues,$4);
                                                                  codigo.completarInstrucciones($2->falses,codigo.obtenRef());}
            | RWHILEFOREVER TLEFTB lista_sentencias TRIGHTB {$$ = new sentencestruct; 
                                                                     $$->skips = $3->skips;
                                                                     codigo.completarInstrucciones($3->exits, codigo.obtenRef());
                                                                     // delete $3;
                                                                     }
            | RDO TLEFTB M lista_sentencias TRIGHTB RUNTIL M expr RELSE TLEFTB M lista_sentencias TRIGHTB 
            {
               codigo.completarInstrucciones($4->exits, codigo.obtenRef());
               codigo.completarInstrucciones($4->skips, $7);
               codigo.completarInstrucciones($12->exits, codigo.obtenRef());
               codigo.completarInstrucciones($8->trues, $11);
               codigo.completarInstrucciones($8->falses, $3);
               $$ = new sentencestruct;
               $$->skips = $12->skips;
               // delete $3;
               // delete $10;
               // delete $7;
            }
            | RSKIPIF expr {$$ = new sentencestruct;
                                    $$->skips = $2->trues;
                                    codigo.completarInstrucciones($2->falses, codigo.obtenRef());
                                    // delete $2;
                                    }
            | REXIT 
            {
               $$ = new sentencestruct;
               $$->exits.push_back(codigo.obtenRef());
               codigo.anadirInstruccion("goto");
            }
            | RREAD TLEFTP variable TRIGHTP  
            {
               $$ = new sentencestruct;
               codigo.anadirInstruccion("read "+*$3+";");
            }
            | RPRINTF TLEFTP expr TRIGHTP 
            {
               $$ = new sentencestruct;
               codigo.anadirInstruccion("write "+$3->str+";");
               codigo.anadirInstruccion("writeln;");
               // delete $3;
            }
variable : TIDENTIFIER

operador_artimetico : TSUM {$$ = $1;}
                     | TRES {$$ = $1;}
                     | TMUL {$$ = $1;}
                     | TDIV {$$ = $1;}

expr : expr TE expr {$$ = new expresionstruct;
                     *$$ = makecomparison($1->str, *$2, $3->str);
                     // delete $1; delete $3;
                     }
      | expr TG expr {$$ = new expresionstruct;
                     *$$ = makecomparison($1->str, *$2, $3->str);
                     // delete $1; delete $3;
                     }
      | expr TL expr {$$ = new expresionstruct;
                     *$$ = makecomparison($1->str, *$2, $3->str);
                     // delete $1; delete $3;
                     }
      | expr TGE expr {$$ = new expresionstruct;
                     *$$ = makecomparison($1->str, *$2, $3->str);
                     // delete $1; delete $3;
                     }
      | expr TLE expr {$$ = new expresionstruct;
                     *$$ = makecomparison($1->str, *$2, $3->str);
                     // delete $1; delete $3;
                     }
      | expr TNE expr {$$ = new expresionstruct;
                     *$$ = makecomparison($1->str, *$2, $3->str);
                     // delete $1; delete $3;
                     }
      | expr operador_artimetico expr {$$ = new expresionstruct;
                     /*
                     if (*$2 == "/"){
                                       
                                    }
                     */
                     *$$ = makearithmetic($1->str, *$2, $3->str);
                     // delete $1; delete $3;
                     
                     }
      | expr operador_artimetico error {yyerror("expresión sin operando derecho u operando erróneo");}
      | error operador_artimetico expr {yyerror("expresión sin operando izquierdo u operando erróneo");}
      | variable {$$ = new expresionstruct; $$->str = *$1;}
      | TINTEGER {$$ = new expresionstruct; $$->str = *$1;}
      | TDOUBLE {$$ = new expresionstruct; $$->str = *$1;}
      | TLEFTP expr TRIGHTP {$$ = new expresionstruct; $$->str = $2->str;$$->trues = $2->trues; $$->falses = $2->falses;}
      ;
   M : {$$ = codigo.obtenRef();};

%%
expresionstruct makecomparison(std::string &s1, std::string &s2, std::string &s3) {
  expresionstruct tmp ; 
  tmp.trues.push_back(codigo.obtenRef()) ;
  tmp.falses.push_back(codigo.obtenRef()+1) ;
  codigo.anadirInstruccion("if " + s1 + s2 + s3 + " goto") ;
  codigo.anadirInstruccion("goto") ;
  return tmp ;
}


expresionstruct makearithmetic(std::string &s1, std::string &s2, std::string &s3) {
  expresionstruct tmp ; 
  tmp.str = codigo.nuevoId() ;
  codigo.anadirInstruccion(tmp.str + ":=" + s1 + s2 + s3 + ";") ;     
  return tmp ;
}

//Falta la función unir
vector <int> *unir(vector <int> vec1, vector <int> vec2)
{
        vector <int> *res = new vector <int>;
        *res = vec1;
        res->insert(res->end(),vec2.begin(),vec2.end());
        return res;

}

