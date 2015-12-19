#pragma once

#include <stddef.h>
#include <stdint.h>

struct hsp_lexer;

/* Map of the numerous tokens to strings. */
static const char *HSPTokenMap[] = {
    "TK_Invalid",
    "TK_IntegerConstant",
    "TK_FloatConstant",
    "TK_StringLiteral",
    "TK_Identifier",
    "TK_WhiteSpace",
    "TK_Comment",
    
    "TK_Struct",
    "TK_Int",
    
    "TK_LBracket",
    "TK_RBracket",
    "TK_LCurly",
    "TK_RCurly",
    "TK_LParen",
    "TK_RParen",
    "TK_SemiColon",
    
    "TK_EndOfFile"
};

#define GET_TOKEN_STRING(____token) (HSPTokenMap[____token - 256])

/* While we don't use ASCII characters as tokens, 
 * I don't see why we should use 0-255 regardless... just to be safe. */
enum HSPTokenType {
    TK_Invalid = 256,
    
    /* Literals */
    TK_IntegerConstant,
    TK_FloatConstant,
    TK_StringLiteral,
    TK_Identifier,
    TK_WhiteSpace,
    TK_Comment,
    
    /* Keywords */
    TK_Struct,
    TK_Int,
    
    /* Operators */
    TK_LBracket,
    TK_RBracket,
    TK_LCurly,
    TK_RCurly,
    TK_LParen,
    TK_RParen,
    TK_SemiColon,
    
    /* End of Input */
    TK_EndOfFile,
};

struct HSPLexeme {
    uint16_t size;
    const char* data;
};

union HSPTokenData {        
        /* Constant or Literal Values */
        uint32_t constant;
};

struct HSPToken {
    int id;
    struct HSPLexeme lexeme;
    union HSPTokenData data;
};

#ifdef __cplusplus
extern "C" {
#endif
    
struct hsp_lexer *hsp_init_lexer(char *data, size_t length);
void hsp_destroy_lexer(struct hsp_lexer *lexer);
struct HSPToken hsp_lex(struct hsp_lexer *lexer);
void hsp_reset_lexer(struct hsp_lexer *lexer);

#ifdef __cplusplus
}
#endif