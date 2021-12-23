uses gw.lang.Gosu
uses java.io.BufferedReader
uses java.io.FileReader
uses java.util.Scanner

var args = Gosu.RawArgs

class Rng {
    var _min : int as readonly Min
    var _max : int as readonly Max

    construct(min : int, max : int) {
        _min = min
        _max = max
    }

    override function toString() : String {
        return "${_min}..${_max}"
    }

    function overlaps(other : Rng) : boolean {
        return !(other.Max < _min || other.Min > _max)
    }

    property get Size() : int {
        return _max - _min + 1
    }
}

class Command {
    var _on : boolean as readonly On
    var _x : Rng as readonly X
    var _y : Rng as readonly Y
    var _z : Rng as readonly Z

    construct(on : boolean, x : Rng, y : Rng, z : Rng) {
        _on = on
        _x = x
        _y = y
        _z = z
    }

    override function toString() : String {
        return "${_on} x=${_x},y=${_y},z=${_z}"
    }
}

interface SplitMapper<V> {
    function map(original : V) : V
}

interface SplitFolder<V, W> {
    function mapLeaf(rng : Rng, value : V) : W
}

interface SplitCombiner<W> {
    function combine(a : W, b : W) : W
}

class Split<V> {
    var _rng : Rng as readonly Rng

    // either
    var _left : Split<V> as readonly Left
    var _right : Split<V> as readonly Right

    // or
    var _value : V as readonly Value

    construct(rng : Rng, left : Split<V>, right : Split<V>, value : V) {
        _rng = rng
        _left = left
        _right = right
        _value = value
    }

    function split(rng : Rng, mapper : SplitMapper<V>) : Split<V> {
        if (_value != null) {
            if (rng.Min > _rng.Min) {
                if (rng.Max < _rng.Max) {
                    // two splits
                    return new Split(
                        _rng,
                        new Split(new Rng(_rng.Min, rng.Min - 1), null, null, _value), // before
                        new Split(
                            new Rng(rng.Min, _rng.Max),
                            new Split(rng, null, null, mapper.map(_value)),
                            new Split(new Rng(rng.Max + 1, _rng.Max), null, null, _value), // after
                            null
                        ),
                        null
                    )
                } else {
                    // one split - starts later
                    return new Split(
                        _rng,
                        new Split(new Rng(_rng.Min, rng.Min - 1), null, null, _value), // before
                        new Split(new Rng(rng.Min, _rng.Max), null, null, mapper.map(_value)),
                        null
                    )
                }
            } else {
                if (rng.Max < _rng.Max) {
                    // one split - end earlier
                    return new Split(
                        _rng,
                        new Split(new Rng(_rng.Min, rng.Max), null, null, mapper.map(_value)),
                        new Split(new Rng(rng.Max + 1, _rng.Max), null, null, _value), // after
                        null
                    )
                } else {
                    // no split - this internal is covered
                    return new Split(_rng, null, null, mapper.map(_value))
                }
            }
        } else {
            return new Split(
                _rng,
                _left.Rng.overlaps(rng) ? _left.split(rng, mapper) : _left,
                _right.Rng.overlaps(rng) ? _right.split(rng, mapper) : _right,
                null
            )
        }
    }

     function fold<W>(folder : SplitFolder<V, W>, combiner : SplitCombiner<W>) : W {
        if (_value != null) {
            return folder.mapLeaf(_rng, _value)
        } else {
            return combiner.combine(_left.fold<W>(folder, combiner), _right.fold<W>(folder, combiner))
        }
    }

    override function toString() : String {
        if (_value != null) {
            return "<${_rng} ${_value}>"
        } else {
            return "<${_left} ${_right}>"
        }
    }
}

class SplitSpace {
    var ALL = new Rng(Integer.MIN_VALUE, Integer.MAX_VALUE)
    var _split : Split<Split<Split<Boolean>>> =
        new Split(ALL, null, null,
            new Split(ALL, null, null,
                new Split(ALL, null, null, false)))

    function apply(command : Command) {
//        var rng = new Rng(-50, 50)
//        if (!rng.overlaps(command.X) || !rng.overlaps(command.Y) || !rng.overlaps(command.Z)) {
//            return
//        }

        _split = _split.split(command.X, \ sx ->
            sx.split(command.Y, \ sy ->
                sy.split(command.Z, \ sz ->
                    command.On)))
    }

    property get Count() : long {
        var sum = \ a : Long, b : Long -> a + b

        return _split.fold( \ xrng, xval ->
            xval.fold( \ yrng, yval ->
                yval.fold( \ zrng, zval ->
                    zval ? 1L * xrng.Size * yrng.Size * zrng.Size : 0L
                    , sum
                )
                , sum
            )
            , sum
        )
    }
}

class Space {
    var space = new boolean[101][101][101]
    var dx = 50
    var dy = 50
    var dz = 50

    function apply(command : Command) {
        var rng = new Rng(-50, 50)
        if (!rng.overlaps(command.X) || !rng.overlaps(command.Y) || !rng.overlaps(command.Z)) {
            return
        }

        for (x in command.X.Min .. command.X.Max) {
            for (y in command.Y.Min .. command.Y.Max) {
                for (z in command.Z.Min .. command.Z.Max) {
                    space[x + dx][y + dy][z + dz] = command.On
                }
            }
        }
    }

    property get Count() : int {
        var cnt = 0
        for (x in 0 ..| space.length) {
            for (y in 0 ..| space[x].length) {
                for (z in 0 ..| space[x][y].length) {
                    if (space[x][y][z]) {
                        cnt++
                    }
                }
            }
        }
        return cnt
    }
}

function parseRng(str : String) : Rng {
    var nx = str.split("\\.\\.")
    var min = Integer.parseInt(nx[0])
    var max = Integer.parseInt(nx[1])
    return new Rng(min, max)
}

function parseCommand(line : String) : Command {
    var ht = line.split(" ");
    var on = ht[0] == "on"
    var xyz = ht[1].split(",")
    var x = parseRng(xyz[0].substring(2))
    var y = parseRng(xyz[1].substring(2))
    var z = parseRng(xyz[2].substring(2))
    return new Command(on, x, y, z)
}

var commands : List<Command> = {}
using (var scanner = new Scanner(new BufferedReader(new FileReader(args[0])))) {
    while (scanner.hasNext()) {
        var command = parseCommand(scanner.nextLine())
        commands.add(command)
    }
}

// print(commands)
var space = new Space()
for (command in commands) {
    space.apply(command)
}
print(space.Count)

var splitSpace = new SplitSpace()
for (command in commands) {
    splitSpace.apply(command)
}
print(splitSpace.Count)
