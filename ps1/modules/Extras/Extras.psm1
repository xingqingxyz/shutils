function getParser([string]$extension) {
  foreach ($pair in $parserMap.GetEnumerator()) {
    if ($pair.Value.Contains($extension)) {
      return $parserCommandMap.($pair.Key)
    }
  }
  return { Get-Content -Raw -LiteralPath $args[0] }
}

function pbat {
  param(
    [Parameter(Mandatory, Position = 0)]
    [string[]]
    $Path
  )
  Get-Item $Path | ForEach-Object {
    & (getParser $_.Extension.Substring(1)) $_.FullName | bat --color=always --file-name $_.FullName
  } | less
}

$parserMap = @{
  clangformat      = 'c,m,mm,cpp,cc,cp,cxx,c++,h,hh,hpp,hxx,h++,inl,ipp'
  dart             = 'dart'
  dotnet           = 'cs,csx,fs,fsi,fsx,vb'
  gofmt            = 'go'
  prettier         = 'js,cjs,mjs,jsx,tsx,ts,cts,mts,json,jsonc,json5,yml,yaml,htm,html,xhtml,shtml,vue,gql,graphql,css,scss,sass,less,hbs,md,markdown'
  PSScriptAnalyzer = 'ps1,psm1,psd1'
  ruff             = 'py,pyi,pyw,pyx,pxd,gyp,gypi'
  rustfmt          = 'rs'
  shfmt            = 'sh,bash,zsh,ash'
  stylua           = 'lua'
  zig              = 'zig'
}
$parserCommandMap = @{
  # clangformat      = 'c,m,mm,cpp,cc,cp,cxx,c++,h,hh,hpp,hxx,h++,inl,ipp'
  # dart             = 'dart'
  # dotnet           = 'cs,csx,fs,fsi,fsx,vb'
  # gofmt            = 'go'
  prettier         = { npx prettier --ignore-path= $args[0] }
  PSScriptAnalyzer = {
    Invoke-Formatter (Get-Content -Raw $args[0]) -Settings ${env:SHUTILS_ROOT}/CodeFormatting.psd1
  }
  ruff             = {
    Get-Content -Raw $args[0] | ruff format -n --stdin-filename $args[0]
  }
  # rustfmt          = 'rs'
  shfmt            = {
    Get-Content -Raw $args[0] | shfmt -i 2 -bn -ci -sr --filename $args[0]
  }
  # stylua           = 'stylua -'
  # zig              = 'zig'
}
Set-Alias ruff /home/uv/.vscode/extensions/charliermarsh.ruff-*/bundled/libs/bin/ruff
