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

## Day 6 - jq

I wanted to use `Pure` but that requires a different version of `LLVM` which is still compiling...
`jq` turned out to be a simple language which is quite powerful thanks to its looping / recursive constructs.
I guess it was easier to solve the task in `jq` than most other languages.
It was also handy that its `Number` is a 64 bit floating point type which represents integers precisely up to 48 bits.

The task asked for some statistical information and ti was obvious that we should not simulate each fish independently.
Since the input looked like CSV, I was fiddling with `jq` to read it.
After representing the input as a zeroth generation, I used a `while` "loop" to derive the future ones.
The task was pleasantly simple.
I was worried that the second part will be something from number theory: what are the last 5 digits of the fish count after 8000000 days.

## Day 7 - Factor

Factor is pretty nice; I like how it forces you to define the effects on the stack.
The documentation could be better - sometimes it is not clear what data type is returned, so I had to guess from the error messages.
The standard library is big and easy to search through.
It has some graphical interface, but I preferred running it from a command line was.

Today's task looked simple enough for a stack based language.
The same task had to be solved using two different metrics.
It was a bit hard to imagine what the stack looks like during two nested maps especially when extra parameters had to passed through.

## Day 8 - Scala

Scala is definitely a confusing language, there are way too many constructs.
I will need to learn it from the documentation to appreciate it more.
I like the huge number of extension methods on Maps and Arrays which allow you to express your idea in a simple way.

The task was nice - very obvious what the second part will be.
I actually implemented both parts at once, so the submission of the latter one took like a minute.
I originally wanted to use some CSP solver but hand solving and coming up with rules was faster.

## Day 9 - Dylan

Dylan has terrible documentation and project organization.
Why do I need to create a library and a project?
Half of the documentation website fails to load; documentation does not describe the syntax of the language.
It is extremely hard to find anything abut data types, operators, loops.
I suspect that it is because they are defined as macros in terms of some low-level primitives.
The documentation of OOP principles is good though.
The compiler succeeds even when the source contains errors; no idea why?
I could not do such a simple task as turning a character to a string.
The warnings are cryptic and not helpful - a missing semicolon or space is hard to find.
There should exist a plugin for Intellij, but apparently it does not anymore.

The task felt like a chose.
I hope it was because of the language.

## Day 10 - Flix

I wanted a functional language running on JVM.
Originally I was to try Eta, but that is exactly like Haskell, not just inspiration, so I ban it.
Flix is a new language developed at a university.
It has a nice syntax - it is a blend of Scala and Haskell.
The function calls and function definitions are the biggest difference.
It has a nice small standard library and decent documentation.
It misses better description of syntax.
Some functions behave differently than in the documentation (`List.fold` is not the same as `List.foldLeft`).
The syntax with namespaces looks weird - I expect all `fold` and `map` to behave the same way - the correct should be found by the parameter type.
Also, there is no documentation how to actually run a program; fortunately the source code is simple enough to find it there.

I love this task.
It was very nice to parse lines char-by-char and keep a stack -  a good match for a functional programing language.
I kept the parsing state and kept even more information because I did not know what the second part with be.
It turned out to be as simple as the first one but required different folding.

## Day 11 - SNOBOL

SNOBOL has nothing to do with COBOL.
It is pretty hard to get running; you first need to compile it.
SNOBOL has a few interesting features; I especially liked the success and failure based GOTO.
Of course conditions and loops would be better but this was something novel and the language could exploit it nicely.
The pattern matching also looks way more powerful than I needed in my implementation.
Arrays and expressions were pleasant to work with.
It also has a decent documentation.

The task was nice; it immediately called for cell automata which occur so often in Advent of Code.
I got a bit caught in optimization - I wanted to encode flashes as negative numbers and not normalize them until they are read.
This was a cause of some bugs that slowed me down.

## Day 12 - Fantom

Fantom is an interesting hybrid between Java, C# and Ruby.
It simplifies a lot of things - no need for arrays and primitive types.
It has a good documentation and its syntax is decent - all constructs are easy to use.

A nice DFS graph traversal - nothing complicated.
I originally wanted a language with built-in parallelization, but I couldn't find one that I would like.

## Day 13 - Yeti

Yeti is a cute Haskell-like language running on JVM.
Its advantage is that it provides interoperability with Java.
The syntax is pleasant; my only problem was with semicolon and the unhelpful message when one was omitted.
It has a decent and detailed documentation and a small standard library.
This is also one of few languages whose name starts with `Y`; wikipedia only knows three more.

The task was nice.
I originally planned to represent the whole paper, not just the points but the implementation was just easier this way.
My choice of a functional language also made composition of folds - ehm, folding them - simple.7
I forgot what the first task was and actually solved the second one, got a wrong submission and then realized that I was ahead of myself.

## Day 14 - JudoScript

Oh my god, another abandoned JVM language.
Half of its documentation does not work and half of the reset is TODOs.
It has interoperability with Java but I hoped that I won't need it much.
The syntax is ugly and its warning that `struct` will be removed in version 1.1 is funny.
```
JudoScript Language 0.9 2005-7-31 (JDK1.3+)
Copyright 2001-2005 James Jianbo Huang, http://www.judoscript.com
Tell your friends. Enjoy USING Java!
Java Runtime Version: 11.0.10+9
```

The task was obviously aiming for statistics about elements not simulation of the whole polymer.
I just represented all pairs of elements and kept counts of their occurrences.
This worked well; the second part just required changing the type to java's `Long`.
Luckily it was enough and I did not need to use `BigInteger`.

## Day 15 - Rexx

Another older language (keyword mainframe) which looks capable enough.
It distinguishes between functions and procedures.
Calls work with the same scope variables by default, which allows some interesting hacks.
The language does not have arrays but compound variables which behave like associative arrays.
Data types are quite vague with implicit conversions between string and number.

The task wanted to represent a grid and calculate the shortest distance.
I did not want to implement any sophisticated priority queue, so a simple one had to do.
The run time is therefore almost 3 minutes, which is still sufficient.

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
- Elixir
- Elm
- F#
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
- m4
- ML
- MoonScript
- PureScript
- ReasonML
- Solidity
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
- Dylan
- Eiffel
- Erlang
- Factor
- Fantom
- Flix
- Forth
- Fortran
- Go
- Haskell
- Io
- JavaScript
- JudoScript
- Julia
- jq
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
- Rexx
- Ruby
- Rust
- Scala
- Sed
- SNOBOL
- SQL
- Squirrel
- Swift
- TCL
- Vala
- Vim Script
- XSLT
- Yeti
- Zig

## Missing letters

- Q
- U
- W

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
- Pure - requires different version of LLVM which fails to compile
- Eta - too close to Haskell on JVM
