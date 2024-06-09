$ErrorActionPreference = 'Stop'

Get-ChildItem $PSScriptRoot -Exclude $MyInvocation.MyCommand.Name |
    Compress-Archive -DestinationPath linux.zip
Compress-Archive -Update $PSScriptRoot/../pkgs linux.zip

Write-Output 'Backup finished'
