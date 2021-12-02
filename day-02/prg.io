Submarine := Object clone

Submarine horiz := 0
Submarine depth := 0
Submarine position := method("horiz=#{horiz}, depth=#{depth}; h*d=#{horiz*depth}" interpolate)

DumbSubmarine := Submarine clone
DumbSubmarine forward := method(amount, horiz = horiz + amount)
DumbSubmarine down := method(amount, depth = depth + amount)
DumbSubmarine up := method(amount, depth = depth - amount)


AimSubmarine := Submarine clone
AimSubmarine aim := 0
AimSubmarine forward := method(amount, horiz = horiz + amount; depth = depth + amount * aim)
AimSubmarine down := method(amount, aim = aim + amount)
AimSubmarine up := method(amount, aim = aim - amount)


Command := Object clone
Command amount ::= 0

Forward := Command clone
Forward apply := method(sub, sub forward(amount))
forward := method(amount, Forward clone setAmount(amount))

Down := Command clone
Down apply := method(sub, sub down(amount))
down := method(amount, Down clone setAmount(amount))

Up := Command clone
Up apply := method(sub, sub up(amount))
up := method(amount, Up clone setAmount(amount))


f := File with(System args at(1))
f openForReading
commands := f readLines map(line,
    ca := line split
    c := ca at(0)
    a := ca at(1) asNumber
    if(c == "forward", forward(a), if(c=="down", down(a), up(a)))
)
f close

sub1 := DumbSubmarine clone
commands foreach(c, c apply(sub1))
sub1 position println

sub2 := AimSubmarine clone
commands foreach(c, c apply(sub2))
sub2 position println
