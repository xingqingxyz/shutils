class MtSetupDsc {
  [MtSetupDsc] Get() {
    $state = [MtSetupDsc]::new()
    return $state
  }
  [bool] Test() {
    return $true
  }
  [void] Set() {}
}
