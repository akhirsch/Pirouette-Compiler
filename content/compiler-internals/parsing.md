+++
title = "Parsing"
description = "NetIR parsing"
weight = 1
+++

Parsing is handled by the "lexer.ml" and "parser.mly" files. These files use the Ocamllex and Menhir tool respectively. 

The lexer uses RegEx, and raw string matching to convert input text into a stream of tokens. We can also decide what to do when encountering a specific string, which is how we ignore comments, and capture escape sequences.

The parser operates on the stream of tokens, matching patterns of tokens to construct AST nodes. The parser operates over the whole stream, and produces a list of declarations, which is how we define a NetIR program. 

## Post-processing

Because we don't want to enforce restrictions on constructor names in NetIR, there is no way to differentiate variable names from constructors with no arguments. For example;  
```
data foo :=
    bar : foo
    
main :=
    match variable_name with
        | bar := true
        | baz := false
```
We can see that bar is an argumentless constructor, and baz would be a variable, but the lexer only matches on text. Further, the parser doesn't have acces to the whole program at once, so we can't determine that bar is a constructor while parsing either.  

The way we handle this is by parsing every would-be constructor as a variable initially. Then, after we have our parsed AST, we know what every declared variable constructor is named. We can then go through and replce any VarPat node whose names matches a constructor with a ConstructorPat node. 

This allows us to keep constructor names unrestricted and unambiguous.
