# Adding features to a Compiler: A Step-by-Step Guide

This guide walks you through the essential parts of building a compiler. We'll use a real-world example - adding support for external functions (FFI) - to demonstrate each component and why it's important. You'll learn:

- How to design syntax for your programming language
- How to break down code into meaningful pieces (lexing)
- How to understand the structure of code (parsing)
- How to represent code inside the compiler (AST)
- How to generate working code from your representation

Think of this as building a translation machine that turns your programming language into something a computer can understand. Let's break it down into simple, understandable steps!
## Table of Contents

1. [Syntax Design](#1-syntax-design)  
   - [What is Syntax Design?](#what-is-syntax-design)
   - [How to Design New Syntax](#how-to-design-new-syntax)

2. [Lexer Extension](#2-lexer-extension)  
   - [What is a Lexer?](#what-is-a-lexer)
   - [How Does a Lexer Work?](#how-does-a-lexer-work)
   - [Adding New Features to the Lexer](#adding-new-features-to-the-lexer)

3. [Parser Extension](#3-parser-extension)  
   - [What is a Parser?](#what-is-a-parser)
   - [How Does a Parser Work?](#how-does-a-parser-work)
   - [Adding New Rules to the Parser](#adding-new-rules-to-the-parser)

4. [AST (Abstract Syntax Tree)](#4-ast-abstract-syntax-tree)  
   - [What is an AST?](#what-is-an-ast)
   - [Why Do We Need an AST?](#why-do-we-need-an-ast)
   - [How to Add New Features to the AST](#how-to-add-new-features-to-the-ast)
   - [Where to Put New AST Nodes](#where-to-put-new-ast-nodes)

5. [Pretty Printing](#5-pretty-printing)  
   - [What is Pretty Printing?](#what-is-pretty-printing)
   - [Why Do We Need Pretty Printing?](#why-do-we-need-pretty-printing)
   - [Adding New Pretty Printing Rules](#adding-new-pretty-printing-rules)

5.5. [Extending the Net AST](#5-5-extending-the-net-ast)

6. [Code Generation](#6-code-generation)  
   - [What is Code Generation?](#what-is-code-generation)
   - [How Does Code Generation Work?](#how-does-code-generation-work)

7. [Why Do We Need All These Parts?](#7-why-do-we-need-all-these-parts)

8. [Conclusion](#8-conclusion)

---

## 1. Syntax Design

### What is Syntax Design?

When building a compiler, one of the first steps is deciding how programmers will write code in your language. This is called syntax design - it's like creating the "grammar rules" for your programming language. Just like English has rules for how to structure sentences, programming languages need clear rules for how to write code.

### How to Design New Syntax

Let's use a real example to understand this. We'll add support for calling functions from other programming languages (called Foreign Function Interface or FFI). To do this, we need to:

1. Choose keywords that make sense (we'll use `foreign`)
2. Decide how to structure the code (what information needs to go where)
3. Make it easy for programmers to read and write

Here's what our new syntax looks like:
```ocaml
foreign myFunction : SomeType := "external_function";
```

This tells the compiler:
- We're declaring a foreign function (using the `foreign` keyword)
- The function will be called `myFunction` in our code
- It has a type `SomeType`
- The actual function name in the other language is "external_function"

Think of it like creating a new road sign - it needs to be clear, consistent, and easy to understand for everyone who will use it!

---

## 2. Lexer Extension

### What is a Lexer?

A lexer is like a scanner for your code - it reads through your program character by character and groups them into meaningful chunks called "tokens". Think of it like reading a sentence: you naturally break it down into individual words. The lexer does the same thing for code!

### How Does a Lexer Work?

Let's see how our lexer breaks down this line of code:
```ocaml
foreign myFunction : SomeType := "external_function";
```

The lexer will identify:
1. `foreign` as a keyword token
2. `myFunction` as an identifier token
3. `:` as a colon token
4. `SomeType` as another identifier token
5. `:=` as an assignment token
6. `"external_function"` as a string token
7. `;` as a semicolon token

### Adding New Features to the Lexer

To make our lexer understand new parts of our language, we need to teach it about new keywords and symbols. Here's how we do that:

```ocaml
(* lib/parsing/lexer.mll *)
let read = parse
  ...
  | "foreign" { FOREIGN }  (* Recognize the 'foreign' keyword *)
  ...
```


Think of the lexer as the first step in translating your code - it's taking your raw text and turning it into something more structured that the compiler can work with.

---

## 3. Parser Extension

### What is a Parser?

After the lexer breaks code into tokens, the parser figures out how these tokens relate to each other - like understanding the grammar of a sentence. If the lexer identifies the individual words, the parser understands how they form a complete thought!

### How Does a Parser Work?

Let's look at our example again:
```ocaml
foreign myFunction : SomeType := "external_function";
```

The parser takes the tokens from the lexer and understands that:
1. This is a function declaration (because it starts with `foreign`)
2. `myFunction` is the name we'll use in our code
3. `SomeType` is the type of the function
4. `"external_function"` is the actual name of the function we're connecting to

### Adding New Rules to the Parser

We need to teach the parser about our new syntax in two steps:

1. First, tell the parser about our new keyword:
```ocaml
(* lib/parsing/parser.mly *)
%token FOREIGN
```

2. Then, teach it the rules for how this keyword can be used:
```ocaml
(* lib/parsing/parser.mly *)
foreign_decl:
  | FOREIGN id=var_id COLON t=choreo_type COLONEQ s=STRING SEMICOLON 
    { ForeignDecl (id, t, s, gen_pos $startpos $endpos) }
```

This rule tells the parser: "When you see FOREIGN followed by an identifier, colon, type, assignment, and string, that's a valid foreign function declaration!"

Think of the parser as a grammar teacher - it knows all the rules about how words (tokens) can be put together to make valid "sentences" in your programming language.


---

## 4. AST (Abstract Syntax Tree)

### What is an AST?

An AST is like a map of your code - it shows how all the different parts connect together. While the parser understands the basic rules, the AST shows the complete picture of your program in a way that makes sense to the compiler.

### Why Do We Need an AST?

Think about giving someone directions:
- The code you write is like your destination
- The AST is like the step-by-step directions to get there
- The compiler is like the person following these directions

### How to Add New Features to the AST

Let's add our new feature to the AST. We need to create a new "route" in our map for foreign function declarations:

```ocaml
(* lib/ast_core/choreo.ml *)
module M = struct
  ...
  type 'a stmt =
    | Decl of 'a pattern * 'a typ * 'a
    | ForeignDecl of 'a Local.var_id * 'a typ * string * 'a  (* New route *)
  ...
end
```

This tells the compiler that a `ForeignDecl` needs:
- A name (`var_id`) - like the name of a place
- A type (`typ`) - like what kind of place it is
- A string (the external function name) - like its address
- Some extra information (`'a`) - like landmarks to help find it

### Where to Put New AST Nodes

We put our new `ForeignDecl` in the statements section because:
- It's declaring something new (like adding a new location)
- It doesn't compute anything (like following directions would)
- It belongs with similar features (like keeping related places together)

Think of it like organizing a map - you want to group similar locations together so they're easy to find!

---

## 5. Pretty Printing

### What is Pretty Printing?

Pretty printing is like making your code look nice and readable when it's displayed. Think of it like formatting a text message - instead of sending everything in one long line, you add spaces, line breaks, and proper spacing to make it easy to read.

### Why Do We Need Pretty Printing?

Pretty printing helps us:
- Debug our code (find problems more easily)
- See what our compiler is doing
- Make sure our code is working correctly

### Adding New Pretty Printing Rules

We need to tell our compiler how to display our new foreign function declarations nicely. Here's how we do it:

```ocaml
(* lib/ast_utils/pprint_ast.ml *)
and pprint_choreo_stmt ppf (stmt : 'a Choreo.stmt) =
  match stmt with
  | ForeignDecl (VarId (id, _), t, s, _) ->
    fprintf ppf "@[<h>foreign %s : %a := \"%s\"@]" id pprint_choreo_type t s
```

This tells the printer:
- Start with the keyword "foreign"
- Add the function name
- Show its type
- Add the external name in quotes

When we run this, instead of seeing messy computer code like:
```
ForeignDecl(VarId("myFunction",_),SomeType,"external_function",_)
```

We'll see nice, readable code like:
```ocaml
foreign myFunction : SomeType := "external_function"
```

Think of it like translating computer language into human-readable text.

---

## 5.5. Extending the Net AST

### What is the Net AST?

The Net AST represents the network-level structure of your program. While the core AST handles basic program features, the Net AST specifically deals with network communication and distributed aspects of your code.

### Adding Foreign Functions to Net AST

To support foreign functions in our network code, we need to extend the Net AST similar to how we did with the core AST. Here's how we add it:

```ocaml:lib/ast_core/net.ml
type 'a stmt =
  | Decl of 'a Local.pattern * 'a typ * 'a
  | Assign of 'a Local.pattern list * 'a expr * 'a
  | TypeDecl of 'a Local.typ_id * 'a typ * 'a
  | ForeignDecl of 'a Local.var_id * 'a typ * string * 'a  (* Add this line *)
```

This addition allows us to:
- Declare foreign functions in network code
- Keep track of their types and external names
- Maintain consistency with the core AST structure

We also need to update the info handling functions to support our new statement type:

```ocaml:lib/ast_core/net.ml
let get_info_stmt : stmt -> Info.t = function
  | Decl (_, _, i) -> i
  | Assign (_, _, i) -> i
  | TypeDecl (_, _, i) -> i
  | ForeignDecl (_, _, _, i) -> i  (* Add this line *)

let set_info_stmt : Info.t -> stmt -> stmt =
  fun i -> function
  | Decl (p, t, _) -> Decl (p, t, i)
  | Assign (ps, e, _) -> Assign (ps, e, i)
  | TypeDecl (id, t, _) -> TypeDecl (id, t, i)
  | ForeignDecl (id, t, s, _) -> ForeignDecl (id, t, s, i)  (* Add this line *)
```

Think of this as extending our translation system to handle foreign functions at the network level, just like we did at the core level!

---

## 6. Code Generation

### What is Code Generation?

Code generation is the final step where our compiler turns our code into something the computer can actually run. Think of it like a translator converting a book from one language to another!

### How Does Code Generation Work?

When we write code like:
```ocaml
foreign myFunction : SomeType := "external_function";
```

The compiler needs to turn this into real, working code. Here's how we tell it to do that:

```ocaml
(* lib/codegen/emit_core.ml *)
let emit_foreign_decl id typ external_name =
  [%expr 
    let [%p pvar id] = External.[%e evar external_name] in
    [%e type_annotation typ]
  ]
```

This is like giving the translator rules for how to convert words from one language to another. The compiler uses these rules to create code that actually works on your computer!

## 7. Why Do We Need All These Parts?

Think of building a compiler like setting up a translation service:

- **Lexer:** Like someone who splits a sentence into individual words
  ```ocaml
  "foreign myFunction" → ["foreign"] ["myFunction"]
  ```

- **Parser:** Like someone who understands grammar rules
  ```ocaml
  ["foreign"] ["myFunction"] → "This is a function declaration"
  ```

- **AST:** Like organizing the translation notes in a clear way
  ```ocaml
  ForeignDecl(myFunction, ...)
  ```

- **Pretty Printer:** Like making sure the translation looks nice and readable
  ```ocaml
  foreign myFunction : SomeType
  ```

- **Code Generator:** Like writing out the final translation
  ```ocaml
  let myFunction = External.some_function
  ```

Each part has an important job, and they work together like a team to turn your code into something the computer understands.

---

## 8. Conclusion

Building a compiler is like building a translation machine - it takes code that humans can write and turns it into instructions that computers can understand. Let's review what we learned:

1. **Syntax Design** - Creating clear rules for writing code, like designing a new language
2. **Lexer** - Breaking code into meaningful pieces, like identifying words in a sentence
3. **Parser** - Understanding how the pieces fit together, like understanding grammar
4. **AST** - Creating a map of the code's structure, like drawing directions
5. **Pretty Printing** - Making the code readable for humans, like formatting a message
6. **Code Generation** - Creating the final computer instructions, like translating to a new language

