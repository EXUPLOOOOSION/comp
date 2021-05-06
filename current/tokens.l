%option yylineno 

%{
 #include <string>
 #include <iostream>
 #include <vector>
 using namespace std ;
 #include "Exp.hpp"
 #include "parser.hpp"
 using namespace std;

 #define TOKEN(t) yylval.str = new string(yytext, yyleng) ; return t 

 extern "C" int yywrap() { return(1) ; }  

%}

%%
program                 TOKEN(RPROGRAM) ;
proc                    TOKEN(RPROCEDURE);
if                      TOKEN(RIF);
while" "forever         TOKEN(RWHILEFOREVER);
do                      TOKEN(RDO);
until                   TOKEN(RUNTIL);
else                    TOKEN(RELSE);
skip" "if                 TOKEN(RSKIPIF);
exit                    TOKEN(REXIT);
read                    TOKEN(RREAD);
println                 TOKEN(RPRINTF);


\{                      TOKEN(TLEFTB);

\}                      TOKEN(TRIGHTB);

\(                      TOKEN(TLEFTP);

\)                      TOKEN(TRIGHTP);

"="">"                  TOKEN(TPAROUT);
"<""="">"               TOKEN(TPARINOUT);

"-"                     TOKEN(TRES);
"+"                     TOKEN(TSUM);
"/"                     TOKEN(TDIV);
"*"                     TOKEN(TMUL);

"<""="                  TOKEN(TLE);
">""="                  TOKEN(TGE);
"=""="                  TOKEN(TE);
"<"                     TOKEN(TL);
">"                     TOKEN(TG);
"/""="                  TOKEN(TNE);

"="                     TOKEN(TASSIG);



";"                     TOKEN(TSEMIC);

","                     TOKEN(TCOMMA);

int                     TOKEN(TDECINT);
float                   TOKEN(TDECDOUBLE);

"#".+\n                ;

[ \t\n]                 ;

[a-zA-Z](_?[a-zA-Z0-9])*            TOKEN(TIDENTIFIER) ; 
[0-9]+\.[0-9]+([Ee][+-]?[0-9]+)?    TOKEN(TDOUBLE);
[0-9]+                              TOKEN(TINTEGER); 

\["*"[^"*"]*["*"]+([^\*\]][^"*"]*["*"]+)*\]  ;


.                       { cout << "Token desconocido: " << yytext << endl; yyterminate();}
%%


