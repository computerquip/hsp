struct hsp_lexer;

/* While we don't use ASCII characters as tokens, 
 * I don't see why we should use 0-255 regardless... just to be safe. */
enum HSPTokens {
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
    
    /* Operators */
    TK_LBracket,
    TK_RBracket,
    TK_LCurly,
    TK_RCurly,
    TK_LParen,
    TK_RParen,
    
    /* End of Input */
    TK_EndOfFile,
};

#ifdef __cplusplus
extern "C" {
#endif
    
struct hsp_lexer *hsp_init_lexer(char *data, size_t length);
void hsp_destroy_lexer(struct hsp_lexer *lexer);
int hsp_lex(struct hsp_lexer *lexer);

#ifdef __cplusplus
}
#endif