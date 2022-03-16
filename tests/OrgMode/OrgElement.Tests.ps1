
BeforeDiscovery {
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    . "$($Source.Path)\OrgMode\Classes\OrgElement.ps1"
}
BeforeAll {
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    . "$($Source.Path)\OrgMode\Classes\OrgElement.ps1"
}

Describe "Testing OrgMode class OrgElement" -Tags @('unit', 'OrgElement') {
    Context "Class can be loaded" {
        It "Does not throw an error when instantiated" {
            { $null = New-Object OrgElement } | Should -Not -Throw
        }
    }
}
