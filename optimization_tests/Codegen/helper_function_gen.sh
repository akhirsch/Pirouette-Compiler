#!/bin/bash

for i in {1..32}
do
    echo -e "P$i.test_collatz inp :=

        if P$i.(inp = 1)
        then 
            P$i.0
        else 
            let P$i.res1 := P$i.(inp/2); in 
            let P$i.res2 := P$i.(res1 * 2); in
                if P$i.(res2 = inp) then
                    let P$i.part_res := P$i.test_collatz P$i.(res1); in P$i.(part_res + 1)
                else 
                    let P$i.res3 := P$i.(3 * inp + 1); in
                    let P$i.res4 := P$i.test_collatz P$i.res3; in
                    P$i.(1 + res4);\n" >> output32.txt

done
