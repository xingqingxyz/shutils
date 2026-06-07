def _fzf_ident [] {
    let args = [
        '-1'
        -m
        --reverse
        $"--height=($env.FZF_BIND_HEIGHT? | default '-40%')"
        '--bind=ctrl-z:ignore'
    ]
    use std/config
    let out = config flatten | columns | to text | fzf ...$args
    if $out == null {
        return
    }
    commandline edit --insert $"$env.config.($out)"
}

$env.config.menus ++= [
    {
        name: vars_menu
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: list
            page_size: 100
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: {|buffer, position|
            scope variables
            | where name =~ $buffer
            | sort-by name
            | each {|row| {value: $row.name description: $row.type} }
        }
    }
    {
        name: config_menu
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: list
            page_size: 100
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: {|buffer, position|
            config flatten
            | columns
            | where $it =~ $buffer
            | each {|row| {value: $"$env.config.($row)"} }
        }
    }
]

$env.config.keybindings ++= [
    {
        name: forward_word
        modifier: control
        keycode: char_f
        mode: [emacs]
        event: {
            until: [
                { send: HistoryHintWordComplete }
                { send: MenuRight }
                { send: Right }
            ]
        }
    }
    {
        name: prepend_delay
        modifier: alt_shift
        keycode: char_d
        mode: [emacs]
        event: [
            {
                edit: MoveToStart
            }
            {
                edit: InsertString
                value: 'job spawn { sleep 12min; '
            }
            {
                edit: MoveToEnd
            }
            {
                edit: InsertString
                value: ' }'
            }
            { send: Enter }
        ]
    }
    {
        name: fzf_ident
        modifier: alt
        keycode: char_o
        mode: [emacs]
        event: {
            send: ExecuteHostCommand
            cmd: _fzf_ident
        }
    }
    {
        name: prepend_sudo
        modifier: alt
        keycode: char_s
        mode: [emacs]
        event: [
            {
                edit: MoveToStart
            }
            {
                edit: InsertString
                value: 'sudo '
            }
            { send: Enter }
        ]
    }
    # menus
    {
        name: vars_menu
        modifier: alt
        keycode: char_c
        mode: [emacs]
        event: { send: menu name: config_menu }
    }
    {
        name: vars_menu
        modifier: alt
        keycode: char_v
        mode: [emacs]
        event: { send: menu name: vars_menu }
    }
]

