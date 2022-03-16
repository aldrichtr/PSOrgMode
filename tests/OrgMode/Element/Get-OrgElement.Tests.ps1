
BeforeDiscovery {
    # enums
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    # classes
    . "$($Source.Path)\OrgMode\classes\OrgElement.ps1"
    # functions
    . "$($Source.Path)\OrgMode\public\Element\Get-OrgElement.ps1"

}
BeforeAll {
    # enums
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    # classes
    . "$($Source.Path)\OrgMode\classes\OrgElement.ps1"
    # functions
    . "$($Source.Path)\OrgMode\public\Element\Get-OrgElement.ps1"
}
Describe "Testing private Element function Get-OrgElement" -Tags @('unit', 'OrgElement', 'Get' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help Get-OrgElement -ErrorAction Stop} | Should -Not -Throw
        }
    }
}
