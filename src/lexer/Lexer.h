#pragma once

#include <stddef.h>
#include <stdint.h>

struct HSPLexer;

/* Map of the numerous tokens to strings. */
static const char *HSPTokenMap[] = {
	"TK_Invalid",
	"TK_IntegerConstant",
	"TK_FloatConstant",
	"TK_StringLiteral",
	"TK_Identifier",
	"TK_WhiteSpace",
	"TK_Comment",
	
	"TK_Extern",
	"TK_NoInterpolation",
	"TK_Precise",
	"TK_Shared",
	"TK_Static",
	"TK_Uniform",
	"TK_Volatile",
	"TK_Const",
	"TK_RowMajor",
	"TK_ColumnMajor",
	
	"TK_Struct",
	"TK_Int",
	
	"TK_LBracketOp", "TK_RBracketOp",
	"TK_LCurlyOp", "TK_RCurlyOp",
	"TK_LParenOp", "TK_RParenOp",
	"TK_ColonOp", "TK_SemiColonOp",
	"TK_EqualOp",
	"TK_DotOp", "TK_CommaOp",
	"TK_AddOp", "TK_SubOp",
	"TK_DivOp", "TK_MulOp",
	
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
	TK_Extern,
	TK_NoInterpolation,
	TK_Precise,
	TK_Shared,
	TK_Static,
	TK_Uniform,
	TK_Volatile,
	TK_Const,
	TK_RowMajor,
	TK_ColumnMajor,
	
	/* Data Types */
	TK_Struct,
	TK_Int,
	
	/* Operators */
	TK_LBracketOp, TK_RBracketOp,
	TK_LCurlyOp, TK_RCurlyOp,
	TK_LParenOp, TK_RParenOp,
	TK_ColonOp, TK_SemiColonOp,
	TK_EqualOp,
	TK_DotOp, TK_CommaOp,
	TK_AddOp, TK_SubOp,
	TK_DivOp, TK_MulOp,
	
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
	
	struct HSPLexer *hsp_create_lexer(char *data, size_t length);
	void hsp_destroy_lexer(struct HSPLexer *lexer);
	struct HSPToken hsp_lex(struct HSPLexer *lexer);
	void hsp_reset_lexer(struct HSPLexer *lexer);
	
	#ifdef __cplusplus
}
#endif