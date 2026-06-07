const NU_LIB_DIRS = [
    (path self | path expand | path dirname)
]

source completion.nu
source keybindings.nu
source prompt.nu
overlay use z.nu

alias cls = clear
alias e = edit
alias l = ls

$env.config.completions.algorithm = 'fuzzy'
$env.config.show_banner = false
$env.config.menus ++= [
    {
        name: history_menu
        only_buffer_difference: false
        marker: "? "
        type: {
            layout: list
            page_size: 100
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
    }
]
$env.config.hooks.display_output = 'table'
