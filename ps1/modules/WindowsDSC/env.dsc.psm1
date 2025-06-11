[DscResource()]
class EnvDSC {
  [DscProperty(Key)]
  [string] $Name = 'environment'

  [DscProperty()]
  [bool]$settled = $false

  [void] Set() {
    if (!$env:PATHEXT.Split(';').Contains('.JAR')) {
      $env:PATHEXT += ';.JAR'
      [System.Environment]::SetEnvironmentVariable('PATHEXT', $env:PATHEXT, 'Machine')
    }
    if (!$env:USERPROFILE.Split(';').Contains("${env:USERPROFILE}\exe")) {
      $Path = [System.Environment]::GetEnvironmentVariable('Path', 'User') + ";${env:USERPROFILE}\exe"
      [System.Environment]::SetEnvironmentVariable('Path', $Path, 'User')
    }
  }

  [bool] Test() {
    return [System.Environment]::GetEnvironmentVariable('PATHEXT', 'Machine').Split(';').Contains('.JAR')
  }

  [EnvDSC] Get() {
    $this.settled = $this.Test()
    return $this
  }
}
