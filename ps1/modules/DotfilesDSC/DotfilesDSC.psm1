[DscResource()]
class DotfilesDSC {
  [DscProperty(Key)]
  [string] $Unit

  [DscProperty()]
  [string] $Description

  [void] Set() {
  }

  [bool] Test() {
    return $false
  }

  [DotfilesDSC] Get() {
    return 1
  }

  [System.Object] Export() {
    return 1
  }


}
