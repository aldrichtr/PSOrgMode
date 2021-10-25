
Describe "Testing public Parser function ConvertFrom-OrgMode" -Tags @('unit', 'OrgMode', 'ConvertFrom' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help ConvertFrom-OrgMode -ErrorAction Stop} | Should -Not -Throw
        }
    }
}
