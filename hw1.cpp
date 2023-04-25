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
void printErrorHexSeq();
int getDecimalFromHex(std::string hex_number);
void printAfterEscape(char next_ch);

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
            cout << yylineno << " COMMENT"
                 << " //" << endl;
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
            printErrorHexSeq();
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
 * Error <char>\n
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
    if (index_of_last_escape == str.size() - 1)
    {
        printErrorString();
    }

    // if '\' has just 1 character after it, print it
    else if (index_of_last_escape == size - 2)
    {
        cout << str.at(size - 1) << endl;
    }
}

/*
 * print the error of an invalid hex escape sequence
 */
void printErrorHexSeq()
{
    string str(yytext); // make the text of the line string
    int index_of_last_escape = str.find_last_of("\\");
    cout << "Error undefined escape sequence "; // the begining of the message
    cout << "x";
    if (str[index_of_last_escape + 2] != '"')
    {
        cout << str[index_of_last_escape + 2];
        if (str[index_of_last_escape + 3] != '"')
        {
            cout << str[index_of_last_escape + 3];
        }
    }
    cout << endl;
}

void printString()
{
    std::string str(yytext);
    cout << yylineno << " STRING ";
    for (int i = 0; i < str.size(); i++)
    {
        char current = str[i];
        char next_ch = str[i + 1];
        if (current == '"')
            continue;
        // deal with special cases of '\<something>'
        if (current == '\\')
        {
            if (next_ch == '0')
            { // special null character check
                break;
            }
            if (next_ch == 'x')
            {
                int x = getDecimalFromHex(str.substr(i + 2, 2));
                // check for the NULL case:
                if (!x)
                    break;
                cout << char(x);
                i += 3;
            }
            else
            {
                printAfterEscape(next_ch);
                i++;
            }
        }
        else
        {
            cout << current;
        }
    }
    cout << endl;
}

int getDecimalFromHex(std::string hex_number)
{
    std::stringstream ss;
    ss << std::hex << hex_number;
    int x;
    ss >> x;
    return x;
}

void printAfterEscape(char next_ch)
{
    if (next_ch == 'n')
    {
        cout << '\n';
    }
    else if (next_ch == 'r')
    {
        cout << '\r';
    }
    else if (next_ch == 't')
    {
        cout << '\t';
    }
    else if (next_ch == '\"')
    {
        cout << '\"';
    }
    else
    {
        cout << '\\';
    }
}
