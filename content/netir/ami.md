+++
title = "Am I?"
description = "Probing the current process"
weight = 1
+++


We can test which location is running the current code using `AmI`.
If Alice runs `AmI Alice`, then this will return `true`.
If she instead runs `AmI Bob`, then this will return `false`.
We can use this to write code that does different things depending on who is running it:
```
switch : unit -> int
switch () := if AmI Alice
             then 3
             else 5
```
