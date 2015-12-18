# hsp
HLSL Shader Parser

My main motivation for this project is simply the learning curve of lexical analysis and parsing. I feel the need to be comfortable with at least one type of parsing and understand most common methods of parsing. The best way for me to learn is to create and learn from mistakes. As a reuslt, I can't recommend contributing to this software at this time. However, it's under the MIT license and you can do whatever you wish. 

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


