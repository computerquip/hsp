#pragma once

struct hsp_parser* parser hsp_parser_init(struct hsp_lexer* lexer);
void hsp_parse(struct hsp_parser* parser);