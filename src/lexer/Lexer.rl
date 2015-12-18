#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct hsp_lexer {
    /* p - Position within the data block. */
    char *p;
    
    /* pe - Position marking the end of the data block. */
    char *pe;
    
    /* eof - Position marking the end of the data stream. */
    char *eof;
    
    /* data - Original data block. */
    char *data;
    
    /* length - Size of data block. */
    size_t length;
    
    /* cs - Current state of the finite state machine. */
    int cs;
    
    /* te - End of the token string. */
    char *te;
    
    /* ts - Start of the token string. */
    char *ts;
    
    /* act - Marker for previous token. */
    int act;
};

#define send_token(_token) token = _token;

%%{
    machine hsp;
    access lexer->;
    variable p lexer->p;
    variable pe lexer->pe;
    variable eof lexer->eof;
    
    include "ConstantLiterals.rl";
    include "Keywords.rl";
    include "Operators.rl";
    include "Reserved.rl";
    
    main := 
    |*
        float_lit
            { send_token(TK_FloatConstant); fbreak; };
        
        decimal_lit
            { send_token(TK_IntegerConstant); fbreak; };
        octal_lit
            { send_token(TK_IntegerConstant); fbreak; };
        hex_lit 
            { send_token(TK_IntegerConstant); fbreak; };
        
        string_lit
            { send_token(TK_StringLiteral); fbreak; };
        
        whitespace
            { send_token(TK_WhiteSpace); fbreak; };
            
        single_comment
            { send_token(TK_Comment); fbreak; };
        multi_comment
            { send_token(TK_Comment); fbreak; };
        
        identifier
            { send_token(TK_Identifier); fbreak; };
    *|; 
}%% 

/* nofinal is used since we don't test for final state.  */
%%write data nofinal;

extern struct hsp_lexer *hsp_init_lexer(char *data, size_t length)
{
    struct hsp_lexer *lexer = malloc(sizeof(struct hsp_lexer));
    
    lexer->data = data;
    lexer->length = length;
    lexer->p = data;
    lexer->pe = data + length;
    lexer->eof = lexer->pe;
    /* cs is set by ragel */
    
    %%write init;
    
    return lexer;
}

extern void hsp_destroy_lexer(struct hsp_lexer *lexer)
{
    free(lexer);
}

extern int hsp_lex(struct hsp_lexer *lexer)
{
    int token = TK_Invalid;
    
    if (lexer->p == lexer->pe)
    {
        return TK_EndOfFile;
    }
    
    %%write exec;
    
    lexer->length = lexer->p - lexer->data;
    
    return token;
}

extern void hsp_reset_lexer(struct hsp_lexer *lexer)
{
    %%write init;
}
