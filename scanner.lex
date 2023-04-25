%{


/* Declaration Section */
#include <stdio.h>
#include "tokens.hpp"


%}

%option yylineno
%option noyywrap
zero             (0)
non_zero         ([1-9])
digit            ([0-9])
letter           ([a-zA-Z])
letterdigit      ([a-zA-Z0-9])
cr               (\r)
lf               (\n)
tab              (\t)
whitespace       ([\r\n\t ])
printable        ([ !#-\[\]-~	])
escape           (\\[\\\"nrt0])
hex              (\\x[0-7][0-9A-Fa-f])

%%


void                                                                                return VOID;
int                                                                                 return INT;
byte                                                                                return BYTE;
b                                                                                   return B;
bool                                                                                return BOOL;
override                                                                            return OVERRIDE;
override                                                                            return OVERRIDE;
and                                                                                 return AND;
or                                                                                  return OR;
not                                                                                 return NOT;
true                                                                                return TRUE;
false                                                                               return FALSE;
return                                                                              return RETURN;
if                                                                                  return IF;
else                                                                                return ELSE;
while                                                                               return WHILE;
break                                                                               return BREAK;
continue                                                                            return CONTINUE;
;                                                                                   return SC;
,                                                                                   return COMMA;
\(                                                                                  return LPAREN;
\)                                                                                  return RPAREN;
\{                                                                                  return LBRACE;
\}                                                                                  return RBRACE;
=                                                                                   return ASSIGN;
[<>=!]=|<|>                                                                         return RELOP;
[*/+-]                                                                              return BINOP;
\/\/[^\n\r]*                                                                    return COMMENT;
{letter}{letterdigit}*                                                              return ID;
{zero}|({non_zero}+{digit}*)                                                        return NUM;
([0]+{digit}*)|0                                                                    return ERROR_CHAR;
\"({printable}|{escape}|{hex})*\"                                                   return STRING;
\"({printable}|{escape}|{hex})*                                                     return ERROR_UNCLOSED_STRING;
\"({printable}|{escape}|{hex})*\\[^\\ntr\"0]                                        return ERROR_ESCAPE_SEQ;
\"({printable}|{escape}|{hex})*\\x([^0-7][0-9A-Fa-f]|[0-7][^0-9A-Fa-f]|[^0-7][^0-9A-Fa-f]|[^0-9A-Fa-f]) return ERROR_ESCAPE_SEQ;
{whitespace}                                                                        ;
.                                                                                   return ERROR_CHAR;

%%
