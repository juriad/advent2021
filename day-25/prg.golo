module prg

function readGrid = |fileName| {
    let content = fileToText(fileName, "UTF-8")
    let grid = vector[ vector[ c foreach c in line:split("") ] foreach line in content:split("\n") ]
    return grid
}

function step = |grid, right| {
    let next = vector[]
    let height = grid:size()

    for (var r = 0, r < height, r = r + 1) {
        let crow = grid:get(r)
        let nrow = vector[]
        next:add(nrow)
        let width = crow:size()

        for (var c = 0, c < width, c = c + 1) {
            let x = crow:get(c)
            case {
                when x == ">" {
                    if (right and grid:get(r):get( (c + 1) % width ) == ".") {
                        nrow:add(".")
                    } else {
                        nrow:add(">")
                    }
                }
                when x == "v" {
                    if (not right and grid:get( (r + 1) % height ):get(c) == ".") {
                        nrow:add(".")
                    } else {
                        nrow:add("v")
                    }
                }
                otherwise { # "."
                    if (right and grid:get(r):get( (c - 1 + width) % width ) == ">") {
                        nrow:add(">")
                    } else if (not right and grid:get( (r - 1 + height) % height):get(c) == "v") {
                        nrow:add("v")
                    } else {
                        nrow:add(".")
                    }
                }
            }
        }
    }
    return next
}

function step = |grid| {
    return step(step(grid, true), false)
}

function printGrid = |grid| {
    let s = String.join("\n", vector[ String.join("", line) foreach line in grid])
    println(s)
}

function main = |args| {
    let g0 = readGrid(args:get(0))
    var g = g0

    var s = 1
    while (true) {
        let gg = g
        g = step(g)

        # println(s)
        # printGrid(g)

        if (gg == g) {
            break
        }
        s = s + 1
    }
    println(s)
}
