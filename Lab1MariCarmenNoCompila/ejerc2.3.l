
%%
\("*"[^\n"*"]*["*"]+([^\n\)][^\n"*"]*["*"]+)*\)                    	 	{ printf("%s:\tSI\n",yytext); }
					 
.+   	                       		 { printf("%s:\tNO\n",yytext); }
%%

