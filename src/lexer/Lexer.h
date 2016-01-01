#pragma once

#include <stddef.h>
#include <stdint.h>

struct HSPLexer;

#ifdef HAND_PARSER
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

struct HSPLexeme {
	uint16_t size;
	const char* data;
};

union HSPTokenData {
	/* Constant or Literal Values */
	uint32_t constant;
};

enum HSPTokenFlags {
	TKFlag_LeadingWhiteSpace = 0x01,
};

struct HSPToken {
	uint32_t id;
	uint32_t flags;
	struct HSPLexeme lexeme;
	union HSPTokenData data;
};
#endif

#ifdef __cplusplus
extern "C" {
	#endif

	struct HSPLexer *hsp_create_lexer(char *data, size_t length);
	void hsp_destroy_lexer(struct HSPLexer *lexer);
#ifdef HAND_PARSER
	struct HSPToken hsp_lex(struct HSPLexer *lexer);
#else
	int hsp_lex(struct HSPLexer *lexer);
#endif

	void hsp_reset_lexer(struct HSPLexer *lexer);
	unsigned int hsp_get_line(struct HSPLexer *lexer);
	unsigned int hsp_get_column(struct HSPLexer *lexer);

	#ifdef __cplusplus
}
#endif
