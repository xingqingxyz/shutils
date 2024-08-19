Configuration MtSetupConfig {
  # Import the module that contains the Registry DSC Resource.
  Import-DscResource -ModuleName PSDscResources
  Import-DscResource -ModuleName PackageManagement -ModuleVersion 1.4.8.1
  Import-DscResource -ModuleName ComputerManagementDsc
  Import-DscResource -ModuleName Microsoft.WinGet.DSC
  Import-DscResource -ModuleName Microsoft.Windows.Developer
  Import-DscResource -ModuleName Microsoft.PowerToys.Configure

  @{
    LESS               = '--quit-if-one-screen --use-color --wordwrap --mouse --ignore-case --incsearch --search-options=W -R'
    PAGER              = 'less'
    EDITOR             = 'nvim'
    RUSTUP_UPDATE_ROOT = 'https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup'
    RUSTUP_DIST_SERVER = 'https://mirrors.tuna.tsinghua.edu.cn/rustup'
  }.GetEnumerator() | ForEach-Object {
    Environment $_.Key {
      Ensure = 'Present'
      Name   = $_.Key
      Value  = $_.Value
    }
  }

  DeveloperMode dev {
    SID    = ''
    Ensure = 'Present'
  }

  EnableDarkMode dark {
    SID    = ''
    Ensure = 'Present'
  }

  Taskbar Taskbar {
    SID            = ''
    SearchboxMode  = 'Hide'
    WidgetsButton  = 'Hide'
    HideLabelsMode = 'Always'
    TaskViewButton = 'Hide'
  }

  OsVersion os {
    SID        = ''
    MinVersion = '10.0.22000'
  }

  PackageManagementSource PackageManagementSource {
    Name               = 'PSGallery'
    SourceLocation     = 'https://www.powershellgallery.com/api/v2/'
    InstallationPolicy = 'Trusted'
    ProviderName       = 'PowerShellGet'
  }

  $packages = @('PSDesiredStateConfiguration', 'PSDscResources', 'ComputerManagementDsc', 'Microsoft.WinGet.Client', 'Microsoft.WinGet.DSC', 'Microsoft.Windows.Developer', 'Microsoft.PowerToys.Configure', 'Microsoft.VisualStudio.DSC', 'Refresh-EnvironmentVariables', 'powershell-yaml')

  $packages | ForEach-Object {
    PackageManagement $_.Replace('.', '_').Replace('-', '_') {
      Name         = $_
      Ensure       = 'Present'
      ProviderName = 'PowerShellGet'
      Source       = 'PSGallery'
    }
  }

  WinGetPackageManager winget {
    SID       = ''
    UseLatest = $true
  }

  WinGetAdminSettings WinGetAdminSettings {
    SID      = ''
    Settings = @'
{
  "$schema": "https://raw.githubusercontents.com/microsoft/winget-cli/master/schemas/JSON/settings/settings.schema.0.2.json",
  "installBehavior": {
    "preferences": {
      "scope": "machine"
    }
  },
  "uninstallBehavior": {
    "purgePortablePackage": true
  },
  "telemetry": {
    "disable": true
  },
  "experimentalFeatures": {
    "resume": true,
    "configureExport": true,
    "configureSelfElevate": true,
    "directMSI": true,
    "experimentalARG": true,
    "experimentalCMD": true
  }
}
'@ | ConvertFrom-Json -AsHashtable
  }

  $winget = @('7zip.7zip', 'Google.AndroidStudio', 'AutoHotkey.AutoHotkey', 'Git.Git', 'MiKTeX.MiKTeX', 'Mozilla.Firefox', 'RustDesk.RustDesk', 'TeXstudio.TeXstudio', 'VideoLAN.VLC', 'LocalSend.LocalSend', 'GoLang.Go', 'JohnMacFarlane.Pandoc', 'Eassos.DiskGenius', 'WiresharkFoundation.Wireshark', 'Microsoft.CLRTypesSQLServer.2019', 'Nutstore.Nutstore', 'GitHub.cli', 'voidtools.Everything', 'Volta.Volta', 'Oracle.JDK.21', 'Nvidia.GeForceExperience', 'Microsoft.PowerShell', 'RealVNC.VNCViewer', 'GnuPG.GnuPG', 'Graphviz.Graphviz', 'Microsoft.Edge', 'Microsoft.EdgeWebView2Runtime', 'Insecure.Npcap', 'Tencent.WeChat', 'Microsoft.VisualStudio.2022.Community', 'Tencent.QQ', 'GitHub.GitHubDesktop', 'Intel.IntelDriverAndSupportAssistant', 'Python.Launcher', 'Baidu.BaiduNetdisk', 'BurntSushi.ripgrep.MSVC', 'JesseDuffield.lazygit', 'Kingsoft.WPSOffice.CN', 'Miller.Miller', 'Oven-sh.Bun', 'Rufus.Rufus', 'Rustlang.Rustup', 'XAMPPRocky.Tokei', 'aria2.aria2', 'bootandy.dust', 'charmbracelet.vhs', 'dandavison.delta', 'hpjansson.Chafa', 'jqlang.jq', 'junegunn.fzf', 'koalaman.shellcheck', 'mvdan.shfmt', 'sharkdp.bat', 'sharkdp.fd', 'sharkdp.hexyl', 'sharkdp.hyperfine', 'voidtools.Everything.Cli', 'Python.Python.3.12', 'Microsoft.PowerToys', 'Microsoft.VisualStudioCode', 'ImageMagick.Q16-HDRI', 'Microsoft.WindowsTerminal')

  $winget | ForEach-Object {
    WinGetPackage $_ {
      Id     = $_
      Source = 'winget'
    }
  }

  PowerShellExecutionPolicy PowerShellExecutionPolicy {
    ExecutionPolicyScope = 'User'
    ExecutionPolicy      = 'RemoteSigned'
  }

  Get-PSResourceRepository {
    Name               = 'PSGallery'
    InstallationPolicy = 'Trusted'
  }

  PowerRename {
    Enabled = $false
  }

  AlwaysOnTop {
    Enabled                 = $true
    FrameThickness          = 2
    DoNotActivateOnGameMode = $true
  }

  Awake {
    Enabled = $false
  }

  ColorPicker {
    Enabled                   = $true
    CopiedColorRepresentation = 'HEX'
    ActivationAction          = 'OpenColorPickerAndThenEditor'
    ShowColorName             = $true
  }

  CropAndLock {
    Enabled = $false
  }

  EnvironmentVariables {
    Enabled             = $true
    LaunchAdministrator = $true
  }

  FancyZones {
    Enabled = $false
  }

  FileLocksmith {
    Enabled = $false
  }

  FindMyMouse {
    Enabled = $false
  }

  Hosts {
    Enabled = $false
  }

  ImageResizer {
    Enabled = $false
  }

  Peek {
    Enabled = $false
  }

  KeyboardManager {
    Enabled = $false
  }

  ShortcutGuide {
    Enabled = $false
  }

  VideoConference {
    Enabled = $false
  }

  GeneralSettings {
    Startup                         = $true
    EnableWarningsElevatedApps      = $true
    Theme                           = 'System'
    ShowNewUpdatesToastNotification = $false
    AutoDownloadUpdates             = $false
    ShowWhatsNewAfterUpdates        = $true
    EnableExperimentation           = $false
  }

  MeasureTool {
    Enabled             = $true
    DefaultMeasureStyle = 1
  }

  MouseHighlighter {
    Enabled = $false
  }

  MouseJump {
    Enabled = $false
  }

  MousePointerCrosshairs {
    Enabled              = $false
    CrosshairsThickness  = 2
    CrosshairsBorderSize = 0
    CrosshairsAutoHide   = $true
    CrosshairsRadius     = 0
  }

  MouseWithoutBorders {
    Enabled = $false
  }

  PastePlain {
    Enabled = $false
  }

  PowerPreview {
    Enabled = $false
  }

  PowerAccent {
    Enabled = $false
  }

  PowerLauncher {
    Enabled = $true
  }

  PowerOcr {
    Enabled = $true
  }

  RegistryPreview {
    Enabled = $false
  }

  VSComponents VSComunity {
    productId= 'Microsoft.VisualStudio.Product.Community'
    channelId= 'VisualStudio.17.Release'
    vsConfigFile= "$PSScriptRoot/vsconfig.json"
    includeRecommended= $true
  }
}
