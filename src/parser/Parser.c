#include "lexer/Lexer.h"
#include "Parser.h"
#include <stdio.h>

#define match(___token) hsp_match(parser, ___token);

struct hsp_parser {
    struct HSPToken token; /* Look-ahead token */
    struct HSPLexer *lexer;
};

static void hsp_match(struct hsp_parser* parser, int token)
{
    if (parser->cur_token.id == token) {
        token = hsp_lex(lexer);
    } else {
        hsp_error(parser);
    }
}

static void declaration(struct hsp_parser* parser)
{
    match(TK_VariableType);
    match(TK_Identifier);
}

static void declaration_list(struct hsp_parser* parser)
{
    while (parser->token.id != TK_RCurly) {
        declaration();
    }
}

void _struct(struct hsp_parser* parser)
{
    match(TK_Struct);
    match(TK_Identifier);
    match(TK_LCurly);
    
    declaration_list(parser);
    
    match(TK_RCurly);
    
    printf("Matched a struct!");
}

void hsp_error(struct hsp_parser* parser)
{
    /* This can so easily be expanded on... */
    printf("Parser error");
}

struct hsp_parser* hsp_parser_init(struct hsp_lexer* lexer)
{
    parser->lexer = lexer;
    parser->token = { TK_Invalid, 0 };
}

void hsp_parse(struct hsp_parser* parser)
{
    token = hsp_lex(lexer);
    module(parser);
}