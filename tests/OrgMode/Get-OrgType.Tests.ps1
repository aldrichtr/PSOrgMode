
Describe "Testing private function Get-OrgType" -Tags @('unit', 'OrgType', 'Get' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            { Get-Help Get-OrgType -ErrorAction Stop } | Should -Not -Throw
        }
    }
}
