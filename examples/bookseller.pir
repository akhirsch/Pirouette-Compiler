foreign printf : unit -> unit := "Printf.printf";

main :=
  let Buyer.book_title := Buyer."Alice's Adventures in Wonderland"; in
  let Buyer.budget := Buyer.15; in
  
  let Seller.price := Seller.10; in
  let Seller.delivery_date := Seller."January 1, 1970"; in
  
  let bookseller := fun f ->
    let Seller.book_title := [Buyer] Buyer.book_title ~> Seller; in
    let Buyer.decision := f Seller.price; in
    if Buyer.decision then
      Buyer[L] ~> Seller;
      [Seller] Seller.delivery_date ~> Buyer.delivery_date;
      Buyer.delivery_date
    else
      Buyer[R] ~> Seller;
      Buyer."Order Canceled";
  in
  
  let simple_decision := fun Seller.p ->
    [Seller] Seller.p ~> Buyer.p;
    Buyer.(p < budget);
  in

  let Buyer.res := bookseller simple_decision; in
  Buyer.print_string Buyer.res;