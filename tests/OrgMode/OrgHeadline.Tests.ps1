
InModuleScope -ModuleName "PSOrgMode" {
    Describe "Testing OrgMode class OrgHeadline" -Tags @('unit', 'OrgHeadline') {
        Context "Class can be loaded" {
            It "Does not throw an error when instantiated" {
                {$null = New-Object OrgHeadline} | Should -Not -Throw
            }
        }
    }
}
