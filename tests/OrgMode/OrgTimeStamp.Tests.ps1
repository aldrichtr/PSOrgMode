
BeforeDiscovery {
    # enums
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    . "$($Source.Path)\OrgMode\enum\OrgTimeUnit.ps1"
    . "$($Source.Path)\OrgMode\enum\OrgRepeatType.ps1"
    . "$($Source.Path)\OrgMode\enum\OrgWarningType.ps1"
    # classes
    . "$($Source.Path)\OrgMode\classes\OrgRepeater.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgWarning.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgTimeStamp.ps1"
}
BeforeAll {
    # enums
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    . "$($Source.Path)\OrgMode\enum\OrgTimeUnit.ps1"
    . "$($Source.Path)\OrgMode\enum\OrgRepeatType.ps1"
    . "$($Source.Path)\OrgMode\enum\OrgWarningType.ps1"
    # classes
    . "$($Source.Path)\OrgMode\classes\OrgRepeater.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgWarning.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgTimeStamp.ps1"
}
Describe "Testing OrgMode class OrgTimeStamp" -Tags @('unit', 'OrgTimeStamp') {

    Context "When a new object is created" {
        It "Should not throw an error" {
            { $null = New-Object OrgTimeStamp } | Should -Not -Throw
        }
    }
    Context "When a new object is created without arguments" {
        BeforeAll {
            $ts = New-Object OrgTimeStamp
        }

        It "Should have a default Type of timestamp" {
            $ts.Type | Should -Be timestamp
        }

        It "Should be Active" {
            $ts.Active | Should -BeTrue
        }
    }
}
