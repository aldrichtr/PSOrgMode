
InModuleScope -ModuleName "PSOrgMode" {
    Describe "Testing OrgMode class OrgElement" -Tags @('unit', 'OrgElement') {
        Context "Class can be loaded" {
            It "Does not throw an error when instantiated" {
                {$null = New-Object OrgElement} | Should -Not -Throw
            }
        }
    }
}
