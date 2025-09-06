using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName vsce -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq 0 -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    }) -join ';'
  $command = switch ($command) {
    'pack' { 'package'; break }
    Default { $command }
  }

  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  @(switch ($command) {
      { $true } {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'display help for command')
          [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'display help for command')
        }
      }
      '' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-V', '-V', [CompletionResultType]::ParameterName, 'output the version number')
          [CompletionResult]::new('--version', '--version', [CompletionResultType]::ParameterName, 'output the version number')
          break
        }
        [CompletionResult]::new('ls', 'ls', [CompletionResultType]::ParameterName, 'Lists all the files that will be published/packaged')
        [CompletionResult]::new('pack', 'pack', [CompletionResultType]::ParameterName, 'Packages an extension')
        [CompletionResult]::new('package', 'package', [CompletionResultType]::ParameterName, 'Packages an extension')
        [CompletionResult]::new('publish', 'publish', [CompletionResultType]::ParameterName, 'Publishes an extension')
        [CompletionResult]::new('unpublish', 'unpublish', [CompletionResultType]::ParameterName, 'Unpublishes an extension. Example extension id: ms-vscode.live-server.')
        [CompletionResult]::new('generate-manifest', 'generate-manifest', [CompletionResultType]::ParameterName, 'Generates the extension manifest from the provided VSIX package.')
        [CompletionResult]::new('verify-signature', 'verify-signature', [CompletionResultType]::ParameterName, 'Verifies the provided signature file against the provided VSIX package and manifest.')
        [CompletionResult]::new('ls-publishers', 'ls-publishers', [CompletionResultType]::ParameterName, 'Lists all known publishers')
        [CompletionResult]::new('delete-publisher', 'delete-publisher', [CompletionResultType]::ParameterName, 'Deletes a publisher from marketplace')
        [CompletionResult]::new('login', 'login', [CompletionResultType]::ParameterName, 'Adds a publisher to the list of known publishers')
        [CompletionResult]::new('logout', 'logout', [CompletionResultType]::ParameterName, 'Removes a publisher from the list of known publishers')
        [CompletionResult]::new('verify-pat', 'verify-pat', [CompletionResultType]::ParameterName, 'Verifies if the Personal Access Token or Azure identity has publish rights for the publisher')
        [CompletionResult]::new('show', 'show', [CompletionResultType]::ParameterName, "Shows an extension's metadata")
        [CompletionResult]::new('search', 'search', [CompletionResultType]::ParameterName, 'Searches extension gallery')
        [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterName, 'display help for command')
        break
      }
      'ls' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--tree', '--tree', [CompletionResultType]::ParameterName, 'Prints the files in a tree format (default: false)')
          [CompletionResult]::new('--yarn', '--yarn', [CompletionResultType]::ParameterName, 'Use yarn instead of npm (default inferred from presence of yarn.lock or .yarnrc)')
          [CompletionResult]::new('--no-yarn', '--no-yarn', [CompletionResultType]::ParameterName, 'Use npm instead of yarn (default inferred from absence of yarn.lock or .yarnrc)')
          [CompletionResult]::new('--packagedDependencies', '--packagedDependencies', [CompletionResultType]::ParameterName, 'Select packages that should be published only (includes dependencies)')
          [CompletionResult]::new('--ignoreFile', '--ignoreFile', [CompletionResultType]::ParameterName, 'Indicate alternative .vscodeignore')
          [CompletionResult]::new('--dependencies', '--dependencies', [CompletionResultType]::ParameterName, 'Enable dependency detection via npm or yarn')
          [CompletionResult]::new('--no-dependencies', '--no-dependencies', [CompletionResultType]::ParameterName, 'Disable dependency detection via npm or yarn')
          [CompletionResult]::new('--readme-path', '--readme-path', [CompletionResultType]::ParameterName, 'Path to README file (defaults to README.md)')
          [CompletionResult]::new('--follow-symlinks', '--follow-symlinks', [CompletionResultType]::ParameterName, 'Recurse into symlinked directories instead of treating them as files')
        }
        break
      }
      'package' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-o,', '-o,', [CompletionResultType]::ParameterName, 'Output .vsix extension file to <path>                                   location (defaults to <name>-<version>.vsix)')
          [CompletionResult]::new('--out', '--out', [CompletionResultType]::ParameterName, 'Output .vsix extension file to <path>                                   location (defaults to <name>-<version>.vsix)')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Target architecture. Valid targets:                                   win32-x64, win32-arm64, linux-x64,                                   linux-arm64, linux-armhf, darwin-x64,                                   darwin-arm64, alpine-x64, alpine-arm64, web')
          [CompletionResult]::new('--target', '--target', [CompletionResultType]::ParameterName, 'Target architecture. Valid targets:                                   win32-x64, win32-arm64, linux-x64,                                   linux-arm64, linux-armhf, darwin-x64,                                   darwin-arm64, alpine-x64, alpine-arm64, web')
          [CompletionResult]::new('--ignore-other-target-folders', '--ignore-other-target-folders', [CompletionResultType]::ParameterName, 'Ignore other target folders. Valid only when                                   --target <target> is provided.')
          [CompletionResult]::new('--readme-path', '--readme-path', [CompletionResultType]::ParameterName, 'Path to README file (defaults to README.md)')
          [CompletionResult]::new('--changelog-path', '--changelog-path', [CompletionResultType]::ParameterName, 'Path to CHANGELOG file (defaults to                                   CHANGELOG.md)')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Commit message used when calling `npm                                   version`.')
          [CompletionResult]::new('--message', '--message', [CompletionResultType]::ParameterName, 'Commit message used when calling `npm                                   version`.')
          [CompletionResult]::new('--no-git-tag-version', '--no-git-tag-version', [CompletionResultType]::ParameterName, 'Do not create a version commit and tag when                                   calling `npm version`. Valid only when                                   [version] is provided.')
          [CompletionResult]::new('--no-update-package-json', '--no-update-package-json', [CompletionResultType]::ParameterName, 'Do not update `package.json`. Valid only when                                   [version] is provided.')
          [CompletionResult]::new('--githubBranch', '--githubBranch', [CompletionResultType]::ParameterName, 'The GitHub branch used to infer relative                                   links in README.md. Can be overridden by                                   --baseContentUrl and --baseImagesUrl.')
          [CompletionResult]::new('--gitlabBranch', '--gitlabBranch', [CompletionResultType]::ParameterName, 'The GitLab branch used to infer relative                                   links in README.md. Can be overridden by                                   --baseContentUrl and --baseImagesUrl.')
          [CompletionResult]::new('--no-rewrite-relative-links', '--no-rewrite-relative-links', [CompletionResultType]::ParameterName, 'Skip rewriting relative links.')
          [CompletionResult]::new('--baseContentUrl', '--baseContentUrl', [CompletionResultType]::ParameterName, 'Prepend all relative links in README.md with                                   the specified URL.')
          [CompletionResult]::new('--baseImagesUrl', '--baseImagesUrl', [CompletionResultType]::ParameterName, 'Prepend all relative image links in README.md                                   with the specified URL.')
          [CompletionResult]::new('--yarn', '--yarn', [CompletionResultType]::ParameterName, 'Use yarn instead of npm (default inferred                                   from presence of yarn.lock or .yarnrc)')
          [CompletionResult]::new('--no-yarn', '--no-yarn', [CompletionResultType]::ParameterName, 'Use npm instead of yarn (default inferred                                   from absence of yarn.lock or .yarnrc)')
          [CompletionResult]::new('--ignoreFile', '--ignoreFile', [CompletionResultType]::ParameterName, 'Indicate alternative .vscodeignore')
          [CompletionResult]::new('--no-gitHubIssueLinking', '--no-gitHubIssueLinking', [CompletionResultType]::ParameterName, 'Disable automatic expansion of GitHub-style                                   issue syntax into links')
          [CompletionResult]::new('--no-gitLabIssueLinking', '--no-gitLabIssueLinking', [CompletionResultType]::ParameterName, 'Disable automatic expansion of GitLab-style                                   issue syntax into links')
          [CompletionResult]::new('--dependencies', '--dependencies', [CompletionResultType]::ParameterName, 'Enable dependency detection via npm or yarn')
          [CompletionResult]::new('--no-dependencies', '--no-dependencies', [CompletionResultType]::ParameterName, 'Disable dependency detection via npm or yarn')
          [CompletionResult]::new('--pre-release', '--pre-release', [CompletionResultType]::ParameterName, 'Mark this package as a pre-release')
          [CompletionResult]::new('--allow-star-activation', '--allow-star-activation', [CompletionResultType]::ParameterName, 'Allow using * in activation events')
          [CompletionResult]::new('--allow-missing-repository', '--allow-missing-repository', [CompletionResultType]::ParameterName, 'Allow missing a repository URL in package.json')
          [CompletionResult]::new('--allow-unused-files-pattern', '--allow-unused-files-pattern', [CompletionResultType]::ParameterName, 'Allow include patterns for the files field in package.json that does not match any file')
          [CompletionResult]::new('--skip-license', '--skip-license', [CompletionResultType]::ParameterName, 'Allow packaging without license file')
          [CompletionResult]::new('--sign-tool', '--sign-tool', [CompletionResultType]::ParameterName, 'Path to the VSIX signing tool. Will be invoked with two arguments: `SIGNTOOL <path/to/extension.signature.manifest> <path/to/extension.signature.p7s>`.')
          [CompletionResult]::new('--follow-symlinks', '--follow-symlinks', [CompletionResultType]::ParameterName, 'Recurse into symlinked directories instead of treating them as files')
          break
        }
        $prev = switch ($prev) {
          '-t' { '--target'; break }
          Default { $prev }
        }
        switch ($prev) {
          '--target' {
            @('win32-x64', 'win32-arm64', 'linux-x64',
              'linux-arm64', 'linux-armhf', 'darwin-x64',
              'darwin-arm64', 'alpine-x64', 'alpine-arm64', 'web').ForEach{ [CompletionResult]::new($_, $_, [CompletionResultType]::ParameterValue, 'unknown') }
            break
          }
        }
        break
      }
      'publish' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-o,', '-o,', [CompletionResultType]::ParameterName, 'Output .vsix extension file to <path>                                   location (defaults to <name>-<version>.vsix)')
          [CompletionResult]::new('--out', '--out', [CompletionResultType]::ParameterName, 'Output .vsix extension file to <path>                                   location (defaults to <name>-<version>.vsix)')
          [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Target architecture. Valid targets:                                   win32-x64, win32-arm64, linux-x64,                                   linux-arm64, linux-armhf, darwin-x64,                                   darwin-arm64, alpine-x64, alpine-arm64, web')
          [CompletionResult]::new('--target', '--target', [CompletionResultType]::ParameterName, 'Target architecture. Valid targets:                                   win32-x64, win32-arm64, linux-x64,                                   linux-arm64, linux-armhf, darwin-x64,                                   darwin-arm64, alpine-x64, alpine-arm64, web')
          [CompletionResult]::new('--ignore-other-target-folders', '--ignore-other-target-folders', [CompletionResultType]::ParameterName, 'Ignore other target folders. Valid only when                                   --target <target> is provided.')
          [CompletionResult]::new('--readme-path', '--readme-path', [CompletionResultType]::ParameterName, 'Path to README file (defaults to README.md)')
          [CompletionResult]::new('--changelog-path', '--changelog-path', [CompletionResultType]::ParameterName, 'Path to CHANGELOG file (defaults to                                   CHANGELOG.md)')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Commit message used when calling `npm                                   version`.')
          [CompletionResult]::new('--message', '--message', [CompletionResultType]::ParameterName, 'Commit message used when calling `npm                                   version`.')
          [CompletionResult]::new('--no-git-tag-version', '--no-git-tag-version', [CompletionResultType]::ParameterName, 'Do not create a version commit and tag when                                   calling `npm version`. Valid only when                                   [version] is provided.')
          [CompletionResult]::new('--no-update-package-json', '--no-update-package-json', [CompletionResultType]::ParameterName, 'Do not update `package.json`. Valid only when                                   [version] is provided.')
          [CompletionResult]::new('--githubBranch', '--githubBranch', [CompletionResultType]::ParameterName, 'The GitHub branch used to infer relative                                   links in README.md. Can be overridden by                                   --baseContentUrl and --baseImagesUrl.')
          [CompletionResult]::new('--gitlabBranch', '--gitlabBranch', [CompletionResultType]::ParameterName, 'The GitLab branch used to infer relative                                   links in README.md. Can be overridden by                                   --baseContentUrl and --baseImagesUrl.')
          [CompletionResult]::new('--no-rewrite-relative-links', '--no-rewrite-relative-links', [CompletionResultType]::ParameterName, 'Skip rewriting relative links.')
          [CompletionResult]::new('--baseContentUrl', '--baseContentUrl', [CompletionResultType]::ParameterName, 'Prepend all relative links in README.md with                                   the specified URL.')
          [CompletionResult]::new('--baseImagesUrl', '--baseImagesUrl', [CompletionResultType]::ParameterName, 'Prepend all relative image links in README.md                                   with the specified URL.')
          [CompletionResult]::new('--yarn', '--yarn', [CompletionResultType]::ParameterName, 'Use yarn instead of npm (default inferred                                   from presence of yarn.lock or .yarnrc)')
          [CompletionResult]::new('--no-yarn', '--no-yarn', [CompletionResultType]::ParameterName, 'Use npm instead of yarn (default inferred                                   from absence of yarn.lock or .yarnrc)')
          [CompletionResult]::new('--ignoreFile', '--ignoreFile', [CompletionResultType]::ParameterName, 'Indicate alternative .vscodeignore')
          [CompletionResult]::new('--no-gitHubIssueLinking', '--no-gitHubIssueLinking', [CompletionResultType]::ParameterName, 'Disable automatic expansion of GitHub-style                                   issue syntax into links')
          [CompletionResult]::new('--no-gitLabIssueLinking', '--no-gitLabIssueLinking', [CompletionResultType]::ParameterName, 'Disable automatic expansion of GitLab-style                                   issue syntax into links')
          [CompletionResult]::new('--dependencies', '--dependencies', [CompletionResultType]::ParameterName, 'Enable dependency detection via npm or yarn')
          [CompletionResult]::new('--no-dependencies', '--no-dependencies', [CompletionResultType]::ParameterName, 'Disable dependency detection via npm or yarn')
          [CompletionResult]::new('--pre-release', '--pre-release', [CompletionResultType]::ParameterName, 'Mark this package as a pre-release')
          [CompletionResult]::new('--allow-star-activation', '--allow-star-activation', [CompletionResultType]::ParameterName, 'Allow using * in activation events')
          [CompletionResult]::new('--allow-missing-repository', '--allow-missing-repository', [CompletionResultType]::ParameterName, 'Allow missing a repository URL in package.json')
          [CompletionResult]::new('--allow-unused-files-pattern', '--allow-unused-files-pattern', [CompletionResultType]::ParameterName, 'Allow include patterns for the files field in package.json that does not match any file')
          [CompletionResult]::new('--skip-license', '--skip-license', [CompletionResultType]::ParameterName, 'Allow packaging without license file')
          [CompletionResult]::new('--sign-tool', '--sign-tool', [CompletionResultType]::ParameterName, 'Path to the VSIX signing tool. Will be invoked with two arguments: `SIGNTOOL <path/to/extension.signature.manifest> <path/to/extension.signature.p7s>`.')
          [CompletionResult]::new('--follow-symlinks', '--follow-symlinks', [CompletionResultType]::ParameterName, 'Recurse into symlinked directories instead of treating them as files')
          break
        }
        $prev = switch ($prev) {
          '-t' { '--target'; break }
          Default { $prev }
        }
        switch ($prev) {
          '--target' {
            @('win32-x64', 'win32-arm64', 'linux-x64',
              'linux-arm64', 'linux-armhf', 'darwin-x64',
              'darwin-arm64', 'alpine-x64', 'alpine-arm64', 'web').ForEach{ [CompletionResult]::new($_, $_, [CompletionResultType]::ParameterValue, 'unknown') }
            break
          }
        }
        break
      }
      'unpublish' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Personal Access Token')
          [CompletionResult]::new('--pat', '--pat', [CompletionResultType]::ParameterName, 'Personal Access Token')
          [CompletionResult]::new('--azure-credential', '--azure-credential', [CompletionResultType]::ParameterName, 'Use Microsoft Entra ID for authentication')
          [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Skip confirmation prompt when unpublishing an extension')
          [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Skip confirmation prompt when unpublishing an extension')
        }
        break
      }
      'generate-manifest' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Path to the VSIX package')
          [CompletionResult]::new('--packagePath', '--packagePath', [CompletionResultType]::ParameterName, 'Path to the VSIX package')
          [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Output the extension manifest to <path> location (defaults to <packagename>.manifest)')
          [CompletionResult]::new('--out', '--out', [CompletionResultType]::ParameterName, 'Output the extension manifest to <path> location (defaults to <packagename>.manifest)')
        }
        break
      }
      'verify-signature' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Path to the VSIX package')
          [CompletionResult]::new('--packagePath', '--packagePath', [CompletionResultType]::ParameterName, 'Path to the VSIX package')
          [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Path to the Manifest file')
          [CompletionResult]::new('--manifestPath', '--manifestPath', [CompletionResultType]::ParameterName, 'Path to the Manifest file')
          [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'Path to the Signature file')
          [CompletionResult]::new('--signaturePath', '--signaturePath', [CompletionResultType]::ParameterName, 'Path to the Signature file')
        }
        break
      }
      'ls-publishers' { break }
      'delete-publisher' { break }
      'login' { break }
      'logout' { break }
      'verify-pat' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Personal Access Token')
          [CompletionResult]::new('--pat', '--pat', [CompletionResultType]::ParameterName, 'Personal Access Token')
          [CompletionResult]::new('--azure-credential', '--azure-credential', [CompletionResultType]::ParameterName, 'Use Microsoft Entra ID for authentication')
        }
        break
      }
      'show' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--json', '--json', [CompletionResultType]::ParameterName, 'Outputs data in json format (default: false)')
        }
        break
      }
      'search' {
        if ($wordToComplete.StartsWith('-')) {
          [CompletionResult]::new('--json', '--json', [CompletionResultType]::ParameterName, 'Outputs data in json format (default: false)')
          [CompletionResult]::new('--stats', '--stats', [CompletionResultType]::ParameterName, 'Shows extensions rating and download count (default: false)')
          [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Number of results to return (default: "100")')
          [CompletionResult]::new('--pagesize', '--pagesize', [CompletionResultType]::ParameterName, 'Number of results to return (default: "100")')
        }
        break
      }
      'help' {
        [CompletionResult]::new('ls', 'ls', [CompletionResultType]::ParameterName, 'Lists all the files that will be published/packaged')
        [CompletionResult]::new('pack', 'pack', [CompletionResultType]::ParameterName, 'Packages an extension')
        [CompletionResult]::new('package', 'package', [CompletionResultType]::ParameterName, 'Packages an extension')
        [CompletionResult]::new('publish', 'publish', [CompletionResultType]::ParameterName, 'Publishes an extension')
        [CompletionResult]::new('unpublish', 'unpublish', [CompletionResultType]::ParameterName, 'Unpublishes an extension. Example extension id: ms-vscode.live-server.')
        [CompletionResult]::new('generate-manifest', 'generate-manifest', [CompletionResultType]::ParameterName, 'Generates the extension manifest from the provided VSIX package.')
        [CompletionResult]::new('verify-signature', 'verify-signature', [CompletionResultType]::ParameterName, 'Verifies the provided signature file against the provided VSIX package and manifest.')
        [CompletionResult]::new('ls-publishers', 'ls-publishers', [CompletionResultType]::ParameterName, 'Lists all known publishers')
        [CompletionResult]::new('delete-publisher', 'delete-publisher', [CompletionResultType]::ParameterName, 'Deletes a publisher from marketplace')
        [CompletionResult]::new('login', 'login', [CompletionResultType]::ParameterName, 'Adds a publisher to the list of known publishers')
        [CompletionResult]::new('logout', 'logout', [CompletionResultType]::ParameterName, 'Removes a publisher from the list of known publishers')
        [CompletionResult]::new('verify-pat', 'verify-pat', [CompletionResultType]::ParameterName, 'Verifies if the Personal Access Token or Azure identity has publish rights for the publisher')
        [CompletionResult]::new('show', 'show', [CompletionResultType]::ParameterName, "Shows an extension's metadata")
        [CompletionResult]::new('search', 'search', [CompletionResultType]::ParameterName, 'Searches extension gallery')
        [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterName, 'display help for command')
        break
      }
    }) | Where-Object CompletionText -Like "$wordToComplete*"
}
