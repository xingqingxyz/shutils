using namespace System.Collections.Generic
using namespace System.Management.Automation.Language

param (
  [Parameter(Position = 0, ValueFromPipeline)]
  $InputObject = 'ls -File|%{$_.FullName}'
)

class MyVisitor : AstVisitor2 {
  static [string]$TAB = '  '
  [ScriptBlockAst]$scriptBlockAst
  [Dictionary[Ast, List[Ast]]]$typeMap = @{}

  MyVisitor([ScriptBlockAst]$scriptBlockAst) {
    $this.scriptBlockAst = $scriptBlockAst
    $scriptBlockAst.Visit($this)
  }

  MyVisitor([string]$text) {
    $this.scriptBlockAst = [Parser]::ParseInput($text, [ref]$null, [ref]$null)
    $this.scriptBlockAst.Visit($this)
  }

  [AstVisitAction] DefaultVisit([Ast]$ast) {
    $this.typeMap.Add($ast, [List[Ast]]::new())
    if ($null -ne $ast.Parent) {
      $this.typeMap[$ast.Parent].Add($ast)
    }
    return [AstVisitAction]::Continue
  }

  [pscustomobject] getNode() {
    return $this.getNode($this.scriptBlockAst)
  }

  [pscustomobject] getNode([Ast]$ast) {
    $node = [pscustomobject]@{
      _range      = @(
        $ast.Extent.StartLineNumber - 1
        $ast.Extent.StartColumnNumber - 1
        $ast.Extent.EndLineNumber - 1
        $ast.Extent.EndColumnNumber - 1
      )
      startOffset = $ast.Extent.StartOffset
      endOffset   = $ast.Extent.EndOffset
      text        = $ast.ToString()
      type        = $ast.GetType().Name
      children    = [List[pscustomobject]]::new()
    }
    foreach ($childAst in $this.typeMap[$ast]) {
      $node.children.Add($this.getNode($childAst))
    }
    return $node
  }

  [void] render() {
    $this.render($this.scriptBlockAst, 0)
  }

  [void] render([Ast]$ast, [uint]$depth) {
    $text = $ast.ToString()
    if ($text.Length -gt 16) {
      $text = "`e]8;;$text`e\$($text.Substring(0, 15))…`e]8;;`e\"
    }
    [System.Console]::WriteLine("$([MyVisitor]::TAB * $depth)`e[1m$($ast.GetType().Name)`e[0m : $text `e[2m[$($ast.Extent.StartLineNumber), $($ast.Extent.StartColumnNumber)] - [$($ast.Extent.EndLineNumber), $($ast.Extent.EndColumnNumber)]`e[0m")
    $depth++
    foreach ($childAst in $this.typeMap[$ast]) {
      $this.render($childAst, $depth)
    }
  }
}

$visitor = [MyVisitor]::new($InputObject)
$visitor.getNode() | ConvertTo-Json -Depth 99
