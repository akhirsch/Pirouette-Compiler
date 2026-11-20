+++
title = "Variant Matching"
weight = 1
+++

Variant matching is a compiler step that generates two tables. The first table matches variants to a list of their constructors, and the second matches constructors to the variant they are a constructor of. This is done after parsing and post-processing of the AST, as at that point, the AST should have all VariantDecl nodes. These tables are useful in cases like typechecking match statements. We can use these tables to check if a constructor is part of the variant being matched on, or to check if pattern matching on a variant covers all constructors.

# Return type

Variant Matching returns a pair of lookup functions. The first element is a function that, given the name of a variant, returns an optional list of the names of its constructors. The second element is a function that, given the name of a constructor, returns an optional name of its associated variant. Currently, the lookup functions work off of association lists. This was done for simplicity, and ease of maintenance. Currently, variant matching provides the user no access to these underlying lists. Luckily, if this is deemed useful, it would be trivial to add.

# Note on runtime

As mentioned, the lookup functions operate on association lists. Because of this, lookups take O(n) time, where n is the number of variants/constructors. While I don't expect this to be an issue, if it needs to be sped up, these can be refactored to use maps or hashtables. 