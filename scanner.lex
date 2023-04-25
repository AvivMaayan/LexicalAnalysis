%{


/* Declaration Section */
#include <stdio.h>
#include "tokens.hpp"


%}

%option yylineno
%option noyywrap
zero                 (0)
non_zero             ([1-9])
digit                ([0-9])
letter               ([a-zA-Z])
letterdigit          ({letter}|{digit})
cr                   (\r)
lf                   (\n)
tab                  (\t)
whitespace           ([\r\n\t ])
printable            ([ !#-\[\]-~	])
escape               (\\[\\\"nrt0])
hex_first            [0-7]
hex_second           [0-9A-Fa-f]
not_hex_first        [^0-7]
not_hex_second       [^0-9A-Fa-f]
hex                  (\\x{hex_first}{hex_second})
not_hex              (\\x({not_hex_first}{hex_second}|{hex_first}{not_hex_second}|{not_hex_first}{not_hex_second}|{not_hex_second}))

%%


void                                           return VOID;
int                                            return INT;
byte                                           return BYTE;
b                                              return B;
bool                                           return BOOL;
override                                       return OVERRIDE;
and                                            return AND;
or                                             return OR;
not                                            return NOT;
true                                           return TRUE;
false                                          return FALSE;
return                                         return RETURN;
if                                             return IF;
else                                           return ELSE;
while                                          return WHILE;
break                                          return BREAK;
continue                                       return CONTINUE;
;                                              return SC;
,                                              return COMMA;
\(                                             return LPAREN;
\)                                             return RPAREN;
\{                                             return LBRACE;
\}                                             return RBRACE;
=                                              return ASSIGN;
[<>=!]=|<|>                                    return RELOP;
[*/+-]                                         return BINOP;
\/\/[^\n\r]*                                   return COMMENT;
{letter}{letterdigit}*                         return ID;
{zero}|({non_zero}+{digit}*)                   return NUM;
\"({printable}|{escape}|{hex})*\"              return STRING;
\"({printable}|{escape}|{hex})*                return ERROR_UNCLOSED_STRING;
\"({printable}|{escape}|{hex})*\\[^\\ntr\"0]   return ERROR_ESCAPE_SEQ;
\"({printable}|{escape}|{hex})*{not_hex}       return ERROR_HEX_SEQ;
{whitespace}                                   ;
.                                              return ERROR_CHAR;

%%
