#include "tokens.hpp"
#include <sstream>
#include <iostream>

using std::cout;
using std::endl;
using std::string;

void printToken(string name);
void printErrorChar();
void printErrorString();
void printErrorEscapeSeq();
void printString();

int main()
{
    int token;
    while ((token = yylex()))
    {
        switch (token)
        {
        case VOID:
            printToken("VOID");
            break;
        case INT:
            printToken("INT");
            break;
        case BYTE:
            printToken("BYTE");
            break;
        case B:
            printToken("B");
            break;
        case BOOL:
            printToken("BOOL");
            break;
        case AND:
            printToken("AND");
            break;
        case OR:
            printToken("OR");
            break;
        case NOT:
            printToken("NOT");
            break;
        case TRUE:
            printToken("TRUE");
            break;
        case FALSE:
            printToken("FALSE");
            break;
        case RETURN:
            printToken("RETURN");
            break;
        case IF:
            printToken("IF");
            break;
        case ELSE:
            printToken("ELSE");
            break;
        case WHILE:
            printToken("WHILE");
            break;
        case BREAK:
            printToken("BREAK");
            break;
        case CONTINUE:
            printToken("CONTINUE");
            break;
        case SC:
            printToken("SC");
            break;
        case COMMA:
            printToken("COMMA");
            break;
        case LPAREN:
            printToken("LPAREN");
            break;
        case RPAREN:
            printToken("RPAREN");
            break;
        case LBRACE:
            printToken("LBRACE");
            break;
        case RBRACE:
            printToken("RBRACE");
            break;
        case ASSIGN:
            printToken("ASSIGN");
            break;
        case RELOP:
            printToken("RELOP");
            break;
        case BINOP:
            printToken("BINOP");
            break;
        case COMMENT:
            // COMMENT has a special way of formatting
            cout << yylineno << " COMMENT" << " //" << endl;
            break;
        case ID:
            printToken("ID");
            break;
        case NUM:
            printToken("NUM");
            break;
        case STRING:
            printString();
            break;
        case OVERRIDE:
            printToken("OVERRIDE");
            break;
        case ERROR_CHAR:
            printErrorChar();
            exit(0);
        case ERROR_UNCLOSED_STRING:
            printErrorString();
            exit(0);
        case ERROR_ESCAPE_SEQ:
            printErrorEscapeSeq();
            exit(0);
        case ERROR_HEX_SEQ:
            printErrorEscapeSeq();
            exit(0);
        default:
            printErrorChar();
            exit(0);
        }
    }
}

/**
 * print the regular way of a legal token, i.e:
 * <lineNumber> <TOKEN> <value>
 */
void printToken(string token)
{
    cout << yylineno << " " << token << " " << yytext << endl;
}

/**
 * print an error of an illegal char, i.e:
 * Error <char>/n
 */
void printErrorChar()
{
    cout << "Error " << yytext[0] << endl;
}

/**
 * print an error of a '\n' in the middle of the string, i.e:
 * Error unclosed string\n
 */
void printErrorString()
{
    cout << "Error unclosed string" << endl;
}

/**
 * print an error of the invalid escape sequence
 */
void printErrorEscapeSeq()
{
    string str(yytext); // make the text of the line string
    int size = str.size();
    int index_of_last_escape = str.find_last_of('\\');
    cout << "Error undefined escape sequence "; // the begining of the message

    // if '\' is the last character, print a string error instead
    if(index_of_last_escape == str.size() - 1)
    {
        printErrorString();
        return;
    }
    
    // if '\' has just 1 character after it, print all of the escape seq
    if(index_of_last_escape == size - 2)
    {
        cout << str.at(size - 1) << endl;
        return;
    }

    // the error is of invalid HEX value since there are at least 2 characters after the '\'
    cout << "x" << str[size - 2];
    if (str[size - 1] != '"')
        cout << str[size - 1];
    cout << endl;
}

void printString()
{
    std::string str(yytext);
    cout << yylineno << " STRING ";
    for (int i = 0; i < str.size(); i++)
    {
        char ch = str[i];
        char next_ch = str[i + 1];
        if (ch == '"')
            continue;
        else if (ch == '\\' && next_ch == 'x')
        {
            std::stringstream ss;
            ss << std::hex << str.substr(i + 2, 2);
            int x;
            ss >> x;
            cout << char(x);
            i += 3;
        }
        else if (ch == '\\' && next_ch == 'n')
        {
            cout << '\n';
            i++;
        }
        else if (ch == '\\' && next_ch == 'r')
        {
            cout << '\r';
            i++;
        }
        else if (ch == '\\' && next_ch == 't')
        {
            cout << '\t';
            i++;
        }
        else if (ch == '\\' && next_ch == '\"')
        {
            cout << '\"';
            i++;
        }
        else if (ch == '\\')
        {
            cout << '\\';
            i++;
        }
        else
        {
            cout << ch;
        }
    }
    cout << endl;
}