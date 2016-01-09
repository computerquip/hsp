#pragma once

#include <stddef.h>
#include <stdint.h>

struct HSPLexer;

struct HSPLexeme {
	size_t length;
	char* data;
};

#ifdef __cplusplus
extern "C" {
	#endif

	struct HSPLexer *hsp_create_lexer(char *data, size_t length);
	void hsp_destroy_lexer(struct HSPLexer *lexer);
	int hsp_lex(struct HSPLexer *lexer);

	void hsp_reset_lexer(struct HSPLexer *lexer);
	struct HSPLexeme hsp_get_lexeme(struct HSPLexer *lexer);
	unsigned int hsp_get_line(struct HSPLexer *lexer);
	unsigned int hsp_get_column(struct HSPLexer *lexer);

	#ifdef __cplusplus
}
#endif
