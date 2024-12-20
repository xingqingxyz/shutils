class TrieNode {
  [hashtable]$children
  [bool]$isEnd

  TrieNode() {
    $this.children = @{}
    $this.isEnd = $false
  }
}

class Trie {
  [TrieNode]$root

  Trie() {
    $this.root = [TrieNode]::new()
  }

  [void]Insert([string]$word) {
    $node = $this.root
    foreach ($char in $word.ToCharArray()) {
      if (-not $node.children.ContainsKey($char)) {
        $node.children[$char] = [TrieNode]::new()
      }
      $node = $node.children[$char]
    }
    $node.isEnd = $true
  }

  [bool]Search([string]$word) {
    $node = $this.root
    foreach ($char in $word.ToCharArray()) {
      if (-not $node.children.ContainsKey($char)) {
        return $false
      }
      $node = $node.children[$char]
    }
    return $node.isEnd
  }

  [bool]StartsWith([string]$prefix) {
    $node = $this.root
    foreach ($char in $prefix.ToCharArray()) {
      if (-not $node.children.ContainsKey($char)) {
        return $false
      }
      $node = $node.children[$char]
    }
    return $true
  }
}
