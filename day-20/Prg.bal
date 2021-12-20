import ballerina/io;

class Image {
    boolean[] enhancement;
    boolean[][] grid;
    boolean def;

    function init(boolean[] enhancement, boolean[][] grid, boolean def) {
        self.enhancement = enhancement;
        self.grid = grid;
        self.def = def;
    }

    private function px(int r, int c) returns int {
        if (r < 0 || r >= self.grid.length()) {
            return self.def ? 1 : 0;
        }
        if (c < 0 || c >= self.grid[r].length()) {
            return self.def ? 1 : 0;
        }
        return self.grid[r][c] ? 1 : 0;
    }

    private function enhancePx(int r, int c) returns boolean {
        int i = (self.px(r-1, c-1) << 8) + (self.px(r-1, c) << 7) + (self.px(r-1, c+1) <<6)
                + (self.px(r+0, c-1) << 5) + (self.px(r+0, c) << 4) + (self.px(r+0, c+1) <<3)
                + (self.px(r+1, c-1) << 2) + (self.px(r+1, c) << 1) + (self.px(r+1, c+1) <<0);
        return self.enhancement[i];
    }

    function enhance() returns Image {

        // To trigger java.util.ConcurrentModificationException in the compiler
        // comment out the next 10 lines and uncomment the next 4 instead
        boolean extendLeft = true || self.grid
            .map(function(boolean[] row) returns boolean { return row[0]; })
            .reduce(function(boolean acc, boolean b) returns boolean { return acc || b; }, false);
        boolean extendRight = true || self.grid
            .map(function(boolean[] row) returns boolean { return row[row.length() - 1]; })
            .reduce(function(boolean acc, boolean b) returns boolean { return acc || b; }, false);
        boolean extendUp = true || self.grid[0]
            .reduce(function(boolean acc, boolean b) returns boolean { return acc || b; }, false);
        boolean extendDown = true || self.grid[self.grid.length() - 1]
            .reduce(function(boolean acc, boolean b) returns boolean { return acc || b; }, false);

        // boolean extendLeft = true;
        // boolean extendRight = true;
        // boolean extendUp = true;
        // boolean extendDown = true;

        boolean[][] next = [];

        int dc = extendUp ? 1 : 0;
        int nh = self.grid.length() + dc + (extendDown ? 1 : 0);
        int dr = extendLeft ? 1 : 0;
        int nw = self.grid.length() + dr + (extendRight ? 1 : 0);
        foreach var r in 0 ..< nh {
            next[r] = [];
            foreach var c in 0 ..< nw {
                next[r][c] = self.enhancePx(r - dr, c - dc);
            }
        }

        return new Image(self.enhancement, next, self.def ? self.enhancement[511] : self.enhancement[0]);
    }

    function toString() returns string {
        return string:'join("\n", ...self.grid.map(function(boolean[] row) returns string {
            return string:concat(...row.map(function(boolean b) returns string {
                return b ? "#" : ".";
            }));
        }));
    }

    function lit() returns int {
        return self.grid.reduce(function(int acc, boolean[] row) returns int {
            return acc + row.reduce(function(int a, boolean b) returns int {
                return a + (b ? 1 : 0);
            }, 0);
        }, 0);
    }
}

function readInput(string fileName) returns Image|error {
     string[] lines = check io:fileReadLines(fileName);

     int? gap = lines.indexOf("");
     if (gap == ()) {
        return error("no gap found");
     } else {
        string e = string:concat(...lines.slice(0, gap));
        boolean[] enhancement = e.toBytes()
            .map(function(byte b) returns boolean {
                return b == 35;
            });

        boolean[][] grid = lines.slice(gap + 1, lines.length())
            .map(function(string line) returns boolean[] {
                return line.toBytes().map(function(byte b) returns boolean {
                    return b == 35;
                });
            });

        return new Image(enhancement, grid, false);
     }
}

public function main(string fileName) returns ()|error {
    io:println(fileName);
    Image i0 = check readInput(fileName);
    Image i = i0;

    foreach var s in 1 ... 50 {
        i = i.enhance();
        if (s == 2 || s == 50) {
            io:println(i.lit());
        }
    }
}
