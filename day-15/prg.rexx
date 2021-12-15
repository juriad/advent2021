fn = arg(1)
say fn
call read_map fn

say width height
call search

call enlarge_map 5
call search

exit

read_map: procedure expose map. width height
    parse arg fn

    map. = 1000000
    width = 0
    height = 0

    row = 1
    col = 1
    do while chars(fn) > 0
        c = charin(fn)

        if (c == "0A"x) then
        do
            height = MAX(height, row)
            row = row + 1
            col = 1
        end
        else
        do
            width = MAX(width, col)
            map.row.col = +c
            dist.row.col = 1000000
            col = col + 1
        end
    end

    return

enlarge_map: procedure expose map. width height
    parse arg times
    do row = 1 to height
        do col = 1 to width
            m = map.row.col
            do rx = 0 to times - 1
                do ry = 0 to times - 1
                    mm = m + rx + ry
                    rr = row + rx * height
                    cc = col + ry * width
                    map.rr.cc = (mm - 1) // 9 + 1
                end
            end
        end
    end

    width = width * times
    height = height * times

    return

search: procedure expose map. width height
    q.0.1 = 1
    q.0.2 = 1

    dist. = 1000000
    dist.1.1 = 0
    call q_push 1 1

    do while (q_size() > 0)
        /* say q_size() */

        point = q_pop()
        parse var point row col

        rm = row - 1
        rp = row + 1
        cm = col - 1
        cp = col + 1

        d = dist.row.col

        call q_push_next d rm col
        call q_push_next d rp col
        call q_push_next d row cm
        call q_push_next d row cp
    end

    say dist.width.height

    return

q_push_next: procedure expose q. map. dist.
    parse arg d row col

    alt = d + map.row.col
    if (alt < dist.row.col) then
    do
        dist.row.col = alt
        call q_push row col
    end

    return

q_push: procedure expose q.
    parse arg x y
    e = q.0.2 /* points after last */

    q.e.1 = x
    q.e.2 = y

    e = e + 1
    q.0.2 = e

    return

q_size: procedure expose q.
    s = q.0.1
    e = q.0.2

    return e - s

q_pop: procedure expose q.
    s = q.0.1 /* points at first */

    x = q.s.1
    y = q.s.2

    drop q.s.

    s = s + 1
    q.0.1 = s

    return x y
