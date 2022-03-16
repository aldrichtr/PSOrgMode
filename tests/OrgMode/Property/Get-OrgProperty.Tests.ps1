
BeforeAll {
    # enums
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    # classes
    . "$($Source.Path)\OrgMode\classes\OrgProperty.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgElement.ps1"
    # functions
    . "$($Source.Path)\OrgMode\public\Element\New-OrgElement.ps1"
    . "$($Source.Path)\OrgMode\public\Property\Test-OrgProperty.ps1"
    . "$($Source.Path)\OrgMode\public\Property\Add-OrgProperty.ps1"
    . "$($Source.Path)\OrgMode\public\Property\Get-OrgProperty.ps1"
    . "$($Source.Path)\OrgMode\public\Property\New-OrgProperty.ps1"
}

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
