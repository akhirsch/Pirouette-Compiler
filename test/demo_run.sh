#!/bin/bash

# Before running this script, set up SSH keys on your laptop:
# 1. Run: ssh-keygen (hit enter through all prompts)
# 2. Run ssh-copy-id for each Pi (enter password once per Pi):
#    ssh-copy-id chourante@<IP_A>
#    ssh-copy-id chourante@<IP_B>
#    ssh-copy-id chourante@<IP_C>
#    ssh-copy-id chourante@<IP_D>
#    ssh-copy-id chourante@<IP_E>
#    ssh-copy-id chourante@<IP_F>
#    ssh-copy-id chourante@<IP_G>
#    ssh-copy-id chourante@<IP_H>
#    ssh-copy-id chourante@<IP_I>
#    ssh-copy-id chourante@<IP_J>
#    ssh-copy-id chourante@<IP_K>
#    ssh-copy-id chourante@<IP_L>
#    ssh-copy-id chourante@<IP_M>
#    ssh-copy-id chourante@<IP_N>
#    ssh-copy-id chourante@<IP_O>
#    ssh-copy-id chourante@<IP_P>

ssh chourante@<IP_A> "cd /scratch && ./a shortdemo.yaml" &
ssh chourante@<IP_B> "cd /scratch && ./b shortdemo.yaml" &
ssh chourante@<IP_C> "cd /scratch && ./c shortdemo.yaml" &
ssh chourante@<IP_D> "cd /scratch && ./d shortdemo.yaml" &
ssh chourante@<IP_E> "cd /scratch && ./e shortdemo.yaml" &
ssh chourante@<IP_F> "cd /scratch && ./f shortdemo.yaml" &
ssh chourante@<IP_G> "cd /scratch && ./g shortdemo.yaml" &
ssh chourante@<IP_H> "cd /scratch && ./h shortdemo.yaml" &
ssh chourante@<IP_I> "cd /scratch && ./i shortdemo.yaml" &
ssh chourante@<IP_J> "cd /scratch && ./j shortdemo.yaml" &
ssh chourante@<IP_K> "cd /scratch && ./k shortdemo.yaml" &
ssh chourante@<IP_L> "cd /scratch && ./l shortdemo.yaml" &
ssh chourante@<IP_M> "cd /scratch && ./m shortdemo.yaml" &
ssh chourante@<IP_N> "cd /scratch && ./n shortdemo.yaml" &
ssh chourante@<IP_O> "cd /scratch && ./o shortdemo.yaml" &
ssh chourante@<IP_P> "cd /scratch && ./p shortdemo.yaml" &

wait