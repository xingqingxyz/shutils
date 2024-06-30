<#
.NOTES
This command cannot overwrite existing environment variables.
 #>

function updateEnv {
  param([hashtable]$prevEnv)
  $processEnv = [System.Environment]::GetEnvironmentVariables()

  foreach ($key in $processEnv.Keys) {
    $value = $processEnv.$key
    if (!$prevEnv.ContainsKey($key) -or $prevEnv.$key -ne $value) {
      [System.Environment]::SetEnvironmentVariable($key, $value, 'User')
    }
  }
}

$prevEnv = [System.Environment]::GetEnvironmentVariables()
$env:EDITOR = 'nvim'
$env:PAGER = 'less'
$env:LESS = '-R --quit-if-one-screen --use-color --wordwrap --mouse --ignore-case --incsearch --search-options=W'
$env:BAT_THEME = ''

# rustup
$env:RUSTUP_UPDATE_ROOT = 'https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup'
$env:RUSTUP_DIST_SERVER = 'https://mirrors.tuna.tsinghua.edu.cn/rustup'

# proxy
$env:no_proxy = '127.0.0.1,localhost,internal.domain,kkgithub.com,mirror.sjtu.edu.cn,mirrors.tuna.tsinghua.edu.cn,mirrors.ustc.edu.cn,gitdl.cn'

# oh-my-posh
$env:POSH_THEME = "${env:POSH_THEMES_PATH}/1_shell.omp.json"
updateEnv $prevEnv
