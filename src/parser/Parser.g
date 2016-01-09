%start hsp_parse, translation_unit;
%options "generate-symbol-table thread-safe generate-lexer-wrapper=yes";
%options "no-eof-zero";
%datatype "struct HSPLexer*", "lexer/Lexer.h";
%lexical hsp_lex_wrap;

%label STRUCT, "struct";
%label INT, "int";
%label VOID, "void";
%label IDENTIFIER, "identifier";

%label CLASS, "class";
%label INTERFACE, "interface";
%label TYPEDEF, "typedef";
%label SAMPLER, "sampler";
%label TEXTURE, "texture";
%label GROUPSHARED, "groupshared";
%label SHARED, "shared";
%label INLINE, "inline";
%label CLIPPLANES, "clipplanes";
%label LINEAR, "linear";
%label CENTROID, "centroid";
%label NOINTERPOLATION, "nointerpolation";
%label NOPERSPECTIVE, "noperspective";
%label SAMPLE, "sample";
%label FLOAT_LIT, "float literal";
%label INTEGER_LIT, "integral literal";
%label STRING_LIT, "string literal";
%label EXTERN, "extern";
%label PRECISE, "precise";
%label STATIC, "static";
%label UNIFORM, "uniform";
%label VOLATILE, "volatile";
%label CONST, "const";
%label ROW_MAJOR, "row_major";
%label COLUMN_MAJOR, "column_major";
%token TYPEDEF;
%token WHITESPACE;
%token COMMENT;

%token SAMPLER;
%token SAMPLER1D;
%token SAMPLER2D;
%token SAMPLER3D;
%token SAMPLER_CUBE;
%token SAMPLER_STATE;
%token SAMPLER_COMPARISON_STATE;

%token TEXTURE;
%token TEXTURE1D;
%token TEXTURE2D;
%token TEXTURE3D;
%token TEXTURE_CUBE;

%label LCURLY, "left curly '{'";
%label RCURLY, "right curly '}'";
%label LPAREN, "left parenthesis '('";
%label RPAREN, "right parenthesis ')'";
%label LBRACKET, "left bracket '['";
%label RBRACKET, "right bracket ']'";
%label SEMI, "semi-colon ';'";
%label COLON, "colon ':'";
%label DOT, "dot '.'";
%label COMMA, "comma ','";

/* Operators */
%token ADD_OP, SUB_OP, DIV_OP, MUL_OP, MOD_OP, XOR_OP;
%token BITAND_OP, BITOR_OP;

/* Assignment Operators */
%label EQUAL_OP, "equal '='";
%token ADDEQ_OP, SUBEQ_OP, DIVEQ_OP, MULEQ_OP, MODEQ_OP;
%token LSHIFTEQ_OP, RSHIFTEQ_OP;
%token BITANDEQ_OP, BITOREQ_OP, XOREQ_OP;

/* Shift Operators */
%token LSHIFT_OP, RSHIFT_OP;

/* Relation Operators */
%token LT_OP, GT_OP, LTEQ_OP, GTEQ_OP;
%token COMP_OP, DIFF_OP;

/* Unary Operators */
%token INC_OP, DEC_OP;

/*  */
%token AND_OP, OR_OP;

%token BUFFER, VECTOR, MATRIX;
%token BOOL, INT, UINT, DWORD, HALF, FLOAT, DOUBLE;
%token MIN16FLOAT, MIN10FLOAT, MIN16INT, MIN12INT, MIN16UINT;
%token VECTOR_BOOL, VECTOR_INT, VECTOR_UINT, VECTOR_DWORD, VECTOR_HALF, VECTOR_FLOAT, VECTOR_DOUBLE;
%token MATRIX_BOOL, MATRIX_INT, MATRIX_UINT, MATRIX_DWORD, MATRIX_HALF, MATRIX_FLOAT, MATRIX_DOUBLE;

%token RETURN;

