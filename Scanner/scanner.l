%{
#include <stdio.h>
#include <string.h>

int line_number = 1;
FILE *fout;
%}

%%
"\n"                            { line_number++; }
[ \t\r]+                        { /* Ignore whitespace */ }

\[:[^\]]*:\]      { printf("MultiLine: %s\n",yytext); } 
:[^=<>!~].*$                          {printf("Comment: %s\n",yytext);}

(state|scale|tag|content|lock|detect|toggle|render|fetch|promise|deceit|navigate|observe|dispatch|route|path|redirect|send|rerender|unmount|root|true|false) { fprintf(fout,"Line %d: KEYWORD - %s\n", line_number, yytext); }

@[_a-zA-Z][a-zA-Z0-9]*            {fprintf(fout,"Line %d: Identifier %s\n",line_number,yytext);}
@[0-9][a-zA-Z0-9_]*             { fprintf(fout, "Line %d: Invalid Identifier - %s\n", line_number, yytext); }
[a-zA-Z_][a-zA-Z0-9_]*             { fprintf(fout, "Line %d: Invalid Identifier - %s\n", line_number, yytext); }

[0-9]+                 { fprintf(fout,"Line %d: INTEGER - %s\n", line_number, yytext); }
[0-9]*\.[0-9]+                  { fprintf(fout,"Line %d: FLOAT - %s\n", line_number, yytext); }
[0-9]*\.[0-9]*\.                { fprintf(fout, "Line %d: Invalid Number - %s\n", line_number, yytext); }
[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?     { fprintf(fout, "Line %d: Exponential Number - %s\n", line_number, yytext); }

\"[^\"\n]*\n                    { fprintf(fout, "Line %d: Unterminated String - %s\n", line_number, yytext); }
\"([^\"\n]*)\"                  { fprintf(fout,"Line %d: STRING - %s\n", line_number, yytext); }

\'[a-zA-Z0-9`!@#$%^&*()_+=;'.]\'                 { fprintf(fout,"Line %d: CHAR - %s\n", line_number, yytext); }
\'.\'{2,}                       { fprintf(fout, "Line %d: Invalid Char - %s\n", line_number, yytext); }
\'.*\'                       { fprintf(fout, "Line %d: Invalid Char(too Long) - %s\n", line_number, yytext); }

(:=|~=|=|\+|-|\\|\*|\*\*|\\\\|%|~|and|or|<|>|<=|>=|<<|>>)           { fprintf(fout,"Line %d: OPERATOR - %s\n", line_number, yytext); }
(\+\+|--|===|!=)                { fprintf(fout, "Line %d: Invalid Operator - %s\n", line_number, yytext); }

(<\/|\\>|\(|\))			{ fprintf(fout,"Line %d: Punctuation - %s\n",line_number,yytext); }

\$ 				{ fprintf(fout,"Line %d: End of Line - %s\n",line_number,yytext); }

.                               { fprintf(fout,"Line %d: ERROR - %s\n", line_number, yytext); }
%%

int yywrap(void) { return 1; }
int main() {
    fout = fopen("output.txt","w");
    if(!fout){
    	printf("Error: Unable to open output.txt for writing.\n");
        return 1;
    }
    yylex();
    
    fclose(fout);
    printf("All tokens written to output.txt successfully!\n");
    return 0;
}

