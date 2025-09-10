# Pirouette Compiler Codebase Overview

Welcome to the Pirouette Compiler! This guide provides an overview of the key directories involved in the compiler. It explains the role of each folder and critical files that constitute the compilation pipeline—from parsing to code generation and testing.

---

## Directory: lib

The `lib` directory contains the core components of the compiler. It is organized into several subdirectories, each handling a specific aspect of the compiler's operations:

### 1. ast_utils/
- **Purpose:**  
  Provides utility functions and common operations for managing and manipulating the Abstract Syntax Tree (AST).
- **Files :**
  - **ast_utils.ml & ast_utils.mli:**  
    Contain core utility functions for generic AST manipulations, including traversals and transformations used by various compiler components.
  - **jsonify_ast.ml & jsonify_ast.mli:**  
    Implement conversion of AST structures into JSON format, aiding in debugging and serialization of the AST.
  - **pprint_ast.ml & pprint_ast.mli:**  
    Provide pretty-printing facilities for the AST, using OCaml's Format module to render the AST in a human-readable form.
  - **dot_ast.ml & dot_ast.mli:**  
    Generate DOT language representations of the AST, enabling visualization through tools like Graphviz.
  - **ast_locs.ml & ast_locs.mli:**  
    Handle source location tracking within the AST, annotating nodes with position information for improved error reporting and debugging.
- **Content:**  
  Together, these files offer a comprehensive toolkit for analyzing, visualizing, and transforming ASTs across the compiler.

### 2. parsing/
- **Purpose:**  
  Implements lexical analysis and parsing.
- **Files:**  
  - **lexer.mll:**  
    Breaks the source code into tokens, handling whitespace, keywords, literals, and operators.
  - **parser.mly:**  
    Defines the grammar rules and constructs the initial AST from the tokens.
- **Functionality:**  
  Converts raw source code into a structured format that the rest of the compiler can work with.

### 3. typing/
- **Purpose:**  
  Contains the type system and type-checking components.
- **Key Aspects:**  
  - Definitions for language types and type inference mechanisms.
  - Ensures that programs are type safe before further compilation.
- **Reference:**  
  Detailed documentation can be found in `docs/typing.tex`.

### 4. codegen/
- **Purpose:**  
  Responsible for generating the target code from the optimized AST.
- **Files:**
  - **emit_core.ml & emit_core.mli:**  
    Implement the core functionality of code generation. `emit_core.ml` handles the transformation of the intermediate representation into target-specific code with essential optimizations, while `emit_core.mli` defines its public interface.
  - **msg_intf.ml & msg_intf.mli:**  
    Define the message interface used during code generation. These files specify the types and functions for managing message passing constructs and data transfers within the compiled code.
  - **toplevel_shm.ml & toplevel_shm.mli:**  
    Provide the top-level routines for the shared memory backend. These modules coordinate the generation of code that leverages shared memory for inter-component communication at runtime.
- **Functionality:**  
  The codegen module transforms intermediate representations into executable code by handling optimizations, local computations, and control flow construction, ensuring the generated code meets the backend requirements.

### 5. netgen/
- **Purpose:**  
  Responsible for generating the compiler's intermediate representation (IR) code.
- **Functionality:**  
  Transforms the abstract constructs from the intermediate representation into IR code tailored for different target backends (e.g., shared memory, HTTP). This module acts as a bridge between the high-level AST and the final target code by producing the necessary IR for subsequent code generation stages.

### 6. ast_core/
- **Purpose:**  
  Contains the foundational AST modules that directly support language constructs.
- **Files:**  
  - **local.mli & local.ml:**  
    Define and implement AST nodes and operations for local computations within a choreography.
  - **choreo.mli & choreo.ml:**  
    Specify and implement the representation of choreographed interactions, forming the structured backbone of the AST.
  - **net.mli & net.ml:**  
    Define and implement the compiler's intermediate representation. These modules abstract high-level constructs into an intermediary form that bridges the choreography representation and the backend code generation phases.
- **Role in Compiler:**  
  They lay the groundwork for AST construction, transformation, and subsequent code generation.

### 7. config/
- **Purpose:**  
  Contains configuration files and modules that manage compiler parameters and environment settings.
- **Functionality:**  
  Handles settings such as command-line options, default behaviors, and other environment-specific configurations.

### 8. http/
- **Purpose:**  
  Supports HTTP-based backend functionalities.
- **Functionality:**  
  Implements modules and utilities for managing HTTP communications in the generated code.

---

## Directory: bin

The `bin` directory is dedicated to the compiler's executable code.

### Files:
- **main.ml:**  
  - **Purpose:**  
    The entry point of the compiler.
  - **Functionality:**  
    Sets up the environment, parses command-line arguments, and initiates the complete compilation pipeline—from lexing and parsing to type checking and code generation.

---

## Directory: examples

The `examples` directory contains sample Pirouette programs used primarily for testing the compiler's functionality. These examples serve as test cases to demonstrate and validate various features of the Pirouette language and the overall compilation pipeline.

---

## Directory: test

The `test` directory includes a suite of tests that validate various components of the compiler to ensure its correctness and stability.

### Files:
- **typcheck_test.ml:**  
  Tests `lib/typing/typ_infer.ml`
- **prettyprint_test.ml:**  
  Tests `lib/ast_utils/pprint_ast.ml`
- **test_ffi_codegen.ml:**  
  Tests `lib/codegen/test_ffi_codegen.ml`
- **astutils_testcases.ml:**  
  Tests `lib/ast_utils/ast_utils.ml`
- **parsing_test.ml:**  
  Tests `lib/parsing/parser.mly`
- **send_receive_test.ml:**  
  Tests `lib/netgen/send_receive.ml`
- **marshal_receiver.ml, marshal_sender.ml, marshal_test.ml:**  
  Tests `lib/marshalling/marshal.ml`
- **types_test.ml:**  
  Tests `lib/typing/types.ml`
- **example.yaml:**  
  Provides configuration inputs for various test scenarios.

---

## Conclusion

This overview covers the essential parts of the Pirouette Compiler codebase across the primary directories. Each section of the code—whether it's parsing, type checking, code generation, or testing—is organized into dedicated folders to maintain modularity and ease of development. As you delve deeper into the project, you will see how these components interact to transform high-level choreography code into executable programs for various backends.

Happy coding and welcome to the team!