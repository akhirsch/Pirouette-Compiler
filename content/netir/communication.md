+++
title = "Communication"
description = "Communication in NetIR"
weight = 1
+++

# Sending and Receiving

To send to another location, we use the pattern `send...to...`
For instance, we can write:
```
three_to_alice : unit -> unit
three_to_alice () := send 3 to Alice
```
This is a function that, when called (with an uninteresting input) sends `3` to the emulated location `Alice` we created earlier.
It then returns an uninteresting output.

In order to receive data from another process, we need to mention not only the other process's _name_, but also the _type_ of data we expect to receive.
For instance, we can receive an integer from `Alice` as follows:
```
recv_from_alice : unit -> int
recv_from_alice () := receive int from Alice
```

# Making Choices and Having Choices Made

Sometimes, we want to make different choices depending on what someone else is doing; other times, we want to make a choice and have someone else follow our lead.
To do that, we send and receive _choice labels_.
For instance, we might do the following:

```
type foo :=
  | bar : int -> foo
  | baz : string -> foo
  | bax : float -> foo

do_it : foo -> foo
do_it (bar n) = choose [L] for Alice; 
                send n to Alice; 
				bax n
do_it (baz s) = choose [C] for Alice; 
                let n := recv int from Alice 
			    in bar n
do_it (bax x) = choose [R] for Alice;				
                bar (round x)
```

Here, we pattern match on the input `foo` and, depending on which branch we are in, send either the label `[L]`, `[C]`, or `[R]`.
(Labels are always surrounded by square brackets.)
We can then communicate with `Alice` differently depending on which branch we are in: in the first branch we send something, in the second we receive something, in the third we don't communicate at all.

In order to follow someone else's lead, we pattern match on a label they send, as follows:
```
do_it' : unit -> int
do_it' = allow Alice choice
         | [L] -> receive int from Alice
         | [C] -> send 3 to Alice; 3
		 | [R] -> 7
```
Here, we allow `Alice` to choose any of the labels `[L]`, `[C]` or `[R]`.
Depending on which she chooses, we do different things: if she chooses `[L]`, we receive an integer from her and immediately return it.
If she chooses `[C]`, we send her `3` and return `3`.
Finally, if she chooses `[R]`, we don't communicate and simply return `7`.
If she chooses anything else, we are stuck.
Depending on the backend, we might crash or simply hang.

Note that these two programs are designed to work together: if both sides believe that the other is `Alice`, then these two programs will work together without issue.
