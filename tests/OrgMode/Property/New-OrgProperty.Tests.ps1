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
Describe "Testing public Property function New-OrgProperty" -Tags @('unit', 'OrgProperty', 'New' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help New-OrgProperty -ErrorAction Stop} | Should -Not -Throw
        }
    }
}
