%%{
    machine hsp;
    
    #Reserved has no reason to have individual rules.
    #The only purpose of reserved words is to make sure identifiers aren't reserved words.
    reserved = 
        "auto" |
        "case" | "catch" |
        "char" | "class" | "const_cast" |
        "default" | "delete" | "dynamic_cast" |
        "enum" |
        "explicit" |
        "friend" |
        "goto" |
        "long" |
        "mutable" |
        "new" |
        "operator" |
        "private" | "protected" | "public" |
        "reinterpret_cast" |
        "short" | "signed" | "sizeof" | "static_cast" |
        "template" | "this" | "throw" |
        "try" | "typename" |
        "union" | "unsigned" |
        "using" |
        "virtual";
}%%