type myNewType := A.string;

foreign newPrint : myNewType -> unit := "print_string";
_ := A.newPrint A."this is a new type!";

