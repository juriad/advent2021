# Progress

Each day I use a different programming language.

## Day 1 - APL

Oh my god, APL uses nice concepts - working with arrays, but it is so much pain to work with. I was never sure if the font displays the character
correctly; I had to copy and paste everything. If only the functions were a bit more descriptive and shape more visible (I bet you can set it but I
did not figure it out). I did not attempt to learn how to define my own functions though.

The language was a good match for the task. As with most languages the ain problem was the IO - reading a file is apparently not very standardized
between APL implementations.

## Day 2 - Io

I chose a high-level languages because the task looked simple but something I could model as objects. I often encountered situations when the language
did not point out an error - it just did something - or nothing. I love languages based on simple principles. Io has a good documentation and guide.
Finding `asNumber`, `String split` and `File` in the guide made me happy as these are common issues which differ between all languages.

The most cumbersome part was that only one version of `if` returns value. Being able to easily define two submarines with different behavior shows the
strength of the prototype-based inheritance.

## Day 3 - LDPL

LDPL was a pleasant surprise.
It has a nice documentation with examples; it has a well-defined IO and simple data types.
The biggest disadvantage is its verbosity; you need to define a new variable and write a statement just to increase a variable by one.
The division of data and procedure is cumbersome.
Some keywords seem to be superfluous - such as `with`.
The inspiration of the old languages like `COBOL` or `BASIC` is clear, but it does not feel obsolete - probably due to the good design of data types.

The task itself was simple.
There was almost no need to work with binary numbers.
As the language of my choice did not support conversion of bases, I had to implement binary to decimal myself quite trivially.

## Day 4 - Concurnas

My first JVM language.
It is a relatively new one - form 2019.
It has a decent documentation, should be easy, right?

Concurnas is terrible; the documentation is just castles in the sky.
Half of the features that I tried did not work: tuple unpacking has different syntax; the `main` method must return void, not any type; matrix subsection fails to parse.
I wanted to try to run the code as much in parallel as possible, but it was getting stuck.
Half of the operators are different from C languages `>==`, `<>`, `and`.
There is almost non-existent support from IDEs.
Compilation and startup is so painfully slow.
When using isolates, the compilation produces lots of class files but further simplification and de-concurnation left it with the expected minimum.

The language has some good ideas though.
One being the call operator `..` that returns the receiver; this makes easy chaining.
Another if Python-like `from` imports that can also be in methods.
Overall, I think this language does not stand a chance in comparison to Kotlin.

The task would have been easy in a different language.
Were this a work day, I would have not finished yet.

## Day 5 - OSTRAJava

Since it is a Sunday, I had a bit more time to fiddle with a - non traditional - language.
OSTRAJava is a joke on a local dialect of Ostrava and the Java language.
It is well documented, supported all use cases that I needed.
Sometimes the errors from the compiler were hard to understand and missed reference to the origin of the error.
Some features are not implemented: casts, multi-dimensional arrays, `if(bul)`.
It however had a good enough file reading and number parsing function in its "standard library".
Syntax was not a big problem when the compiler tells you for the millionth time that you missed `toz` or `pyco`.

As with most of these tasks, you can solve them by brute forcing - just allocate sufficiently big array.
The task would have been more interesting if the ranges were ints.
The second part of the task was very expected and also easy to implement.

# Lists

## Language pool

- ABC
- Algol
- Assembly language
- Ballerina
- BCPL
- C#
- Closure
- CoffeeScript
- Dylan
- Elixir
- Elm
- F#
- Factor
- Fantom
- Genie
- Groovy
- Hamler
- Haxe
- Icon
- Idris
- J
- J#
- Java
- Joy
- jq
- m4
- ML
- MoonScript
- Pure
- PureScript
- ReasonML
- Scala
- Solidity
- SNOBOL
- TeX
- TypeScript
- Unison

## Used languages

- Ada
- APL
- AWK
- Bash
- (Free)Basic
- BC
- C
- C++
- Cobol
- Concurnas
- Crystal
- Ceylon
- D
- Dart
- Eiffel
- Erlang
- Forth
- Fortran
- Go
- Haskell
- Io
- JavaScript
- Julia
- Kotlin
- LDPL
- (Common)Lisp
- (UCB)Logo
- Lua
- Matlab (Octave)
- Mercury
- Minizinc
- Nim
- Objective-C
- OCaml
- OSTRAJava
- (Free)Pascal
- Perl
- PHP(7)
- PostScript
- Powershell
- (SWI)Prolog
- Python
- R
- Racket
- Raku
- Red
- Ruby
- Rust
- Sed
- SQL
- Squirrel
- Swift
- TCL
- Vala
- Vim Script
- XSLT
- Zig

## Missing letters

- Q
- U
- W
- Y

## Banned languages

- Self - does not have 64bit distribution
- XQuery - not powerful enough
- Pony - ld: unrecognised emulation mode: cx16
- Oberon - not exactly a language, it is an operating system
- Goby - Does not have documentation (404)
- Smalltalk - Could start GUI but could not do anything; poor documentation maybe
- Scratch, Snap! - Cannot be run from a command line
- Oz, Mozart - incompatible with Boost 1.7
- FoxPro - not for Linux
- ActionScript - Cannot be downloaded
