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
%label FLOAT_CONSTANT, "float literal";
%label INTEGER_CONSTANT, "integral literal";
%label EXTERN, "extern";
%label PRECISE, "precise";
%label STATIC, "static";
%label UNIFORM, "uniform";
%label VOLATILE, "volatile";
%label CONST, "const";
%label ROW_MAJOR, "row_major";
%label COLUMN_MAJOR, "column_major";
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

/* Assignment Operators */
%label EQUAL_OP, "equal '='";
%token ADDEQ_OP, SUBEQ_OP, DIVEQ_OP, MULEQ_OP, MODEQ_OP;
%token LSHIFTEQ_OP, RSHIFTEQ_OP;
%token BITANDEQ_OP, BITOREQ_OP, XOREQ_OP;

/* Relation Operators */
%token LT_OP, GT_OP, LTEQ_OP, GTEQ_OP;
%token COMP_OP, DIFF_OP;

/* Unary Operators */
%token INC_OP, DEC_OP;

%token BUFFER, VECTOR, MATRIX;
%token BOOL, INT, UINT, DWORD, HALF, FLOAT, DOUBLE;
%token MIN16FLOAT, MIN10FLOAT, MIN16INT, MIN12INT, MIN16UINT;
%token VECTOR_BOOL, VECTOR_INT, VECTOR_UINT, VECTOR_DWORD, VECTOR_HALF, VECTOR_FLOAT, VECTOR_DOUBLE;
%token MATRIX_BOOL, MATRIX_INT, MATRIX_UINT, MATRIX_DWORD, MATRIX_HALF, MATRIX_FLOAT, MATRIX_DOUBLE;

%token RETURN;

{
#include "lexer/Lexer.h"
#include <stdio.h>

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
}

scalar_type :
	BOOL |
	INT | UINT | DWORD |
	HALF | FLOAT | DOUBLE |
	MIN16FLOAT | MIN10FLOAT |
	MIN16INT | MIN12INT |
	MIN16UINT;

buffer_type :
	BUFFER LT_OP
	[
		scalar_type |
		vector_type |
		matrix_type
	] GT_OP;

vector_type :
	VECTOR_BOOL |
	VECTOR_INT | VECTOR_UINT | VECTOR_DWORD |
	VECTOR_HALF | VECTOR_FLOAT | VECTOR_DOUBLE |
	VECTOR LT_OP scalar_type COMMA INTEGER_CONSTANT GT_OP;

matrix_type :
	MATRIX_BOOL |
	MATRIX_INT | MATRIX_UINT | MATRIX_DWORD |
	MATRIX_HALF | MATRIX_FLOAT | MATRIX_DOUBLE |
	MATRIX LT_OP scalar_type COMMA INTEGER_CONSTANT COMMA INTEGER_CONSTANT GT_OP;

primitive_type :
	buffer_type |
	vector_type |
	matrix_type |
	scalar_type;

user_defined_type { }:
	IDENTIFIER;

any_type :
	primitive_type |
	user_defined_type;

interpolation_modifier :
	LINEAR |
	CENTROID |
	NOINTERPOLATION |
	NOPERSPECTIVE |
	SAMPLE;

clipplanes :
	LBRACKET CLIPPLANES LPAREN [ IDENTIFIER [ COMMA IDENTIFIER ]*5 ]? RPAREN;

primitive_expression :
	IDENTIFIER |
	LPAREN expression RPAREN |
	INTEGER_CONSTANT |
	FLOAT_CONSTANT;

lhs_expression :
	primitive_expression;

rhs_expression :
	ADD_OP primitive_expression |
	SUB_OP primitive_expression |
	DIV_OP primitive_expression |
	MUL_OP primitive_expression |

	EQUAL_OP primitive_expression |
	ADDEQ_OP primitive_expression |
	SUBEQ_OP primitive_expression |
	DIVEQ_OP primitive_expression |
	MULEQ_OP primitive_expression |
	MODEQ_OP primitive_expression |
	XOREQ_OP primitive_expression |

	BITANDEQ_OP primitive_expression |
	BITOREQ_OP primitive_expression |
	LSHIFTEQ_OP primitive_expression |
	RSHIFTEQ_OP primitive_expression |

	LT_OP primitive_expression |
	GT_OP primitive_expression |
	LTEQ_OP primitive_expression |
	GTEQ_OP primitive_expression |
	COMP_OP primitive_expression |
	DIFF_OP primitive_expression |
	;

expression :
	lhs_expression rhs_expression;

statement :
	expression SEMI |
	RETURN expression SEMI;

statement_block :
	statement*;

function_body : statement_block;
function_storage_class : INLINE;
function_arguments : LPAREN variable_type_specifier IDENTIFIER [COMMA variable_type_specifier IDENTIFIER]* RPAREN;
function_decl : function_storage_class* function_type_specifier IDENTIFIER function_arguments LCURLY function_body RCURLY;
function_type_specifier :
	scalar_type |
	vector_type |
	matrix_type |
	VOID;

variable_storage_class : EXTERN | STATIC | NOINTERPOLATION | SHARED | GROUPSHARED | UNIFORM | VOLATILE;
variable_assignment : EQUAL_OP expression SEMI;
variable_decl : variable_storage_class* variable_type_specifier IDENTIFIER variable_assignment;
variable_type_specifier :
	scalar_type |
	buffer_type |
	vector_type |
	matrix_type;

/* "You can't immediately tell the difference between a variable or function with an LL(1) grammar."
 * "You have to wait until a left parenthesis, semicolon, or equal symbol appears to tell." */
func_or_var_decl :
	any_type IDENTIFIER
	[
		SEMI
	|
		function_arguments LCURLY function_body RCURLY
	|
		variable_assignment
	];

class_body : ;
class_decl : CLASS IDENTIFIER LCURLY class_body RCURLY;

struct_member_decl : interpolation_modifier? any_type IDENTIFIER [ COLON IDENTIFIER ]? SEMI;
struct_body : struct_member_decl+;
struct_decl : STRUCT IDENTIFIER LCURLY struct_body RCURLY SEMI;

interface_body : ;
interface_decl : INTERFACE IDENTIFIER LCURLY interface_body RCURLY SEMI;

sampler_body : ;
sampler_decl :	sampler_type_spec IDENTIFIER [ LCURLY sampler_body RCURLY ]? SEMI;
sampler_type_spec :
	SAMPLER |
	SAMPLER1D |
	SAMPLER2D |
	SAMPLER3D |
	SAMPLER_CUBE |
	SAMPLER_STATE |
	SAMPLER_COMPARISON_STATE;

texture_body : ;
texture_decl : texture_type_spec IDENTIFIER [ LCURLY texture_body RCURLY ]? SEMI;
texture_type_spec :
	TEXTURE |
	TEXTURE1D |
	TEXTURE2D |
	TEXTURE3D |
	TEXTURE_CUBE;

typedef_decl : TYPEDEF CONST? any_type IDENTIFIER SEMI;

translation_unit :
	[
		func_or_var_decl |
		class_decl |
		struct_decl |
		interface_decl |
		sampler_decl |
		texture_decl |
		typedef_decl
	]*;
