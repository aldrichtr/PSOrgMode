
BeforeDiscovery {
    # enums
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    # classes
    . "$($Source.Path)\OrgMode\classes\OrgElement.ps1"
    # functions
    . "$($Source.Path)\OrgMode\public\Element\New-OrgElement.ps1"

}
BeforeAll {
    # enums
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    # classes
    . "$($Source.Path)\OrgMode\classes\OrgElement.ps1"
    # functions
    . "$($Source.Path)\OrgMode\public\Element\New-OrgElement.ps1"
}
Describe "Testing private Element function New-OrgElement" -Tags @('unit', 'OrgElement', 'New' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            { Get-Help New-OrgElement -ErrorAction Stop } | Should -Not -Throw
        }
    }
}
