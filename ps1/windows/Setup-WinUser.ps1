# SHUTILS_ROOT
$env:SHUTILS_ROOT = $PWD.Path
[System.Environment]::SetEnvironmentVariable('SHUTILS_ROOT', $env:SHUTILS_ROOT, 'User')
# LESSOPEN
$env:LESSOPEN = "||'${env:SHUTILS_ROOT}/scripts/lesspipe.sh' %s"
[System.Environment]::SetEnvironmentVariable('LESSOPEN', $env:LESSOPEN, 'User')
# pip source
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# go proxy
go env -w 'GOPROXY=https://goproxy.cn,direct'
# rust proxy and other envs
Update-Env {
  # misc
  # $env:EDITOR = 'nvim'
  $env:PAGER = 'less'
  $env:LESS = '--quit-if-one-screen --use-color --wordwrap --mouse --ignore-case --incsearch --search-options=W -R'

  # rustup
  # $env:RUSTUP_UPDATE_ROOT = 'https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup'
  # $env:RUSTUP_DIST_SERVER = 'https://mirrors.tuna.tsinghua.edu.cn/rustup'

  # proxy
  $env:no_proxy = '127.0.0.1,localhost,internal.domain,kkgithub.com,mirror.sjtu.edu.cn,mirrors.tuna.tsinghua.edu.cn,mirrors.ustc.edu.cn,gitdl.cn'
}
# pwsh PSRepository
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
# pwsh modules
Install-Module Yayaml, PSToml, PSWindowsUpdate, Pester
# pwsh scripts
Install-Script Refresh-EnvironmentVariables
