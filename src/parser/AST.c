#include "lexer/Lexer.h"
#include "AST.h"
void ast_set_source_loc(ASTNode *node, struct HSPLexer *lexer)
{
	node->location.line = hsp_get_line(lexer);
	node->location.column = hsp_get_column(lexer);
}
