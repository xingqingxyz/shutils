$bakDir = "$PSScriptRoot\backup\configs"
Remove-Item $bakDir -Recurse -Force
$null = New-Item -Type Directory -Force $bakDir
$bakList = [System.Collections.Stack]::new()
$bakId = 0

function Backup-Files {
    foreach ($item in $bakList) {
        Copy-Item -Recurse -Force -ea Ignore $item.bakSource $bakDir\$($item.bakName)
    }
}

function Add-BakFile {
    param(
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'Path')]
        [string]$FromFile,
        [Parameter(Position = 2, ParameterSetName = 'Path')]
        [string]$ToFile = $FromFile,

        [Parameter(Mandatory, Position = 1, ParameterSetName = 'Script')]
        [scriptblock]$FromScript,
        [Parameter(Position = 2, ParameterSetName = 'Script')]
        [scriptblock]$ToScript = $FromScript
    )

    $bakSource = if ($FromFile) { $FromFile } else { "$(& $FromScript)" }
    $bakName = "${Script:bakId}-$(Split-Path -Leaf $bakSource)"
    $recoverStrategy = if ($FromFile) { 'string' } else { 'scriptblock' }
    $recoverTo = if ($ToFile) { $ToFile } else { "$ToScript" }

    $Script:bakId++
    $bakList.Push(@{
            bakSource       = $bakSource
            bakName         = $bakName
            recoverStrategy = $recoverStrategy
            recoverTo       = $recoverTo
        })
}

# pwsh
Add-BakFile { "$PROFILE\..\Microsoft.PowerShell_profile.ps1" } { "$PROFILE\.." }
Add-BakFile { "$PROFILE\..\Microsoft.VSCode_profile.ps1" } { "$PROFILE\.." }
Add-BakFile { powershell.exe -nop -c `$PROFILE } { "$(powershell.exe -nop -c `$PROFILE)\.." }

# mingw bash
Add-BakFile '~\.bashrc'
Add-BakFile '~\.bash_profile'

# git
Add-BakFile '~\.gitconfig'

# nodejs pakman
Add-BakFile '~\.npmrc'
Add-BakFile '~\.yarnrc'
Add-BakFile { "$env:LOCALAPPDATA\pnpm\config\rc" }

# pip
Add-BakFile { "$env:APPDATA\pip\pip.ini" }

# winget
Add-BakFile { "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" }

# windows terminal
Add-BakFile { "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" }

# alacritty
Add-BakFile { "$env:APPDATA\alacritty\alacritty.toml" }

# bat
Add-BakFile { "$(bat.exe --config-dir)\config" }

# power toys
Add-BakFile {
    Get-Item $PROFILE\..\..\PowerToys\Backup\settings*.ptb |
        Sort-Object { $_.LastWriteTime } |
        Select-Object -Last 1
} { "$PROFILE\..\..\PowerToys\Backup\" }

# collect info
ConvertTo-Json -InputObject $bakList | Out-File $bakDir\config-paths.json
# actually do move files
Backup-Files

# collect other info
Get-Item $PSScriptRoot\Collect-*.ps1 |
    ForEach-Object { & $_.FullName }

# need ensure backup
$ErrorActionPreference = 'Stop'

Compress-Archive -Force $PSScriptRoot\..\recover\* .\recover.zip
Compress-Archive -Update $PSScriptRoot\backup .\recover.zip
# user pkgs
Compress-Archive -Update $PSScriptRoot\..\pkgs .\recover.zip

Write-Output 'Backup finished'
