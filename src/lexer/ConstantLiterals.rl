%%{
    machine hsp;

    #Floating Point Literal
    fract_const = (
        digit+? "." digit+ |
        digit+ "." );
    
    exponent = [eE][+\-]?digit+;
    
    float_suffix = [hHfFlL];
    
    float_lit = (
        fract_const exponent? float_suffix? |
        digit+ exponent float_suffix?
        ) ;
        
    #Integral Literal
    decimal_lit = [1-9][0-9]+ [uUlL]{0,3} | "0";
    octal_lit = "0" [0-7]+ [uUlL]{0,2};
    hex_lit = "0x" [0-9a-fA-F]+ [uUlL]{0,2};
    
    #String Literal
    string_lit = ( '"' ( [^"\\\n] | /\\./ )* '"' );
    
    #White Space
    whitespace = [ \t\n\v\f];
    
    #Single Line Comment
    single_comment = "//" [^\n]* "\n";
    
    #Multi Line Comment
    multi_comment = "/*" any* :>> "*/";
    
    #Identifier
    identifier = [A-Za-z_][A-Za-z0-9_]*;
}%%