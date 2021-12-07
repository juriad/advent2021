USING:
    kernel
    sequences pairs accessors
    strings splitting
    math math.parser math.functions math.ranges sorting
    io io.files io.encodings.ascii ascii
    command-line namespaces
    prettyprint quotations ;
IN: prg

: arg ( -- f ) 0 command-line get-global nth ;
: input ( f -- seq ) ascii file-contents [ blank? ] trim >string "," split [ string>number ] map ;
: rng ( seq -- rng ) natural-sort dup first swap last 1 <range> ;

: dist ( mode: ( a b -- c ) seq mid -- d )
    swap
    ! MODE MID SEQ
    [
    ! MODE MID ELEM
    2over swap
    ! MODE MID ELEM MID MODE
    call( a b -- c )
    ! MODE MID D
    ] map
    2nip
    sum ;

: dists ( mode: ( a b -- c ) seq -- seq )
    dup rng
    ! MODE SEQ RNG
    [
    ! MODE SEQ ELEM
    3dup
    ! MODE SEQ ELEM MODE SEQ ELEM
    dist
    ! MODE SEQ ELEM DIST
    <pair>
    ! MODE SEQ PAIR
    ] map 2nip ;

: find ( mode: ( a b -- c ) seq -- d )
    dists [ key>> ] infimum-by key>> ;

: task1 ( seq -- )
    [ - abs ] swap find number>string print ;

: task2 ( seq -- )
    [ - abs dup 1 + * 2 / ] swap find number>string print ;

: prg ( -- ) arg input dup task1 task2 ;

MAIN: prg
