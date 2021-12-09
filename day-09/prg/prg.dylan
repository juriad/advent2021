Module: prg

define function read-file(file-name :: <string>) => (content :: <string>)
    let fs = make(<file-stream>, locator: file-name, element-type: <character>);
    block (r)
        let content = read-to-end(fs);
        r(content);
    cleanup
        if (fs) close(fs) end;
    end block;

end function;

define class <cave> (<object>)
    slot m :: <list>, required-init-keyword: map:;
    slot width :: <integer>, required-init-keyword: w:;
    slot height :: <integer>, required-init-keyword: h:;
end class <cave>;

define class <position> (<object>)
    slot row :: <integer>, required-init-keyword: row:;
    slot col :: <integer>, required-init-keyword: col:;
end class <position>;

define function read-cave(content :: <string>) => (cave :: <cave>)
    let lines = split-lines(content, remove-if-empty?: #t);

    let m = map(method (line)
        let l = make(<list>);
        for (j :: <integer> from 0 to size(line) - 1)
            l := add(l, string-to-integer(copy-sequence(line, start: j, end: j + 1)));
        end;
        l
    end, lines);

    let cave = make(<cave>, map: m, w: size(element(m, 0)), h: size(m));
    cave
end function;

define function count-risk(cave :: <cave>) => (risk :: <integer>, positions :: <deque>)
    let risk = 0;
    let positions = make(<deque>);
    for (r :: <integer> from 0 to cave.height - 1)
        for (c :: <integer> from 0 to cave.width - 1)
            let cur = element(element(cave.m, r), c);
            let cnt = 0;
            if (r > 0)
                let up = element(element(cave.m, r - 1), c);
                if (up <= cur)
                    cnt := cnt + 1;
                end if;
            end if;
            if (c > 0)
                let left = element(element(cave.m, r), c - 1);
                if (left <= cur)
                    cnt := cnt + 1;
                end if;
            end if;
            if (r < cave.height - 1)
                let down = element(element(cave.m, r + 1), c);
                if (down <= cur)
                    cnt := cnt + 1;
                end if;
            end if;
            if (c < cave.width - 1)
                let right = element(element(cave.m, r), c + 1);
                if (right <= cur)
                    cnt := cnt + 1;
                end if;
            end if;

            if (cnt = 0)
                risk := risk + cur + 1;
                positions := add(positions, make(<position>, row: r, col: c));
            end if;
        end;
    end;
    values(risk, positions)
end function;

define function mark-basins(cave :: <cave>, positions :: <deque>) => (basins :: <table>)
    let basins = make(<table>);

    for (i :: <integer> from 0 to size(positions) - 1)
        let pos = element(positions, i);
        element-setter(i + 1000000, element(cave.m, pos.row), pos.col);
        element-setter(0, basins, i + 1000000);
    end;

    while (size(positions) > 0)
        let pos = pop(positions);
        let cur = element(element(cave.m, pos.row), pos.col);
        element-setter(element(basins, cur) + 1, basins, cur);

        if (pos.row > 0)
            let up = element(element(cave.m, pos.row - 1), pos.col);
            if (up < 9)
                element-setter(cur, element(cave.m, pos.row - 1), pos.col);
                push-last(positions, make(<position>, row: pos.row - 1, col: pos.col));
            end if;
        end if;
        if (pos.col > 0)
            let left = element(element(cave.m, pos.row), pos.col - 1);
            if (left < 9)
                element-setter(cur, element(cave.m, pos.row), pos.col - 1);
                push-last(positions, make(<position>, row: pos.row, col: pos.col - 1));
            end if;
        end if;
        if (pos.row < cave.height - 1)
            let down = element(element(cave.m, pos.row + 1), pos.col);
            if (down < 9)
                element-setter(cur, element(cave.m, pos.row + 1), pos.col);
                push-last(positions, make(<position>, row: pos.row + 1, col: pos.col));
            end if;
        end if;

        if (pos.col < cave.width - 1)
            let right = element(element(cave.m, pos.row), pos.col + 1);
            if (right < 9)
                element-setter(cur, element(cave.m, pos.row), pos.col + 1);
                push-last(positions, make(<position>, row: pos.row, col: pos.col + 1));
            end if;
        end if;
    end;

    basins
end function;

define function main(name :: <string>, arguments :: <vector>)
    let file-name = element(arguments, 0);
    let content = read-file(file-name);
    let cave = read-cave(content);
    let (risk, positions) = count-risk(cave);
    let basins = mark-basins(cave, positions);

    format-out("%d\n", risk);

    let sizes = make(<list>);
    for (value keyed-by key in basins)
        sizes := add(sizes, value);
        // format-out("%d, %d\n", key, value);
    end;
    sizes := sort(sizes, test: \>);

    format-out("%d\n", element(sizes, 0) * element(sizes, 1) * element(sizes, 2));

    exit-application(0);
end function main;

main(application-name(), application-arguments());
