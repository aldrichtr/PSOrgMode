
Describe "Testing public Property function New-OrgProperty" -Tags @('unit', 'OrgProperty', 'New' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help New-OrgProperty -ErrorAction Stop} | Should -Not -Throw
        }
    }
}
