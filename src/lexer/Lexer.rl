#include "Lexer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser/Parser.h"

struct HSPLexer {
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

	/* column - Number column */
	unsigned int column;

	/* line - Number line */
	unsigned int line;
};

/* This is useful if our API changes. */
#define send_token(_token) token = (_token)

%%{
	machine hsp;
	access lexer->;
	variable p lexer->p;
	variable pe lexer->pe;
	variable eof lexer->eof;

	include "rules/definitions/ConstantLiterals.rl";
	include "rules/definitions/Keywords.rl";
	include "rules/definitions/Operators.rl";

	main :=
	|*
		# Literals
		float_lit { send_token(FLOAT_CONSTANT); fbreak; };
		hex_lit { send_token(INTEGER_CONSTANT); fbreak; };
		decimal_lit { send_token(INTEGER_CONSTANT); fbreak; };
		octal_lit {send_token(INTEGER_CONSTANT); fbreak; };

		# Class Modifiers
		extern { send_token(EXTERN); fbreak; };
		no_interpolation { send_token(NOINTERPOLATION); fbreak; };
		precise { send_token(PRECISE); fbreak; };
		shared { send_token(SHARED); fbreak; };
		static { send_token(STATIC); fbreak; };
		uniform { send_token(UNIFORM); fbreak; };
		volatile { send_token(VOLATILE); fbreak; };

		# Type Modifiers
		const { send_token(CONST); fbreak; };
		row_major { send_token(ROW_MAJOR); fbreak; };
		column_major { send_token(COLUMN_MAJOR); fbreak; };

		# Data Types
		struct { send_token(STRUCT); fbreak; };
		int { send_token(INT); fbreak; };

		# Identifier
		identifier { send_token(IDENTIFIER); fbreak; };

		# Whitespace
		whitespace { lexer->column += lexer->te - lexer->ts; };
		newline { ++lexer->line; lexer->column = 0; };
		single_comment { };
		multi_comment { /* TODO: This breaks line/column count */ };

		# Operators
		lcurly_op { send_token(LCURLY); fbreak; };
		rcurly_op { send_token(RCURLY); fbreak; };
		lparen_op { send_token(LPAREN); fbreak; };
		rparen_op { send_token(RPAREN); fbreak; };
		semi_op   { send_token(SEMI); fbreak; };
		colon_op  { send_token(COLON); fbreak; };
		dot_op    { send_token(DOT); fbreak; };
		comma_op  { send_token(COMMA); fbreak; };

		add_op    { send_token(ADD_OP); fbreak; };
		sub_op    { send_token(SUB_OP); fbreak; };
		div_op    { send_token(DIV_OP); fbreak; };
		mul_op    { send_token(MUL_OP); fbreak; };
		mod_op    { send_token(MOD_OP); fbreak; };

		equal_op  { send_token(EQUAL_OP); fbreak; };
		addeq_op  { send_token(ADDEQ_OP); fbreak; };
		subeq_op  { send_token(SUBEQ_OP); fbreak; };
		muleq_op  { send_token(MULEQ_OP); fbreak; };
		diveq_op  { send_token(DIVEQ_OP); fbreak; };
		modeq_op  { send_token(MODEQ_OP); fbreak; };
		lshifteq_op { send_token(LSHIFTEQ_OP); fbreak; };
		rshifteq_op { send_token(RSHIFTEQ_OP); fbreak; };
		bitandeq_op { send_token(BITANDEQ_OP); fbreak; };
		bitoreq_op  { send_token(BITOREQ_OP); fbreak; };
		xoreq_op    { send_token(XOREQ_OP); fbreak; };

		gt_op     { send_token(GT_OP); fbreak; };
		lt_op     { send_token(LT_OP); fbreak; };
		gteq_op   { send_token(GTEQ_OP); fbreak; };
		lteq_op   { send_token(LTEQ_OP); fbreak; };
		comp_op   { send_token(COMP_OP); fbreak; };
		diff_op   { send_token(DIFF_OP); fbreak; };

		inc_op { send_token(INC_OP); fbreak; };
		dec_op { send_token(DEC_OP); fbreak; };
	*|;
}%%

/* nofinal is used since we don't test for final state.  */
%%write data nofinal;

extern struct HSPLexer *hsp_create_lexer(char *data, size_t length)
{
	struct HSPLexer *lexer = malloc(sizeof(struct HSPLexer));

	lexer->line = 0;
	lexer->column = 0;
	lexer->data = data;
	lexer->length = length;
	lexer->p = data;
	lexer->pe = data + length;
	lexer->eof = lexer->pe;
	/* cs is set by ragel */

	%%write init;

	return lexer;
}

extern void hsp_destroy_lexer(struct HSPLexer *lexer)
{
	free(lexer);
}

extern int hsp_lex(struct HSPLexer *lexer)
{
	int token = EOFILE;

	lexer->column += (lexer->te - lexer->ts);

	if (lexer->p == lexer->pe) {
		return token;
	}

	%%write exec;

	lexer->length = lexer->p - lexer->data;

	return token;
}

unsigned int hsp_get_line(struct HSPLexer *lexer)
{ return lexer->line + 1; }

unsigned int hsp_get_column(struct HSPLexer *lexer)
{ return lexer->column + 1; }

extern void hsp_reset_lexer(struct HSPLexer *lexer)
{
	%%write init;
	lexer->p = lexer->data;
	lexer->line = 0;
	lexer->column = 0;
}
