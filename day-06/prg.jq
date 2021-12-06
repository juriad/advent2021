[
    rtrimstr("\n")
    | split(",")
    | group_by(.)[]
    | { key: ("a" + .[0]), value: (. | length) }
    ,
    {key: "gen", value: 0}
] | from_entries
| while(.gen <= 256;
    {
        "gen": (.gen + 1),
        "a0": (.a1 // 0),
        "a1": (.a2 // 0),
        "a2": (.a3 // 0),
        "a3": (.a4 // 0),
        "a4": (.a5 // 0),
        "a5": (.a6 // 0),
        "a6": ((.a7 // 0) + (.a0 // 0)),
        "a7": (.a8 // 0),
        "a8": (.a0 // 0)
    }
) | {
    gen: .gen,
    fish: (
        to_entries
        | map(select (.key != "gen") | .value)
        | reduce .[] as $item (0; . + $item)
    )
} | select(.gen == 80 or .gen == 256)
