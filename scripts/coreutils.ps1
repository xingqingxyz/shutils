if ($IsWindows) {
  function dirname {
    [CmdletBinding()]
    param (
      [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
      [AllowEmptyString()]
      [SupportsWildcards()]
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
  return
}

function dirname {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
    [AllowEmptyString()]
    [SupportsWildcards()]
    [string[]]
    $Path
  )
  $Path.ForEach{
    if (!$_) {
      return '.'
    }
    $i = $_.Length - 1
    while ($_[$i] -ceq '/') {
      if (!$i--) {
        return '/'
      }
    }
    $i = $_.LastIndexOf('/', $i)
    if ($i -eq -1) {
      return '.'
    }
    while ($_[$i] -ceq '/') {
      if (!$i--) {
        return '/'
      }
    }
    $_.Substring(0, $i + 1)
  }
}
