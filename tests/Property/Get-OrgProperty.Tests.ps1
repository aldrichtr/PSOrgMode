
Describe "Get-OrgProperty function" -Tags 'unit', 'orgproperty', 'function' {
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
