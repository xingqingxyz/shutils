_go() {
  local cmd word

  for word in "${COMP_WORDS[@]:1:COMP_CWORD-1}"; do
    cmd+="${cmd:+__}${word}"
  done
  # TODO
  mapfile -t COMPREPLY < <({
    case "$cmd" in
      help)
        compgen -W 'bug build clean doc env fix fmt generate get install list mod work run test tool version vet buildconstraint buildmode c cache envrionment filetype go.mod gopath gopath-get goproxy importpath modules module-get module-auth packages private testflag testfunc vcs' -- "$2"
        ;;
      *)
        false
        ;;
    esac || compgen -W 'bug build clean doc env fix fmt generate get install list mod work run test tool version vet' -- "$2"
  })
}

complete -o default -F _go go
