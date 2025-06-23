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
    while ($_[$i] -eq '/') {
      if (!$i--) {
        return '/'
      }
    }
    $i = $_.LastIndexOf('/', $i)
    if ($i -eq -1) {
      return '.'
    }
    while ($_[$i] -eq '/') {
      if (!$i--) {
        return '/'
      }
    }
    $_.Substring(0, $i + 1)
  }
}
