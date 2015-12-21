#include "Lexer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
};

/* This is useful if our API changes. */
#define send_token(_token) token.id = (_token)

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
		float_lit { send_token(TK_FloatConstant); fbreak; };
		hex_lit { send_token(TK_IntegerConstant); fbreak; };
		decimal_lit { send_token(TK_IntegerConstant); fbreak; };
		octal_lit {send_token(TK_IntegerConstant); fbreak; };
		
		# Class Modifiers
		extern { send_token(TK_Extern); fbreak; };
		no_interpolation { send_token(TK_NoInterpolation); fbreak; };
		precise { send_token(TK_Precise); fbreak; };
		shared { send_token(TK_Shared); fbreak; };
		static { send_token(TK_Static); fbreak; }; 
		uniform { send_token(TK_Uniform); fbreak; };
		volatile { send_token(TK_Volatile); fbreak; };
		
		# Type Modifiers
		const { send_token(TK_Const); fbreak; };
		row_major { send_token(TK_RowMajor); fbreak; };
		column_major { send_token(TK_ColumnMajor); fbreak; };
		
		# Data Types
		struct { send_token(TK_Struct); fbreak; };
		int { send_token(TK_Int); fbreak; };
		
		# Identifier
		identifier { send_token(TK_Identifier); fbreak; };
		
		# Whitespace
		whitespace { send_token(TK_WhiteSpace); fbreak; };
		single_comment { send_token(TK_Comment); fbreak; };
		multi_comment { send_token(TK_Comment); fbreak; };
		
		# Operators
		lcurly_op { send_token(TK_LCurlyOp); fbreak; };
		rcurly_op { send_token(TK_RCurlyOp); fbreak; };
		lparen_op { send_token(TK_LParenOp); fbreak; };
		rparen_op { send_token(TK_RParenOp); fbreak; };
		semi_op   { send_token(TK_SemiColonOp); fbreak; };
		colon_op  { send_token(TK_ColonOp); fbreak; };
		equal_op  { send_token(TK_EqualOp); fbreak; };
		dot_op    { send_token(TK_DotOp); fbreak; };
		comma_op  { send_token(TK_CommaOp); fbreak; };
		add_op    { send_token(TK_AddOp); fbreak; };
		sub_op    { send_token(TK_SubOp); fbreak; };
		div_op    { send_token(TK_DivOp); fbreak; };
		mul_op    { send_token(TK_MulOp); fbreak; };
	*|; 
}%% 

/* nofinal is used since we don't test for final state.  */
%%write data nofinal;

extern struct HSPLexer *hsp_create_lexer(char *data, size_t length)
{
	struct HSPLexer *lexer = malloc(sizeof(struct HSPLexer));
	
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

extern struct HSPToken hsp_lex(struct HSPLexer *lexer)
{
	struct HSPToken token = { TK_Invalid, 0 };
	
	if (lexer->p == lexer->pe) {
		token.id = TK_EndOfFile;
		return token;
	}
	
	%%write exec;
	
	token.lexeme.size = lexer->te - lexer->ts;
	token.lexeme.data = lexer->ts;
	
	lexer->length = lexer->p - lexer->data;
	
	return token;
}

extern void hsp_reset_lexer(struct HSPLexer *lexer)
{
	%%write init;
	lexer->p = lexer->data;
}

