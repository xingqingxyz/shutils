param([switch]$bareWord)

[regex]$reOpts = [regex]::new('^\s*(-\w+)?\W+(--[\w-]+)')
$input | Tee-Object .\help.log | ForEach-Object { $reOpts.Match($_).Groups.Values | Select-Object -Skip 1 } | & {
  begin { $list = @() }
  process {
    if (!$_.Success) { return }
    $list += if ($bareWord) {
      $_.Value
    }
    else {
      "[CompletionResult]::new('$_', '$_', [CompletionResultType]::ParameterName, 'unknown')"
    }
  }
  end {
    if ($bareWord) {
      $list | Join-String -Separator ', ' -SingleQuote
    }
    else {
      $list
    }
  }
} | Set-Clipboard
