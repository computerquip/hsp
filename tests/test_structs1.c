#include <stdio.h>
#include <string.h>
#include "lexer/Lexer.h"
#include "parser/Parser.h"

int main(void)
{
    char test_string[] = 
        "struct bobby_hill {\n"
        "\tmatrix4x4 asdf234asdf;\n"
        "\tint HEY;\n"
        "}\n";
        
    struct HSPLexer *lexer = hsp_create_lexer(test_string, strlen(test_string));
    struct HSPToken token = hsp_lex(lexer);
    struct HSPParser *parser;
    
    while (token.id != TK_EndOfFile) {
        
        if (token.id == TK_Invalid) {
            printf("Invalid Token!\n");
            break;
        } else {
            printf("Valid Token: %s - %.*s\n", 
                GET_TOKEN_STRING(token.id),
                token.lexeme.size, token.lexeme.data);
        }
        
        token = hsp_lex(lexer);
    }
    
    printf("String succesfully analyzed!\n");
    
    /* Parser Test */
    hsp_reset_lexer(lexer);
    
    parser = hsp_create_parser(lexer);
    if (!hsp_parse(parser))
        printf("Failed to parse string!\n");
    else    
        printf("String succesfully parsed!\n");
    
    hsp_destroy_parser(parser);
    hsp_destroy_lexer(lexer);
    
    return 0;
}