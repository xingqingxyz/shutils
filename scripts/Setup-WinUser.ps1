# pip source
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# go proxy
go env -w GOPROXY=https://goproxy.cn`,direct
# rust proxy and other envs
& $PSScriptRoot/Set-UserEnv.ps1
