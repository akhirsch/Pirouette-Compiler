#!/bin/bash

for i in {2..31}
do
    echo "        let P$i.result  := P$i.test_collatz P$i.931386509544713451; in 
                  let P1.reply_P$i := [P$i] P$i.result ~> P1; in" >> output32_return.txt
done