{
#include "lexer/Lexer.h"
#include "parser/AST.h"
#include <stdio.h>
#include <stdlib.h>

void LLmessage(struct LLthis *LLthis, int LLtoken) {
	fprintf(stderr, "Line:%d:%d: ",
		hsp_get_line(LLdata),
		hsp_get_column(LLdata));

	switch (LLtoken) {
		case LL_MISSINGEOF:
			fprintf(stderr, "Expected %s, found %s. Skipping.\n", LLgetSymbol(EOFILE), LLgetSymbol(LLsymb));
			break;
		case LL_DELETE:
			fprintf(stderr, "Skipping unexpected %s.\n", LLgetSymbol(LLsymb));
			break;
		default:
			fprintf(stderr, "Expected %s, found %s. Inserting.\n", LLgetSymbol(LLtoken), LLgetSymbol(LLsymb));
			break;
	}
}

int hsp_lex_wrap(struct LLthis *LLthis)
{
	return hsp_lex(LLdata);
}

void hsp_set_ast_identifier(ASTIdentifier *identifier, struct HSPLexer *lexer)
{
	struct HSPLexeme lexeme = hsp_get_lexeme(lexer);
	memcpy(identifier, &lexeme, sizeof(identifier));
}
}

scalar_type<ASTTypeID> :
	BOOL |
	INT | UINT | DWORD |
	HALF | FLOAT | DOUBLE |
	MIN16FLOAT | MIN10FLOAT |
	MIN16INT | MIN12INT |
	MIN16UINT;

buffer_type<ASTTypeID> :
	BUFFER LT_OP
	[
		scalar_type |
		vector_type |
		matrix_type
	] GT_OP;

vector_type<ASTTypeID> :
	VECTOR_BOOL |
	VECTOR_INT | VECTOR_UINT | VECTOR_DWORD |
	VECTOR_HALF | VECTOR_FLOAT | VECTOR_DOUBLE |
	VECTOR LT_OP scalar_type COMMA INTEGER_LIT GT_OP;

matrix_type<ASTTypeID> :
	MATRIX_BOOL |
	MATRIX_INT | MATRIX_UINT | MATRIX_DWORD |
	MATRIX_HALF | MATRIX_FLOAT | MATRIX_DOUBLE |
	MATRIX LT_OP scalar_type COMMA INTEGER_LIT COMMA INTEGER_LIT GT_OP;

primitive_type<ASTTypeID> :
	buffer_type { return buffer_type; }|
	vector_type { return vector_type; }|
	matrix_type { return matrix_type; }|
	scalar_type { return scalar_type; };

constant :
	STRING_LIT |
	INTEGER_LIT |
	FLOAT_LIT;

user_defined_type<ASTTypeID> :
	IDENTIFIER { return Type_UserDefined; };

any_type(ASTType *type)
{
	ast_set_source_loc(type, LLdata);
} :
	primitive_type { type->id = primitive_type; type->name = hsp_get_lexeme(LLdata); } |
	user_defined_type { return user_defined_type; };

identifier(ASTIdentifier *identifier):
	IDENTIFIER { hsp_set_ast_identifier(identifier, LLdata); };

interpolation_modifier :
	LINEAR |
	CENTROID |
	NOINTERPOLATION |
	NOPERSPECTIVE |
	SAMPLE;

clipplanes :
	LBRACKET CLIPPLANES LPAREN [ IDENTIFIER [ COMMA IDENTIFIER ]*5 ]? RPAREN RBRACKET;

primary_expression :
	IDENTIFIER |
	constant |
	LPAREN [
		expression RPAREN |
		primitive_type RPAREN IDENTIFIER
	];

lhs_expression :
	primary_expression |
	unary_expression;

unary_expression :
	ADD_OP primary_expression |
	SUB_OP primary_expression;

additive_expression :
	ADD_OP expression |
	SUB_OP expression;

shift_expression :
	LSHIFT_OP expression |
	RSHIFT_OP expression;

multiplicative_expression :
	MUL_OP expression |
	DIV_OP expression |
	MOD_OP expression;

assignment_expression :
	EQUAL_OP expression |
	ADDEQ_OP expression |
	SUBEQ_OP expression |
	DIVEQ_OP expression |
	MULEQ_OP expression |
	MODEQ_OP expression |
	XOREQ_OP expression |
	BITANDEQ_OP expression |
	BITOREQ_OP  expression |
	LSHIFTEQ_OP expression |
	RSHIFTEQ_OP expression;

relational_expression :
	LT_OP expression |
	GT_OP expression |
	LTEQ_OP expression |
	GTEQ_OP expression;

equality_expression :
	COMP_OP expression |
	DIFF_OP expression;

and_expression :
	BITAND_OP expression;

exclusive_or_expression :
	XOR_OP expression;

inclusive_or_expression :
	BITOR_OP expression;

logical_and_expression :
	AND_OP expression;

logical_or_expression :
	OR_OP expression;

