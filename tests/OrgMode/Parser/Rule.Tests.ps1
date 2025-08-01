# TODO: Consider using aliases for BDD style tests
# Set-Alias -Name 'Given' -Value 'Context' -Description "Use BDD style wording" -Scope Script

<# --=-- #>
$options = @{
  Tag  = @( 'unit', 'class', 'OrgMode', 'Parser')
  Name = "Testing the class 'Rule'"
}
Describe @options {

  Context 'Test the constructors' {
    It 'It should load the module' {
      Get-Module 'OrgMode' | Should -Not -BeNullOrEmpty
    }

    Context 'When using the constructor with just the name argument' {
      BeforeAll {
        $rule = [OrgMode.Parser.Rule]::new('Rule01')
        $hex = '[a-fA-F0-9]'

        $guidPattern = (@(
            '[({]?', # Could be enclosed in brackets or parens
            "$hex{8}",
            '[-]?', # dashes are optional
            "($hex{4}[-]?){3}",
            "$hex{12}",
            '[)}]?') -join '')
        $blankGuid = '00000000-0000-0000-0000-000000000000'
      }
      It 'It should create a rule object' {
        $rule | Should -Not -BeNullOrEmpty
      }
      It 'It should set the name field to the name passed in' {
        $rule.name | Should -Be 'Rule01'
      }
      It 'It should create a new GUID for the ID' {
        $rule.id | Should -Match $guidPattern
      }

      It 'It should not be a blank GUID' {
        $rule.id | Should -Not -BeExactly $blankGuid
      }
    }
  }
}
<# --=-- #>
