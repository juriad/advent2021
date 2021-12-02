#! /usr/bin/apl --script

a ← ⊃⎕ARG
f ← {(~' '⍷⍵)/⍵} (a [5;])

input ←   ⍎¨ ⎕FIO[49] f

+/ (¯1 ↓ input) < (1 ↓ input)

sum ← (¯2 ↓ input) + (1 ↓ ¯1 ↓ input) + (2 ↓ input)

+/ (¯1 ↓ sum) < (1 ↓ sum)

)OFF
