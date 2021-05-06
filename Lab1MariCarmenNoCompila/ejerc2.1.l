
%%
[0-9]+\.[0-9]+([Ee][+-]?[0-9]+)?	 { printf("%s:\tSI\n",yytext); }
					 
.+   	                       		 { printf("%s:\tNO\n",yytext); }
%%

