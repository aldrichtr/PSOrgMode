
Describe "Testing private Element function Get-OrgElement" -Tags @('unit', 'OrgElement', 'Get' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help Get-OrgElement -ErrorAction Stop} | Should -Not -Throw
        }
    }
}
