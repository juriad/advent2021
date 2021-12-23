var EMPTY_HALLWAY : Array<Occupant> = [None, None, None, None, None, None, None];

function div(i : Int, d : Int) : Int {
    return Std.int(i / d);
}

typedef Next = { s: State, e : haxe.Int64 }

class Prg {
    static function parseOccupant(char: String) : Occupant {
        return switch char {
            case "A": A;
            case "B": B;
            case "C": C;
            case "D": D;
            default: None;
        };
    }

    static function parseState(content: String) : State {
        var chars = content.split("\n").map((line: String) -> line.split(""));
        var occupants = [chars[2][3], chars[3][3], chars[2][5], chars[3][5], chars[2][7], chars[3][7], chars[2][9], chars[3][9]]
            .map(parseOccupant);

        return new State(occupants.concat(EMPTY_HALLWAY));
    }

    static function mapGet(m : haxe.ds.Map<Int, haxe.ds.Map<Int, Int>>, i : haxe.Int64) : Int {
        var mm = m[i.high];
        return mm == null ? null : mm[i.low];
    }

    static function mapSet(m : haxe.ds.Map<Int, haxe.ds.Map<Int, Int>>, i : haxe.Int64, v : Int) {
        var mm = m[i.high];
        if (mm == null) {
            mm = [];
            m[i.high] = mm;
        }
        mm[i.low] = v;
    }

    static public function search(initial : State, terminal : State) : Int {
        var dist = new haxe.ds.Map<Int, haxe.ds.Map<Int, Int>>();
        var queue = new List<Next>();

        var dia = new Diagram(initial.size());

        var visited = 0;
        var unique = 0;

        var ini = initial.encode();
        queue.add({s: initial, e: ini});
        mapSet(dist, ini, 0);

        while (!queue.isEmpty()) {
            var c = queue.pop();
            visited++;

            if (visited % 1000 == 0) {
                trace('${queue.length} $visited $unique ${c.s}');
            }

            for (m in dia.moves(c.s)) {
                var t = m.to.encode();
                var ndist = mapGet(dist, c.e) + m.dist;
                var cdist = mapGet(dist, t);
                if (cdist == null || ndist < cdist) {
                    // trace('Better $ndist than $cdist');

                    if (cdist == null) {
                        unique++;
                    }

                    mapSet(dist, t, ndist);
                    queue.add({s: m.to, e: t});
                }
            }
        }

        var ter = terminal.encode();
        return mapGet(dist, ter);
    }

    static function terminal(size : Int) : State {
        var s = [];
        for (o in [A, B, C, D]) {
            for (i in 0 ... size) {
                s.push(o);
            }
        }
        return new State(s.concat(EMPTY_HALLWAY));
    }

    static function extendInitial(state : State) : State {
        var o = state.occupants.copy();
        o.insert(1, D);
        o.insert(2, D);
        o.insert(5, C);
        o.insert(6, B);
        o.insert(9, B);
        o.insert(10, A);
        o.insert(13, A);
        o.insert(14, C);
        return new State(o);
    }

    static public function main():Void {
        var args = Sys.args();
        var fileName = args[0];
        var content: String = sys.io.File.getContent(fileName);
        var initial2 = parseState(content);
        var terminal2 = terminal(2);

        var distance2 = search(initial2, terminal2);
        trace(distance2);
/*
        var initial4 = extendInitial(initial2);
        var terminal4 = terminal(4);

        var distance4 = search(initial4, terminal4);
        trace(distance4);
*/
    }
}

enum Occupant {
    None; A; B; C; D;
}

class State {
    public var occupants: Array<Occupant>;

    public function new(occupants: Array<Occupant>) {
        this.occupants = occupants;
    }

    public function toString() {
        return occupants.toString();
    }

    public function encode() : haxe.Int64 {
        var len = occupants.length;
        var sz = size();

        var os = occupants.copy();
        var e = new Array<Int>();
        for (o in [A, B, C, D]) {
            for (i in 0 ... sz) {
                e.push(os.indexOf(o));
                os.remove(o);
            }
        }

        var s : haxe.Int64 = 0;
        for (i in 0 ... e.length) {
            s = s * (len - i) + e[i];
        }

        return s;
    }

    public function swap(from: Int, to: Int) : State {
        var o = occupants.copy();
        var t = o[from];
        o[from] = o[to];
        o[to] = t;
        return new State(o);
    }

    public function size() : Int {
        return div(occupants.length - EMPTY_HALLWAY.length, 4);
    }
}

typedef Destination = { dist : Int, through : Array<Int> }
typedef Move = { to : State, dist: Int }

class Diagram {
    var neighbors : Array<Map<Int, Destination>>;

    public function new(size : Int) {
        neighbors = [
            for (c in 0 ... size * 4)
            [
                for (i in 0 ... EMPTY_HALLWAY.length)
                    4 * size + i => if (i <= div(c, size) + 1)
                        {
                            dist: c % size + (div(c, size) + 2 - i) * 2 + (i == 0 ? -1 : 0),
                            through: [ for ( t in 0 ... c % size) c - c % size + t]
                                .concat([for (t in 4 * size + i + 1 ... 4 * size + div(c, size) + 2) t ])
                        }
                    else
                        {
                            dist: c % size + (i - div(c, size) - 1) * 2 + (i == EMPTY_HALLWAY.length - 1 ? -1 : 0),
                            through: [ for ( t in 0 ... c % size) c - c % size + t]
                                .concat([ for (t in 4 * size + div(c, size) + 2 ... 4 * size + i) t ])
                        }
            ]
        ];

        /*
        for (i in 0 ... 4*size) {
            for (j in 4*size ... 4*size+7) {
                trace( 'from $i to $j: ${neighbors[i][j]}');
            }
        }
        */

        for (i in 4*size ... 4*size + EMPTY_HALLWAY.length) {
            neighbors[i] = [
                for (j in 0 ... 4 * size)
                    j => neighbors[j][i]
            ];
        }
    }

    static function energy(o : Occupant) : Int {
        return switch o {
            case A: 1;
            case B: 10;
            case C: 100;
            case D: 1000;
            case None: 0;
        };
    }

    public function moves(state : State) : Array<Move> {
        var moves = new Array<Move>();

        for (i in 0 ... state.occupants.length) {
            var e = energy(state.occupants[i]);

            if (state.occupants[i] != None) {
                for (n in neighbors[i].keys()) {
                    var dest = neighbors[i][n];

                    if (canMoveTo(state, i, n, dest.through)) {
                        var s = state.swap(i, n);
                        moves.push({to: s, dist: dest.dist * e});
                        // trace('Considering move of ${state.occupants[i]} from $i to $n');
                    }
                }
            }
        }

        return moves;
    }

    function canMoveTo(state: State, from: Int, to: Int, through: Array<Int>) {
        if (state.occupants[to] != None) {
            return false;
        }

        var size = state.size();

        var f = state.occupants[from];
        if (to < size * 4) {
            switch f {
                case A: if (div(to, size) != 0) return false;
                case B: if (div(to, size) != 1) return false;
                case C: if (div(to, size) != 2) return false;
                case D: if (div(to, size) != 3) return false;
                case None: trace("Error");
            }
            for (i in (to % size + 1) ... size) {
                if (state.occupants[to - to % size + i] != f) return false;
            }
        }

        for (t in through) {
            if (state.occupants[t] != None) {
                return false;
            }
        }
        return true;
    }
}
