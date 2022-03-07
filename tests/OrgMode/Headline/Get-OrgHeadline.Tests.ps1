
Describe "Testing public Headline function Get-OrgHeadline" -Tags @('unit', 'OrgHeadline', 'Get' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help Get-OrgHeadline -ErrorAction Stop} | Should -Not -Throw
        }
    }
}
