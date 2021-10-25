
InModuleScope -ModuleName "PSOrgMode" {
    Describe "Testing OrgMode class OrgWarning" -Tags @('unit', 'OrgWarning') {
        Context "Class can be loaded" {
            It "Does not throw an error when instantiated" {
                {$null = New-Object OrgWarning} | Should -Not -Throw
            }
        }
    }
}
