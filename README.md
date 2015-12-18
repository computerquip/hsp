# hsp
HLSL Shader Parser

My main motivation for this project is simply the learning curve of lexical analysis and parsing. I feel the need to be comfortable with at least one type of parsing and understand most common methods of parsing. The best way for me to learn is to create and learn from mistakes. As a result, I can't recommend contributing to this software at this time. However, it's under the MIT license and you can do whatever you wish. 

# Long Term Goals
If the project perhaps get to the point of a functional parser and reaches the IR generation stage, there will be a separate repository made. The second repository will take the binary ASTs the parser will eventually generate and translate them into LLVM IR, according to [the Spir-V friendly LLVM bitcodes provided by Khronos](https://github.com/KhronosGroup/SPIRV-LLVM/blob/khronos/spirv-3.6.1/docs/SPIRVRepresentationInLLVM.rst). From there, the only worry would be optimization. LLVM to SPIR-V translation is handled by Khronos. As long as the supported LLVM IR stays the same, there shouldn't be much to worry about. 

# Progress
10% * All possible lexical rules are matched to Ragel rules. 

35% * Custom Hand-Written Parser (probably Predictive Recursive Descent, might turn out differently). 
25% * Finish state machine paths for parser.
15% * Create portable build system
15% * Document interface and generated AST. 

# Dependencies to Build
Ragel 2.9
Tup

# Dependencies to Run
None

# Interface

#### Lexical Analyzer
```C
struct hsp_lexer *hsp_init_lexer(char *data, size_t length)
```
Initializes an instance of the lexical analyzer with a string to analyze. Returns back an opaque pointer used as a handle to the internal analyzer. 

```C
void hsp_destroy_lexer(struct hsp_lexer *lexer)
```
Cleans up after hsp_init_lexer.

```C
int hsp_lex(struct hsp_lexer *lexer)
```
Analyzes the string associated with analyzer, starting from where the previous call to hsp_lex left off. If there was no previous call, it starts at the beginning. If the analyzer immediately hits the maximum size of the string, it returns TK_EndOfFile. If the analyzer hits the maximum size of the string with characters left, it depends on the rule on whether or not it will return TK_EndOfFile. If will return a token if it can and then return TK_EndOfFile the next run. 

If the analyzer cannot recognize the symbol, it will return TK_Invalid. 

Note that it's undefined what happens if you call hsp_lex after receiving a TK_EndOfFile token. If you wish to restart the analyzer, use hsp_reset. 

```C
void hsp_reset_lexer(struct hsp_lexer *lexer)
```
This resets the analyzer back to its initial state, as if nothing was ever analyzed. Calling multiple times in a row should have no effect. 
