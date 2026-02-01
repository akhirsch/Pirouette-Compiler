digest1 := digest_convert_to_hex_string_stdlib (digest_string_stdlib A."Will this string be properly digested?");
_ := print_endline_stdlib (string_cat_stdlib A."Digest 1: " digest1);
digest2 := digest_convert_to_hex_string_stdlib (digest_string_stdlib A."Will this string be properly digested?");
_ := print_endline_stdlib (string_cat_stdlib A."Digest 2: " digest2);
digest3 := digest_convert_to_hex_string_stdlib (digest_string_stdlib A."I think this string is a little different");
_ := print_endline_stdlib (string_cat_stdlib A."Digest 3: " digest3);
_ := print_endline_stdlib (string_cat_stdlib A."Digests 1 and 2 are equal? " (string_of_bool_stdlib (digest_is_equal_stdlib digest1 digest2))); 
_ := print_endline_stdlib (string_cat_stdlib A."Digests 1 and 3 are equal? " (string_of_bool_stdlib (digest_is_equal_stdlib digest1 digest3))); 