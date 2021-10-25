
Describe "Testing private Element function Add-OrgElement" -Tags @('unit', 'OrgElement', 'Add' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help Add-OrgElement -ErrorAction Stop} | Should -Not -Throw
        }
    }
}
