BeforeAll {
    # enums
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    # classes
    . "$($Source.Path)\OrgMode\classes\OrgProperty.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgElement.ps1"
    # functions
    . "$($Source.Path)\OrgMode\public\Element\New-OrgElement.ps1"
    . "$($Source.Path)\OrgMode\public\Element\Add-OrgElement.ps1"
    . "$($Source.Path)\OrgMode\public\Property\Test-OrgProperty.ps1"
    . "$($Source.Path)\OrgMode\public\Property\New-OrgProperty.ps1"
    . "$($Source.Path)\OrgMode\public\Property\Add-OrgProperty.ps1"
}
Describe "Testing public Property function Test-OrgProperty" -Tags @('unit', 'OrgProperty', 'Test' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help Test-OrgProperty -ErrorAction Stop} | Should -Not -Throw
        }
    }
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
