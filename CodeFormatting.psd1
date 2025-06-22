@{
  Rules = @{
    PSPlaceCloseBrace                  = @{
      Enable             = $true
      NoEmptyLineBefore  = $true
      IgnoreOneLineBlock = $true
      NewLineAfter       = $true
    }
    PSPlaceOpenBrace                   = @{
      Enable             = $true
      OnSameLine         = $true
      NewLineAfter       = $true
      IgnoreOneLineBlock = $true
    }
    PSUseConsistentWhitespace          = @{
      Enable                                  = $true
      CheckInnerBrace                         = $true
      CheckOpenBrace                          = $true
      CheckOpenParen                          = $true
      CheckOperator                           = $true
      CheckPipe                               = $true
      CheckPipeForRedundantWhitespace         = $true
      CheckSeparator                          = $true
      CheckParameter                          = $true
      IgnoreAssignmentOperatorInsideHashTable = $false
    }
    PSUseConsistentIndentation         = @{
      Enable              = $true
      IndentationSize     = 2
      PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
      Kind                = 'space'
    }
    PSAlignAssignmentStatement         = @{
      Enable         = $true
      CheckHashtable = $true
    }
    PSUseCorrectCasing                 = @{ Enable = $true
      CheckCommands                = $true
      CheckKeyword                 = $true
      CheckOperator                = $true
    }
    PSAvoidUsingCmdletAliases          = @{
      AllowList = @()
    }
    # PSAvoidUsingDoubleQuotesForConstantString = @{}
    PSAvoidSemicolonsAsLineTerminators = @{
      Enable = $true
    }
    PSAvoidExclaimOperator             = @{
      Enable = $false
    }
    # PSAvoidTrailingWhitespace                 = @{}
  }
}
