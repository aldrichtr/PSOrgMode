
Describe "Testing public Property function Add-OrgProperty" -Tags @('unit', 'OrgProperty', 'Add' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help Add-OrgElement -ErrorAction Stop} | Should -Not -Throw
        }
    }
    Context "When the name <Name> and value <Value> are given" -Foreach @(
        @{
            Name = 'CATEGORY'
            Value = 'Garden'
        }
    ){
        BeforeEach {
            $e = New-OrgElement -Type section
            $p = New-OrgProperty -Name $Name -Value $Value
        }
        AfterEach {
            Remove-Variable e
            Remove-Variable p
        }
        It "Adds the property when <Name> isn't already set" {
            $e | Add-OrgProperty $p
            $e | Test-OrgProperty -Name 'CATEGORY' -Value 'Garden' | Should -BeTrue
        }
        It "Throws an error if <Name> already exists and -Force is not set" {
            $e | Add-OrgProperty $p
            {$e | Add-OrgProperty -Name $Name} | Should -Throw
        }
        It "Resets the value of <Name> when -Force is set" {
            $e | Add-OrgProperty $p
            {$e | Add-OrgProperty -Name $Name -Value 'Farm' -Force} | Should -Not -Throw
            $e | Test-OrgProperty -Name 'CATEGORY' -Value 'Farm' | Should -BeTrue
        }
    }
}
