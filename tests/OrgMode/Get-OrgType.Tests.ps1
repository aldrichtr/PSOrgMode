
BeforeAll {
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgElement.ps1"
    . "$($Source.Path)\OrgMode\public\Element\Get-OrgType.ps1"
}
Describe "Testing private function Get-OrgType" -Tags @('unit', 'OrgType', 'Get' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            { Get-Help Get-OrgType -ErrorAction Stop } | Should -Not -Throw
        }
    }
}
