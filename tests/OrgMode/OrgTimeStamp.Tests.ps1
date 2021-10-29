
InModuleScope -ModuleName "PSOrgMode" {
Describe "Testing OrgMode class OrgTimeStamp" -Tags @('unit', 'OrgTimeStamp') {
    Context "Class can be loaded" {
        It "Does not throw an error when instantiated" {
            {$null = New-Object OrgTimeStamp} | Should -Not -Throw
        }
    }
}
}