rhs_expression :
	additive_expression |
	multiplicative_expression |
	assignment_expression |
	shift_expression |
	relational_expression |
	equality_expression |
	and_expression |
	exclusive_or_expression |
	inclusive_or_expression |
	logical_and_expression |
	logical_or_expression |
	;

argument_list :
	[expression COMMA]*;

postfix :
	INC_OP |
	DEC_OP |
	LPAREN argument_list RPAREN;

expression :
	lhs_expression
	[
		rhs_expression |
		postfix
	];

statement :
	SEMI |
	expression SEMI |
	RETURN expression SEMI;

statement_block :
	statement*;

function_body : statement_block;

function_storage_class : INLINE;

function_arguments :
	LPAREN variable_type_specifier IDENTIFIER
	[COMMA variable_type_specifier IDENTIFIER]* RPAREN;

function_decl(ASTTranslationUnit *root) :
	function_storage_class+ clipplanes? PRECISE? function_type_specifier
	IDENTIFIER function_arguments LCURLY function_body RCURLY
|
	clipplanes PRECISE? function_type_specifier
	IDENTIFIER function_arguments LCURLY function_body RCURLY;

function_type_specifier :
	scalar_type |
	vector_type |
	matrix_type |
	VOID;

variable_storage_class :
	EXTERN | STATIC | NOINTERPOLATION |
	SHARED | GROUPSHARED | UNIFORM | VOLATILE;

variable_type_modifier :
	CONST | ROW_MAJOR | COLUMN_MAJOR;

variable_assignment : EQUAL_OP expression SEMI;

variable_decl(ASTTranslationUnit *root) :
	variable_storage_class+ variable_type_modifier* variable_type_specifier
	IDENTIFIER variable_assignment
|
	variable_type_modifier+ variable_type_specifier
	IDENTIFIER variable_assignment;

variable_type_specifier :
	scalar_type |
	buffer_type |
	vector_type |
	matrix_type;

/* You can't immediately tell the difference
	between a variable or function with an LL(1) grammar.
 * You have to wait until a left parenthesis,
  	semicolon, or equal symbol appears to tell. */
func_or_var_decl(ASTTranslationUnit *root) :
	any_type IDENTIFIER
	[
		SEMI
	|
		function_arguments LCURLY function_body RCURLY
	|
		variable_assignment
	];

class_body : ;

class_decl(ASTTranslationUnit *root) :
	CLASS IDENTIFIER LCURLY class_body RCURLY;

struct_member_decl :
	interpolation_modifier? any_type
	IDENTIFIER [ COLON IDENTIFIER ]? SEMI;

struct_body : struct_member_decl+;

struct_decl(ASTTranslationUnit *root) :
	STRUCT IDENTIFIER LCURLY struct_body RCURLY SEMI;

interface_body : ;

interface_decl(ASTTranslationUnit *root) : INTERFACE IDENTIFIER LCURLY interface_body RCURLY SEMI;

sampler_body : ;

sampler_decl(ASTTranslationUnit *root) :
	sampler_type_spec IDENTIFIER [
 	LCURLY sampler_body RCURLY ]? SEMI;

sampler_type_spec :
	SAMPLER |
	SAMPLER1D |
	SAMPLER2D |
	SAMPLER3D |
	SAMPLER_CUBE |
	SAMPLER_STATE |
	SAMPLER_COMPARISON_STATE;

texture_body : ;

texture_decl(ASTTranslationUnit *root) :
	texture_type_spec IDENTIFIER
	[ LCURLY texture_body RCURLY ]? SEMI;

texture_type_spec :
	TEXTURE |
	TEXTURE1D |
	TEXTURE2D |
	TEXTURE3D |
	TEXTURE_CUBE;

typedef_decl(ASTTranslationUnit *root) { ASTTypedefDecl *typedefi; }:
	TYPEDEF { typedefi = malloc(sizeof(ASTTypedefDecl)); }
	CONST? { typedefi->is_const = true; }
	any_type(&typedefi->type)
	identifier(&typedefi->name)
	SEMI;

translation_unit
{
	ASTTranslationUnit *root = malloc(sizeof(ASTTranslationUnit));
} :
[
	func_or_var_decl(root) |
	function_decl(root) |
	variable_decl(root) |
	class_decl(root) |
	struct_decl(root) |
	interface_decl(root) |
	sampler_decl(root) |
	texture_decl(root) |
	typedef_decl(root)
]*;
