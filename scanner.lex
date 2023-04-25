%{

/* Declaration Section */
#include <stdio.h>
#include "tokens.hpp"

%}

%option yylineno
%option noyywrap
zero             (0)
non_zero         ([1-9])
digit            ([{zero}{non_zero}])
letter           ([a-zA-Z])
letterdigit      ([{letter}{digit}])
cr               (\r)
lf               (\n)
tab              (\t)
whitespace       ([{cr}{lf}{tab}])
printable        (0x20|0x21|[\x23-\x5B]|[\x5D-\x7E]|\t)
escape           (\\[\\\"nrt0])
hex              (\\x[0-7][0-9A-Fa-f])

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
<|>|[<>=!]=                                                                         return RELOP;
[+-*/]                                                                              return BINOP;
\/\/[^{cr}{lf}]*                                                                    return COMMENT;
{letter}{letterdigit}*                                                              return ID;
{zero}|({non_zero}+{digit}*)                                                        return NUM;
([0]+{digit}*)|0												return ERROR_CHAR;
\"({printable}|{escape}|{hex})*\"                                                    return STRING;
\"({string}|{escape}|{hex})*                                                    return ERROR_UNCLOSED_STRING;
\"({string}|{escape}|{hex})*\\[^\\ntr\"0]                                         return ERROR_ESCAPE_SEQ;
\"({string}|{escape}|{hex})*\\x([^0-7][0-9A-Fa-f]|[0-7][^0-9A-Fa-f]|[^0-7][^0-9A-Fa-f]|[^0-9A-Fa-f]) return ERROR_ESCAPE_SEQ;
{whitespace}                                                                        ;
.                                                                                   return ERROR;

%%
