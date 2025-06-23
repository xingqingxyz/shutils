function dirname {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
    [AllowEmptyString()]
    [string[]]
    $Path
  )
  $Path.ForEach{
    if (!$_) {
      return '.'
    }
    $i = $_.Length - 1
    while ('\/'.Contains($_[$i])) {
      if (!$i--) {
        return '/'
      }
    }
    while (!'\/'.Contains($_[$i])) {
      if (!$i--) {
        return '.'
      }
    }
    while ('\/'.Contains($_[$i])) {
      if (!$i--) {
        return '/'
      }
    }
    $_.Substring(0, $i + 1)
  }
}
