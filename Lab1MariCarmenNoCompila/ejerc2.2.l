
%%
[a-zA-Z](_?[a-zA-Z0-9])*            	 { printf("%s:\tSI\n",yytext); }
					 
.+   	                       		 { printf("%s:\tNO\n",yytext); }
%%

