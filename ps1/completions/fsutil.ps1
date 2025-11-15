using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName fsutil -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('/')) {
        break
      }
      $i.Value
    }) -join ' '
  $command = switch ($command) {
    'behavior set' { 'behavior query'; break }
    'behavior set disableDeleteNotify' { 'behavior query disableDeleteNotify'; break }
    'devdrv untrust' { 'devdrv trust'; break }
    'devdrv clearFiltersAllowed' { 'devdrv setFiltersAllowed'; break }
    'file queryExtentsAndRefCounts' { 'file queryExtents'; break }
    'file setZeroData' { 'file queryAllocRanges'; break }
    'tiering clearFlags' { 'tiering setFlags'; break }
    default { $_; break }
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
      '' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        '8dot3name', 'behavior', 'bypassIo', 'clfs', 'dax', 'devdrv', 'dirty', 'file', 'fsInfo', 'hardlink', 'objectID', 'quota', 'repair', 'reparsePoint', 'storageReserve', 'resource', 'sparse', 'tiering', 'trace', 'transaction', 'usn', 'volume', 'wim'
        break
      }
      '8dot3name' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'query', 'scan', 'set', 'strip'
        break
      }
      '8dot3name scan' {
        if ($wordToComplete.StartsWith('/')) {
          '/s', '/v', '/l'
          break
        }
        break
      }
      '8dot3name strip' {
        if ($wordToComplete.StartsWith('/')) {
          '/t', '', '/s', '', '/f', '', '/v', '', '/l'
          break
        }
        break
      }
      'behavior' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'query', 'set'
        break
      }
      'behavior query' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'allowExtChar', 'bugcheckOnCorrupt', 'defaultNtfsTier', 'disable8dot3', 'disableCompression', 'disableCompressionLimit', 'disableDeleteNotify', 'disableEncryption', 'disableFileMetadataOptimization', 'disableLastAccess', 'disableSpotCorruptionHandling', 'disableTxF', 'disableWriteAutoTiering', 'enableMaximumHardLinks', 'enableNonpagedNtfs', 'enableReallocateAllDataWrites', 'encryptPagingFile', 'memoryUsage', 'mftZone', 'parallelFlushOpenThreshold', 'parallelFlushThreads', 'quotaNotify', 'symlinkEvaluation'
        break
      }
      'behavior query disableDeleteNotify' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'NTFS', 'ReFS'
        break
      }
      'bypassIo' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'State'
        break
      }
      'bypassIo State' {
        if ($wordToComplete.StartsWith('/')) {
          '/v'
          break
        }
        break
      }
      'clfs' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'authenticate'
        break
      }
      'dax' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'queryFileAlignment'
        break
      }
      { $_.StartsWith('dax queryFileAlignment ') } {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'q=both', 'q=large', 'q=huge', 'n=10', 's=0x100', 'l=0x10000'
        break
      }
      'devdrv' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'query', 'enable', 'disable', 'trust', 'untrust', 'setFiltersAllowed', 'clearFiltersAllowed'
        break
      }
      'devdrv enable' {
        if ($wordToComplete.StartsWith('/')) {
          '/allowAv', '/disallowAv'
          break
        }
        break
      }
      'devdrv trust' {
        if ($wordToComplete.StartsWith('/')) {
          '/f'
          break
        }
        break
      }
      'devdrv setFiltersAllowed' {
        if ($wordToComplete.StartsWith('/')) {
          '/f', '/volume'
          break
        }
        break
      }
      'dirty' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'query', 'set'
        break
      }
      'file' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'createNew', 'findBySID', 'layout', 'optimizeMetadata', 'queryAllocRanges', 'queryCaseSensitiveInfo', 'queryEA', 'queryExtents', 'queryExtentsAndRefCounts', 'queryFileID', 'queryFileNameById', 'queryProcessesUsing', 'queryOptimizeMetadata', 'queryValidData', 'setCaseSensitiveInfo', 'setShortName', 'setValidData', 'setZeroData', 'setEOF', 'setStrictlySequential'
        break
      }
      'file layout' {
        if ($wordToComplete.StartsWith('/')) {
          '/v'
          break
        }
        break
      }
      'file optimizeMetadata' {
        if ($wordToComplete.StartsWith('/')) {
          '/A'
          break
        }
        break
      }
      'file queryAllocRanges' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'offset=', 'length='
        break
      }
      'file queryExtents' {
        if ($wordToComplete.StartsWith('/')) {
          '/R'
          break
        }
        break
      }
      'file queryProcessesUsing' {
        if ($wordToComplete.StartsWith('/')) {
          '/C'
          break
        }
        break
      }
      'file queryValidData' {
        if ($wordToComplete.StartsWith('/')) {
          '/R', '/D'
          break
        }
        break
      }
      'file setCaseSensitiveInfo' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'enable', 'disable', 'recursive 0', 'recursive 1'
        break
      }
      'fsInfo' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'drives', 'driveType', 'ntfsInfo', 'refsInfo', 'sectorInfo', 'statistics', 'volumeInfo'
        break
      }
      'fsInfo refsInfo' {
        if ($wordToComplete.StartsWith('/')) {
          '/r'
          break
        }
        break
      }
      'hardlink' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'create', 'list'
        break
      }
      'objectID' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'create', 'delete', 'query', 'set'
        break
      }
      'quota' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'disable', 'enforce', 'modify', 'query', 'track', 'violations'
        break
      }
      'repair' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'enumerate', 'initiate', 'query', 'set', 'state', 'wait'
        break
      }
      'reparsePoint' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'delete', 'query'
        break
      }
      'storageReserve' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'query', 'repair', 'findByID'
        break
      }
      'storageReserve findByID' {
        if ($wordToComplete.StartsWith('/')) {
          '/v'
          break
        }
        break
      }
      'resource' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'create', 'info', 'setAutoReset', 'setAvailable', 'setConsistent', 'setLog', 'start', 'stop'
        break
      }
      'resource setAutoReset' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'true', 'false'
        break
      }
      'resource setLog' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'growth', 'maxExtents', 'minExtents', 'mode', 'rename', 'shrink', 'size'
        break
      }
      'resource setLog mode' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'full', 'undo'
        break
      }
      'sparse' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'queryflag', 'queryrange', 'setflag', 'setrange'
        break
      }
      'tiering' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'clearFlags', 'queryFlags', 'regionList', 'setFlags', 'tierList'
        break
      }
      'tiering setFlags' {
        if ($wordToComplete.StartsWith('/')) {
          '/TrNH'
          break
        }
        break
      }
      'trace' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'decode', 'query', 'start', 'stop'
        break
      }
      'trace start' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'output=', 'level='
        break
      }
      'transaction' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'commit', 'fileinfo', 'list', 'query', 'rollback'
        break
      }
      'transaction query' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'files', 'all'
        break
      }
      'usn' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'createJournal', 'deleteJournal', 'enableRangeTracking', 'enumData', 'queryJournal', 'readJournal', 'readData'
        break
      }
      'usn createJournal' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'a=', 'm='
        break
      }
      'usn deleteJournal' {
        if ($wordToComplete.StartsWith('/')) {
          '/D', '/N'
          break
        }
        break
      }
      'usn enableRangeTracking' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'c=', 's='
        break
      }
      'usn readJournal' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'minVer=', 'maxVer=', 'startUsn=', 'csv', 'wait', 'tail'
        break
      }
      'volume' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'allocationReport', 'diskFree', 'dismount', 'findShrinkBlocker', 'fileLayout', 'flush', 'list', 'queryCluster', 'queryLabel', 'queryNumaInfo', 'setLabel', 'smrGC', 'smrInfo', 'tpInfo', 'upgrade'
        break
      }
      'volume allocationReport' {
        if ($wordToComplete.StartsWith('/')) {
          '/tier', '/v'
          break
        }
        if ($prev -eq '/tier') {
          'capacity', 'performance'
          break
        }
        break
      }
      'volume findShrinkBlocker' {
        if ($wordToComplete.StartsWith('/')) {
          '/noFileName', '/shrinkSize', '/newSize'
          break
        }
        break
      }
      'volume fileLayout' {
        if ($wordToComplete.StartsWith('/')) {
          '/v'
          break
        }
        break
      }
      'volume smrGC' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'Action=start', 'Action=startfullspeed', 'Action=pause', 'Action=stop', 'IoGranularity='
        break
      }
      'volume tpInfo' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'info', 'storageMap', 'full'
        break
      }
      'wim' {
        if ($wordToComplete.StartsWith('/')) {
          break
        }
        'enumFiles', 'enumWims', 'removeWim', 'queryFile'
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
