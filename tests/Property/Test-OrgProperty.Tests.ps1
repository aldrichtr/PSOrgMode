
Describe "Test-OrgProperty function" -Tags 'unit', 'orgproperty', 'function' {
    Context "When the given Property exists" {
        BeforeAll {
            $e = New-OrgElement -Type section
            $e | Add-OrgProperty -Name "CATEGORY" -Value "Garden"
        }
        It "Tests for the given name succeed" {
            $e | Test-OrgProperty -Name 'CATEGORY' | Should -BeTrue
        }
        It "Tests for the given name and value succeed" {
            $e | Test-OrgProperty -Name 'CATEGORY' -Value 'Garden' | Should -BeTrue
        }
        It "Tests for the wrong name fail" {
            $e | Test-OrgProperty -Name 'COLOR' | Should -BeFalse
        }
        It "Tests for the wrong value fail" {
            $e | Test-OrgProperty -Name 'CATEGORY' -Value 'Farm' | Should -BeFalse
        }
    }
}
