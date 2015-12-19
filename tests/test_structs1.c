#include <stdio.h>
#include <string.h>
#include "lexer/Lexer.h"

int main(void)
{
    char test_string[] = 
        "struct bobby_hill {\n"
        "\tint HEY;\n"
        "}\n";
        
    struct hsp_lexer *lexer = hsp_init_lexer(test_string, strlen(test_string));
    struct HSPToken token = hsp_lex(lexer);
    
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
    
    hsp_destroy_lexer(lexer);
    
    return 0;
}