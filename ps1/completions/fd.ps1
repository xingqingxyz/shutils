& (Get-Command -CommandType Application -TotalCount 1 -ea Ignore fd).Path --gen-completions powershell | Out-String | Invoke-Expression
