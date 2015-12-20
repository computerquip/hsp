%%{
    machine hsp;
    
    #Arithmetic operators
    add_op = "+";
    sub_op = "-";
    mul_op = "*";
    div_op = "/";
    mod_op = "%";
    
    #Assignment operators
    equal_op = "=";
    addeq_op = "+=";
    subeq_op = "-=";
    muleq_op = "*=";
    diveq_op = "/=";
    modeq_op = "%=";
    
    #Relational operators
    lt_op = "<";
    gt_op = ">";
    eqeq_op = "==";
    diff_op = "!=";
    lteq_op = "<=";
    gteq_op = ">=";
    
    #Boolean operators
    and_op = "&&";
    or_op = "||";
    
    #Ternary operator
    question_op = "?";
    colon_op = ":";
    
    #Bitwise operations
    not_op = "~";
    xor_op = "^";
    bitor_op = "|";
    bitand_op = "&";
    lshift_op = "<<";
    rshift_op = ">>";
    
    #Bitwise assignment operations
    lshifteq_op = "<<=";
    rshifteq_op = ">>=";
    bitandeq_op = "&=";
    bitoreq_op = "|=";
    xoreq_op = "^=";
    
    #Unary operators
    inc_op = "++";
    dec_op = "--";
    
    #Problem: These operators is already defined as sub_op.
    #Solution: Let parser deal with the context required. 
    pos_op = "-";
    neg_op = "+";
    
    #Miscellaneous operators
    comma_op = ",";
    dot_op = ".";
    semi_op = ";";
    lbracket_op = "[";
    rbracket_op = "]";
    lcurly_op = "{";
    rcurly_op = "}";
    lparen_op = "(";
    rparen_op = ")";
    
}%%