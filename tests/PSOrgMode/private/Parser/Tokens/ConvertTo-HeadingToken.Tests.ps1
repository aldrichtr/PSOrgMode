using namespace System.Management.Automation.Language
BeforeDiscovery {
  if (Get-Module 'TestHelpers') {
    $sourceFile = Get-SourceFilePath $PSCommandPath
  } else {
    throw 'TestHelpers module is not loaded'
  }
  if (-not (Test-Path $sourceFile)) {
    throw "Could not find $sourceFile from $PSCommandPath"
  }
  $analyzerRules = Get-ScriptAnalyzerRule -Severity Error, Warning
  | Where-Object {
    $_.RuleName -notmatch '(^PSDSC)|Manifest'
  }
  try {
    $analysis = Invoke-ScriptAnalyzer -Path $sourceFile -IncludeRule $analyzerRules
  } catch {
    throw "There was an error analyzing $sourceFile`n$_"
  }
  $dataDirectory = Get-TestDataPath

  Write-Debug @"
$('-' * 80)
-- $($PSCommandPath | Split-Path -Leaf):
Source file: $sourceFile
Data directory: $dataDirectory
Analyzer rule count: $($analyzerRules.Count)
Rule violations: $($analysis.Count)
"@
}

$options = @{
  Tag     = @( 'unit', 'Parser', 'ConvertTo', 'HeadingToken')
  Name    = 'GIVEN the public function ConvertTo-HeadingToken'
  ForEach = @{
    Source   = $sourceFile
    Rules    = $analyzerRules
    Analysis = $analysis
  }
}

Describe @options {
  Context 'WHEN The function is sourced in the current environment' -Tag @('parse') -ForEach @($sourceFile) {
    BeforeAll {
      $sourceFile = $_
      if ($sourceFile | Test-Path) {
        $content = (Get-Content $sourceFile -Raw)
        $tokens      = $null
        $parseErrors = $null
        $results = [Parser]::ParseInput($content, [ref]$tokens, [ref]$parseErrors)
        $predicate = { param($Ast) $ast -is [FunctionDefinitionAst] }
        $functionAst = $results.Find($predicate, $false)
      }
    }

    It 'THEN it should parse without error' {
      $parseErrors | Should -BeNullOrEmpty
    }
    It 'THEN it should load without error' {
      InModuleScope PSOrgMode {
        (Get-Command 'ConvertTo-HeadingToken') | Should -Not -BeNullOrEmpty
      }
    }

    It 'THEN it should contain a function' {
      $functionAst | Should -Not -BeNullOrEmpty
    }

    It 'THEN the function name should match the file name' {
      $functionAst.Name | Should -BeLike ($sourceFile | Split-Path -LeafBase)
    }
  }

  Context 'WHEN the <rule.RuleName> rule is tested' -Tag @('pssa') -ForEach $analyzerRules {
    BeforeAll {
      # Rename automatic variable to rule to make it easier to work with
      $rule = $_
    }

    It 'THEN it should pass' {
      $analysis | Should -Pass $rule
    }
  }
  <# --=-- #>

  InModuleScope PSOrgMode {
    Context "When the following heading is given to the parser:`n<Heading>" -ForEach @(
      @{
        Heading  = '** This is a plain level two heading'
        Level    = 2
        Title    = 'This is a plain level two heading'
        Priority = $null
        Keyword  = $null
        Tracking  = $null
        Tags      = @()
      },
      @{
        Heading  = '** TODO This is a plain level two heading'
        Level    = 2
        Title    = 'This is a plain level two heading'
        Priority = $null
        Keyword  = 'TODO'
        Tracking  = $null
        Tags      = @()
      },
      @{
        Heading  = '** TODO [#A] This is a plain level two heading'
        Level    = 2
        Title    = 'This is a plain level two heading'
        Priority = '[#A]'
        Keyword  = 'TODO'
        Tracking  = $null
        Tags      = @()
      },
      @{
        Heading  = '** TODO This is a plain level two heading [1/2]'
        Level    = 2
        Title    = 'This is a plain level two heading'
        Priority = $null
        Keyword  = 'TODO'
        Tracking  = '[1/2]'
        Tags      = @()
      },
      @{
        Heading  = '** TODO This is a plain level two heading [1/2] :one:two:'
        Level    = 2
        Title    = 'This is a plain level two heading'
        Priority = $null
        Keyword  = 'TODO'
        Tracking  = '[1/2]'
        Tags      = @('one', 'two')
      }
      ) {

      BeforeAll {
        $token = $Heading | ConvertTo-HeadingToken
      }

      It 'It creates a HeadingToken object' {
        $token | Should -BeOfType OrgMode.Parser.HeadingToken
      }

      It "It should be a level '<Level>' heading" {
        $token.level | Should -Be $Level
      }

      It "It should have a title of '<Title>'" {
        $token.title | Should -Match ([regex]::Escape($Title))
      }

      It "It should have a priority of '<Priority>'" {
        $token.priority | Should -Match ([regex]::Escape($Priority))
      }

      It "It should have a keyword of '<Keyword>'" {
        $token.keyword | Should -BeLike $Keyword
      }

      It "It should have a tracking cookie of '<Tracking>'" {
        $token.tracking | Should -Match ([regex]::Escape($Tracking))
      }

      It "It should have tags '<tags>'" {
        $token.tags.Count | Should -Be $Tags.Count
      }
    }
  }
  <# --=-- #>
}
