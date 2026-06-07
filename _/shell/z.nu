export-env {
    $env.z_config = {
        data_file: ("~/.z.json" | path expand)
        max_history: 1000
        filter_hook: { $in != $nu.home-dir and $"($in)(char path_sep)" not-starts-with $"($nu.temp-dir)(char path_sep)" and ($in | path split | length) > 1 }
    }
    $env.config.hooks.env_change = $env.config.hooks.env_change | upsert PWD {
        # default [] | append {|before, after| if $before != $after { add $after } }
        [{|before, after| if $before != $after { add $after } }]
    }
 }

def load_data []: nothing -> record {
    let items = open $env.z_config.data_file
    $items | reduce --fold {} {|i, acc| $i | wrap $i.path | merge $acc }
}

def dump_data []: record -> nothing {
    values | save --force $env.z_config.data_file
}

def add [...paths: string] {
    let paths = $paths | each { try { path expand --strict } } | where $env.z_config.filter_hook
    if ($paths | is-empty) {
        return
    }
    let items_map = load_data
    let now = date now | format date %s | into int
    let items_map = $paths | reduce --fold $items_map {|path, acc|
        if $path not-in $acc {
            $acc | insert $path { rank: 1.0, time: $now, path: $path }
        } else {
            $acc | update $path { merge { rank: ($in.rank + 1.0), time: $now } }
        }
    }
    let rank_sum = $items_map | values | get rank | math sum
    let items_map = if $rank_sum > $env.z_config.max_history {
        $items_map | values | reduce --fold $items_map {|item, acc|
            let item = $item | update rank {|rank| $rank * 0.99 }
            if $item.rank > 1.0 {
                $acc | reject $item.path
            } else {
                $acc | update $item.path $item
            }
        }
    } else $items_map
    $items_map | dump_data
}

export def --env main [
    ...queries: string
    --list (-l)
    --rank (-r)
    --time (-t)
    --cwd (-c)
] {
    let items_map = load_data
    let re_query = $queries | if $nu.os-info.name == 'windows' {
        str replace --all / \\
    } else $in | str join .* | $"^.*($in).*$"
    let paths = $items_map | columns | where $it =~ $re_query | if $cwd {
        where $it starts-with $"($env.PWD)(char path_sep)"
    } else $in
    if ($paths | is-empty) {
        if ($queries | is-not-empty) and ($queries | last) =~ '[\\/]' {
            $queries | last | cd $in
        } else {
            use std/log
            log warning $"no matches for regexp ($re_query)"
        }
        return
    }
    # FIXME: no collect
    let items = $paths | each {|path| $items_map | get $path } | collect | if $rank {
        sort-by --reverse rank
    } else if $time {
        sort-by --reverse time
    } else {
        let now = date now | format date %s | into int
        $in | sort-by --reverse { 10_000 * $in.rank * (3.75 / (0.0001 * ($now - $in.time) + 1.25)) }
    }
    if $list {
        return $items
    }
    mut paths_to_drop = []
    for item in $items {
        if ($item.path | path type) == dir {
            cd $item.path
            break
        }
        use std/log
        log warning $"directory not exist, removing it: ($item.path)"
        $paths_to_drop ++= $item.path
    }
    if ($paths_to_drop | is-not-empty) {
        let items_map = $paths_to_drop | reduce --fold $items_map {|path, acc| $acc | reject $path }
        $items_map | dump_data
    }
}
