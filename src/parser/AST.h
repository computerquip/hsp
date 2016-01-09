#pragma once

#include <stdbool.h>

typedef struct Identifier ASTString;
typedef struct Identifier ASTIdentifier;
typedef struct SourceLoc ASTSourceLoc;
typedef struct Node ASTNode;
typedef struct TranslationUnit ASTTranslationUnit;
typedef union TopDecl ASTTopDecl;
typedef struct TypedefDecl ASTTypedefDecl;
typedef struct VariableDecl ASTVariableDecl;
typedef struct FunctionImpl ASTFunctionImpl;
typedef struct FunctionArgument ASTFunctionArgument;
typedef struct StatementBlock ASTStatementBlock;
typedef struct Statement ASTStatement;
typedef struct Type ASTType;
typedef enum TypeID ASTTypeID;
typedef enum StatementID ASTStatementID;
typedef uint32_t ASTInteger;
typedef uint32_t ASTFlags;
typedef bool ASTBool;

struct Identifier {
	size_t length;
	char* data;
};

struct SourceLoc {
	ASTInteger column;
	ASTInteger line;
};

struct Node {
	ASTSourceLoc location;
};

enum TypeID {
	Type_Int,
	Type_UserDefined
};

enum StatementID {
	Statement_Expression,
	Statement_For,
	Statement_While,
	Statement_Do,
	Statement_If,
	Statement_ElseIf,
	Statement_Else
};

struct Type {
	ASTNode node;
	ASTTypeID id;
	ASTIdentifier name;
};

struct FunctionArgument {
	ASTType type;
	ASTIdentifier name;
};

struct Statement {
	ASTStatementID id;
};

struct StatementBlock {
	ASTStatement *statements;
};

struct FunctionImpl {
	ASTNode node;
	ASTFlags decl_spec_flags;
	ASTType return_type;
	ASTIdentifier name;
	ASTFunctionArgument *arguments;
	ASTStatementBlock statementblock;
};

struct VariableDecl {
	ASTNode node;
	ASTFlags decl_spec_flags;
	ASTType type;
	ASTIdentifier name;
};

struct TypedefDecl {
	ASTNode node;
	ASTBool is_const;
	ASTType type;
	ASTIdentifier name;
};

union TopDecl {
	ASTFunctionImpl function;
	ASTVariableDecl variable;
};

struct TranslationUnit {
	ASTTopDecl *decl;
};

void ast_set_source_loc(ASTNode *node, struct HSPLexer *lexer);
