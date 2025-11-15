using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName clang-cl -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $foundLink = $false
  foreach ($i in ($commandAst.CommandElements | Select-Object -Skip 1)) {
    if ($i.Extent.EndOffset -ge $cursorPosition) {
      break
    }
    if ($i -is [StringConstantExpressionAst] -and $i.Value -eq '/link') {
      $foundLink = $true
      break
    }
  }
  if ($foundLink) {
    return & (Get-ArgumentCompleter link) $wordToComplete $commandAst $cursorPosition
  }
  elseif ($wordToComplete.StartsWith('-')) {
    return & (Get-ArgumentCompleter clang) $wordToComplete $commandAst $cursorPosition
  }
  @(if ($wordToComplete.StartsWith('/')) {
      '/?', '/arch:x86_64', '/arch:x86', '/arch:arm64', '/arch:arm', '/arm64EC', '/Brepro-', '/Brepro', '/clang:', '/C', '/c', '/d1PP', '/d1reportAllClassLayout', '/d2epilogunwindrequirev2', '/d2epilogunwind', '/diagnostics:caret', '/diagnostics:classic', '/diagnostics:column', '/diasdkdir', '/D', '/EH', '/EP', '/execution-charset:UTF-8', '/external:env:', '/external:I', '/external:W0', '/external:W1', '/external:W2', '/external:W3', '/external:W4', '/E', '/FA', '/Fa', '/Fe', '/FI', '/Fi', '/Fo', '/Fp', '/fsanitize=address', '/funcoverride:', '/GA', '/Gd', '/GF-', '/GF', '/GR-', '/Gregcall4', '/Gregcall', '/GR', '/Gr', '/GS-', '/GS', '/Gs', '/Gs4096', '/guard:cf', '/guard:ehcont', '/Gv', '/Gw-', '/Gw', '/GX-', '/GX', '/Gy-', '/Gy', '/Gz', '/help', '/hotpatch', '/imsvc', '/I', '/JMC-', '/JMC', '/J', '/LDd', '/LD', '/link', '/MDd', '/MD', '/MTd', '/MT', '/O1', '/O2', '/Ob0', '/Ob1', '/Ob2', '/Ob3', '/Od', '/Og', '/Oi-', '/Oi', '/openmp-', '/openmp:experimental', '/openmp', '/Os', '/Ot', '/Ox', '/Oy-', '/Oy', '/O2y-', '/o', '/permissive-', '/permissive', '/P', '/Qgather-', '/QIntel-jcc-erratum', '/Qscatter-', '/Qvec-', '/Qvec', '/showFilenames-', '/showFilenames', '/showIncludes:user', '/showIncludes', '/source-charset:UTF-8', '/std:c++14', '/std:c++17', '/std:c++20', '/std:c++23preview', '/std:c++latest', '/std:c11', '/std:c17', '/TC', '/Tc', '/TP', '/Tp', '/tune:', '/utf-8', '/U', '/vctoolsdir', '/vctoolsversion', '/vd', '/vmb', '/vmg', '/vmm', '/vms', '/vmv', '/W0', '/W1', '/W2', '/W3', '/W4', '/Wall', '/winsdkdir', '/winsdkversion', '/winsysroot', '/WX-', '/WX', '/w', '/X', '/Y-', '/Yc', '/Yu', '/Z7', '/Zc:__STDC__', '/Zc:alignedNew-', '/Zc:alignedNew', '/Zc:char8_t-', '/Zc:char8_t', '/Zc:dllexportInlines-', '/Zc:dllexportInlines', '/Zc:sizedDealloc-', '/Zc:sizedDealloc', '/Zc:strictStrings', '/Zc:threadSafeInit-', '/Zc:threadSafeInit', '/Zc:tlsGuards-', '/Zc:tlsGuards', '/Zc:trigraphs-', '/Zc:trigraphs', '/Zc:twoPhase-', '/Zc:twoPhase', '/Zc:wchar_t-', '/Zc:wchar_t', '/ZH:MD5', '/ZH:SHA1', '/ZH:SHA_256', '/Zi', '/Zl', '/Zp', '/Zp1', '/Zs'
    }).Where{ $_ -like "$wordToComplete*" }
}
