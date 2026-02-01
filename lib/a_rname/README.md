# Notes on our alpha renaming

Our alpha renaming function `ast_list_alpha_rename`, located within `rename.ml`, works by walking the abstract syntax tree passed into it by `main.ml`, and appending to all user-defined identifiers a suffix of `"_PIROUETTE_USR_ID"`. 

Every identifier, excluding domains, is renamed