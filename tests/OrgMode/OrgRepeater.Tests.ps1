
InModuleScope -ModuleName "PSOrgMode" {
    Describe "Testing OrgMode class OrgRepeater" -Tags @('unit', 'OrgRepeater') {
        Context "Class can be loaded" {
            It "Does not throw an error when instantiated" {
                { $null = New-Object OrgRepeater } | Should -Not -Throw
            }
        }
    }
}
