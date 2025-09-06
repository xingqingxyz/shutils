Register-ArgumentCompleter -Native -CommandName esbuild -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--bundle', '--define:K=V', '--external:M', '--format=', '--loader:X=L', '--minify', '--outdir=', '--outfile=', '--packages=', '--platform=', '--serve=', '--sourcemap', '--splitting', '--target=', '--watch', '--watch=forever', '--abs-paths=', '--allow-overwrite', '--analyze', '--analyze=verbose', '--asset-names=', '--banner:T=', '--certfile=', '--charset=utf8', '--chunk-names=', '--color=', '--cors-origin=', '--drop:', '--drop-labels=', '--entry-names=', '--footer:T=', '--global-name=', '--ignore-annotations', '--inject:F', '--jsx-dev', '--jsx-factory=', '--jsx-fragment=', '--jsx-import-source=', '--jsx-side-effects', '--jsx=', '--keep-names', '--keyfile=', '--legal-comments=', '--line-limit=', '--log-level=', '--log-limit=', '--log-override:X=Y', '--main-fields=', '--mangle-cache=', '--mangle-props=', '--mangle-quoted=', '--metafile=', '--minify-whitespace', '--minify-identifiers', '--minify-syntax', '--out-extension:', '--outbase=', '--preserve-symlinks', '--public-path=', '--pure:N', '--reserve-props=', '--resolve-extensions=', '--serve-fallback=', '--servedir=', '--source-root=', '--sourcefile=', '--sourcemap=external', '--sourcemap=inline', '--sources-content=false', '--supported:F=', '--tree-shaking=', '--tsconfig=', '--tsconfig-raw=', '--version', '--watch-delay=', '--outfile=out',
      '--alias:', '--help',
      '--format=iife', '--format=cjs', '--format=esm',
      '--loader:base64=', '--loader:binary=', '--loader:copy=', '--loader:css=', '--loader:dataurl=', '--loader:empty=', '--loader:file=', '--loader:global-css=', '--loader:js=', '--loader:json=', '--loader:jsx=', '--loader:local-css=', '--loader:text=', '--loader:ts=', '--loader:tsx=',
      '--packages=external', '--packages=default',
      '--platform=browser', '--platform=node', '--platform=neutral',
      '--serve=localhost:3333',
      '--target=es2017', '--target=es2023', '--target=es2025', '--target=chrome138', '--target=firefox142', '--target=safari14', '--target=edge138', '--target=node24', '--target=esnext',
      '--abs-paths=code', '--abs-paths=log', '--abs-paths=metafile',
      '--analyze=verbose',
      '--asset-names=[name]-[hash]',
      '--banner:css=', '--banner:js=',
      '--chunk-names=[name]-[hash]',
      '--color=true', '--color=false',
      '--drop:console', '--drop:debugger',
      '--entry-names=[dir]/[name]',
      '--footer:css=', '--footer:js=',
      '--jsx-factory=React.createElement',
      '--jsx-fragment=React.Fragment',
      '--jsx-import-source=react',
      '--jsx=automatic', '--jsx=preserve',
      '--legal-comments=none', '--legal-comments=inline', '--legal-comments=eof', '--legal-comments=linked', '--legal-comments=external',
      '--log-level=verbose', '--log-level=debug', '--log-level=info', '--log-level=warning', '--log-level=error', '--log-level=silent',
      '--main-fields=browser`,module`,main', '--main-fields=main`,module',
      '--mangle-quoted=true', '--mangle-quoted=false',
      '--resolve-extensions=.tsx`,.ts`,.jsx`,.js`,.css`,.json',
      '--tree-shaking=true', '--tree-shaking=false'
    }).Where{ $_ -like "$wordToComplete*" }
}
