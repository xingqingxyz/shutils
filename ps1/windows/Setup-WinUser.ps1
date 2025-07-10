# pip source
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# go proxy
go env -w 'GOPROXY=https://goproxy.cn,direct'
# envs
Update-Env -Scope User @{
  SHUTILS_ROOT = $PWD.Path
  LESSOPEN     = "||'${env:SHUTILS_ROOT}\scripts\lesspipe.sh' %s"
}
# shutils scripts
$userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
if (!";$userPath;".Contains(";${env:SHUTILS_ROOT}\scripts;")) {
  [System.Environment]::SetEnvironmentVariable('Path', ($userPath, "${env:SHUTILS_ROOT}\scripts" -join ';') , 'User')
}
$userPath = [System.Environment]::GetEnvironmentVariable('PSModulePath', 'User')
# shutils modules
if (!";$userPath;".Contains(";${env:SHUTILS_ROOT}\ps1\modules;")) {
  [System.Environment]::SetEnvironmentVariable('PSModulePath', ("${env:SHUTILS_ROOT}\ps1\modules", $userPath -join ';') , 'User')
}
# pwsh PSRepository
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
# pwsh modules
Install-Module Yayaml, PSToml, Pester
# pwsh scripts
Install-Script Refresh-EnvironmentVariables
