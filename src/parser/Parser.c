#include "Parser.h"

#include <stdio.h>
#include <stdlib.h>

#define match(___token) hsp_match(parser, ___token);

struct HSPParser {
    bool healthy; /* true is healthy, false means there are errors */
    struct HSPToken token; /* Look-ahead token */
    struct HSPLexer *lexer;
};

inline static void hsp_error(struct HSPParser* parser)
{
    /* This can so easily be expanded on... */
    parser->healthy = false;
    printf("<error>: %s - %.*s\n", 
           GET_TOKEN_STRING(parser->token.id),
           parser->token.lexeme.size, parser->token.lexeme.data);
}

inline static void hsp_match(struct HSPParser* parser, int token)
{
    if (parser->token.id == token) {
        do {
            parser->token = hsp_lex(parser->lexer);
            /* Discard whitespace tokens */
        } while (parser->token.id == TK_WhiteSpace);
    } else {
        hsp_error(parser);
    }
}

inline static bool datatype(struct HSPParser* parser)
{    
    printf("<%s>\n", __func__);
    
    switch (parser->token.id) {
    case TK_Int:
        match(TK_Int);
        break;
    default:
        hsp_error(parser);
        return false;
    }
    
    return true;
}
/*
 * declaration := datatype identifier TK_SemiColon | ;
 */
inline static bool declaration(struct HSPParser* parser)
{
    printf("<%s>\n", __func__);
    
    if (!datatype(parser)) {
        return false;
    }
    
    match(TK_Identifier);
    match(TK_SemiColon);
    
    return true;
}

/* 
 * declaration_list := declaration | declaration_list; 
 */
inline static bool declaration_list(struct HSPParser* parser)
{
    printf("<%s>\n", __func__);
    
    if (parser->token.id == TK_RCurly)
        return;
    
    if (declaration(parser))
        declaration_list(parser);
}

inline static bool _struct(struct HSPParser* parser)
{
    printf("<%s>\n", __func__);
    
    match(TK_Struct);
    match(TK_Identifier);
    match(TK_LCurly);
    
    if (!declaration_list(parser))
        return false;
    
    match(TK_RCurly);
}

inline static void translation_unit(struct HSPParser* parser)
{
    printf("<%s>\n", __func__);
    
    switch(parser->token.id) {
    case TK_Struct:
        _struct(parser);
        break;
    default:
        hsp_error(parser);
    }
}

struct HSPParser* hsp_create_parser(struct HSPLexer* lexer)
{
    struct HSPParser* parser = malloc(sizeof(struct HSPParser));
    parser->lexer = lexer;
    parser->token.id = TK_Invalid;
    parser->healthy = true;
}

void hsp_destroy_parser(struct HSPParser* parser)
{
    free(parser);
}

bool hsp_parse(struct HSPParser* parser)
{
    parser->token = hsp_lex(parser->lexer);
    translation_unit(parser);
    return parser->healthy;
}