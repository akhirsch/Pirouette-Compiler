+++
title = "Parsing"
description = "NetIR parsing"
weight = 1
+++

Parsing is handled by the "lexer.ml" and "parser.mly" files. These files use the Ocamllex and Menhir tool respectively. 

The lexer uses RegEx, and raw string matching to convert input text into a stream of tokens. We can also decide what to do when encountering a specific string, which is how we ignore comments, and capture escape sequences.

The parser operates on the stream of tokens, matching patterns of tokens to construct AST nodes. The parser operates over the whole stream, and produces a list of declarations, which is how we define a NetIR program.

## Decisions for consideration

There are two decisions about the language's syntax that arose during parser design that should be kept in mind, in hopes of finding a better solution.

The first one is the requirement to end each DefnDecl with a semicolon. This was done because of an ambiguity arising from FunApp and DefnDecl.
Take the following code:
```
foo := x
bar := y
```

This is a relatively straightforward program, consisting of two DefnDecls. The problem is that, when lexed, whitespace is removed. So the parser "sees" the tokens ```ID WALRUS ID ID WALRUS ID```. The parser can only look ahead a single token, so when it reaches the 2nd ID, it doesn't know what to do. It can either start a new DefnDecl, which is what we would want, but it could also interpret ```x bar``` as a function application. 

This is an ambiguity that the parse can not resolve on its own, so we have to change the language to accommodate. Our choice when implementing the parser initially was to add a ";" to denote the end of a DefnDecl block, so the parse always knows when to create a FunApp, and when to start a DefnDecl. 

Other options considered were starting DefnDecls with a unique token, such as "Let", and rolling IDs followed by WALRUSs into a specific token. The first option was not taken because it seemed slightly more intrusive than the semicolon, and the second wasn't taken for the sake of time.

The other decision was to require pattern matched constructors to have their arguments surrounded by parentheses, regardless of what the arguments are. For example:
```
data foo :=
    bar : unit -> foo

main :=
    match variable_name with
        | bar (()) := true
        | _ := false
;
```

As you can see, even though the constructor bar only takes a unit as an argument, it still requires parentheses. I'm less certain about the specific ambiguity this solved, but I believe that it's between ConstructorPat and DefnDecl. For example:

```
main foo bar baz :=
    ()
;
```

Here, we have ```ID ID ID WALRUS UNITLIT```. Note that in DefnDecl, we take a list of patterns, and we also take a list of patterns in ConstrucotPat. Thus, at the 3rd ID token, the parser doesn't know whether it's a new entry in the DefnDecl's pattern list, or whether "foo" is a constructor with the argument "baz". So constructor patterns were required to wrap their arguments in parentheses. 

## Post-processing

Because we don't want to enforce restrictions on constructor names in NetIR, there is no way to differentiate variable names from constructors with no arguments. For example;  
```
data foo :=
    bar : foo
    
main :=
    match variable_name with
        | bar := true
        | baz := false
;
```
We can see that bar is an argumentless constructor, and baz would be a variable, but the lexer only matches on text. Further, the parser doesn't have access to the whole program at once, so we can't determine that bar is a constructor while parsing either.  

The way we handle this is by parsing every would-be constructor as a variable initially. Then, after we have our parsed AST, we know what every declared variable constructor is named. We can then go through and replace any VarPat node whose names matches a constructor with a ConstructorPat node. 

This allows us to keep constructor names unrestricted and unambiguous.
