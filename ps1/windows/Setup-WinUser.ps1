# pip source
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# go proxy
go env -w 'GOPROXY=https://goproxy.cn,direct'
Update-Env {
  # SHUTILS_ROOT
  $env:SHUTILS_ROOT = $PWD.Path
  # LESSOPEN
  $env:LESSOPEN = "||'${env:SHUTILS_ROOT}/scripts/lesspipe.sh' %s"
}
# pwsh PSRepository
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
# pwsh modules
Install-Module Yayaml, PSToml, Pester
# pwsh scripts
Install-Script Refresh-EnvironmentVariables
