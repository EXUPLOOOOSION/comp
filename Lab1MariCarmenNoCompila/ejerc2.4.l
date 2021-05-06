%{
int id_cont;
int real_cont;
%}

%%
\("*"[^\n"*"]*["*"]+([^\n\)][^\n"*"]*["*"]+)*\)     	;
"//".* 						;
[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee] 			;
[Bb][Ee][Gg][Ii][Nn]                 			;
[Ee][Nn][Dd]                         			;
[0-9]+ 						;
[a-zA-Z](_?[a-zA-Z0-9])*				{++id_cont;};
[0-9]+\.[0-9]+([Ee][+-]?[0-9]+)? 			{++real_cont;};
\n							;
.							;
%%
main() {
  yylex() ;
  printf("%d ids, %d reales\n",id_cont,real_cont);
}
