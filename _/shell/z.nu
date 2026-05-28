def _fzf_ident [] {
    let args = [
        '-1'
        -m
        --reverse
        $"--height=($env.FZF_BIND_HEIGHT? | default '-40%')"
        '--bind=ctrl-z:ignore'
    ]
    use std/config
    let out = config flatten | columns | fzf ...$args
    if $out == null {
        return
    }
    commandline edit --insert $out
}
