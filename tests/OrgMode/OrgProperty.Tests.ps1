
InModuleScope -ModuleName "PSOrgMode" {
    Describe "Testing OrgMode class OrgProperty" -Tags @('unit', 'OrgProperty') {
    Context "Class can be loaded" {
        It "Does not throw an error when instantiated" {
            {$null = New-Object OrgProperty} | Should -Not -Throw
        }
    }
}
}
