
Describe "Testing private Element function New-OrgElement" -Tags @('unit', 'OrgElement', 'New' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help New-OrgElement -ErrorAction Stop} | Should -Not -Throw
        }
    }
}
