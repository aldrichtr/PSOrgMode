# TODO: Consider using aliases for BDD style tests
# Set-Alias -Name 'Given' -Value 'Context' -Description "Use BDD style wording" -Scope Script

<# --=-- #>
$options = @{
  Tag  = @( 'unit', 'class', 'OrgMode', 'Parser')
  Name = "Testing the class 'Token'"
}
Describe @options {

  Context 'Test the constructors' {
    It 'It should load the module' {
      Get-Module 'OrgMode' | Should -Not -BeNullOrEmpty
    }

    Context 'When using the constructor with no arguments' {
      BeforeAll {
        $token = [OrgMode.Parser.HeadingToken]::new()
      }
      It 'It should create a token object' {
        $token | Should -BeOfType OrgMode.Parser.HeadingToken
      }

      It 'It should have a start position' {
        $token.start | Should -BeOfType OrgMode.Parser.Position
      }

      It 'It should have a start position of 0' {
        $token.start.index | Should -BeExactly 0
      }

      It 'It should have an end position' {
        $token.end | Should -BeOfType OrgMode.Parser.Position
      }

      It 'It should have an end position of 0' {
        $token.end.index | Should -BeExactly 0
      }
    }
  }
}
<# --=-- #>
