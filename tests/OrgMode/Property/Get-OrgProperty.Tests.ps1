
Describe "Testing public Property function Get-OrgProperty" -Tags @('unit', 'OrgProperty', 'Get' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help Get-OrgProperty -ErrorAction Stop} | Should -Not -Throw
        }
    }
    Context "When the given Property exists" {
        BeforeAll {
            $e = New-OrgElement -Type section
            $e | Add-OrgProperty -Name "CATEGORY" -Value "Garden"
        }
        It "Returns the value of the given named property" {
            $cat = $e | Get-OrgProperty -Name 'CATEGORY'
            $cat | Should -BeLikeExactly 'Garden'
        }
    }
}
