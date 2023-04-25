%{
/* Declaration Section */
#include <stdio.h>
#include "tokens.hpp"
%}

%option yylineno
%option noyywrap
%x STR
digit            ([0-9])
letter           ([a-zA-Z])
letterdigit      ([a-zA-Z0-9])
string           ([ !#-\[\]-~	])
escape           ([\\ntr\"0])
hex              (x[0-7][0-9A-Fa-f])
whitespace       ([\t\n\r ])

%%
void                                                                                return VOID;
int                                                                                 return INT;
byte                                                                                return BYTE;
b                                                                                   return B;
bool                                                                                return BOOL;
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
[<>=!]=|>|<                                                                         return RELOP;
[-+*/]                                                                              return BINOP;
\/\/[^\n\r]*                                                                        return COMMENT;
{letter}{letterdigit}*                                                              return ID;
([1-9]+{digit}*)|0                                                                  return NUM;
([0]+{digit}*)|0												return ERROR_CHAR;
\"({string}|\\{escape}|\\{hex})*\"                                                    return STRING;
\"({string}|\\{escape}|\\{hex})*                                                    return ERROR_UNCLOSED_STRING;
\"({string}|\\{escape}|\\{hex})*\\[^\\ntr\"0]                                         return ERROR_ESCAPE_SEQ;
\"({string}|\\{escape}|\\{hex})*\\x([^0-7][0-9A-Fa-f]|[0-7][^0-9A-Fa-f]|[^0-7][^0-9A-Fa-f]|[^0-9A-Fa-f]) return ERROR_ESCAPE_SEQ;
{whitespace}                                                                        ;
.                                                                                   return ERROR_CHAR;
