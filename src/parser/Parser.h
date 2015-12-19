#pragma once

#include <stdbool.h>
#include "lexer/Lexer.h"

struct HSPParser;

enum HSPDataType {
    T_Buffer,
    T_Bool,
    T_Int,
    T_UInt,
    T_DWord,
    T_Half, /* This is handled by a 32-bit float actually */
    T_Float,
    T_Double,
    T_Min16Float,
    T_Min10Float,
    T_Min12Int,
    T_Min16UInt,
    T_Vector, /* float1 or vector */
    T_Matrix, /* float1x1 or matrix */
    T_Sampler, /* Uh... how the fuck...? */
    T_Shader, /* Again... how...? */
    T_Texture, /* Fits all textures, metadata contains details. */
    T_Struct, /* User Defined Structure, must match something in type table. */
    T_UserDefined /* Typdef, must match something in type table */
};

struct HSPParser* hsp_create_parser(struct HSPLexer* lexer);
void hsp_destroy_parser(struct HSPParser* parser);

bool hsp_parse(struct HSPParser* parser);