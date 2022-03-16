
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
    . "$($Source.Path)\OrgMode\classes\OrgElement.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgHeadline.ps1"

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
    . "$($Source.Path)\OrgMode\classes\OrgElement.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgHeadline.ps1"
}
Describe "Testing OrgMode class OrgHeadline" -Tags @('unit', 'OrgHeadline') {
    Context "Class can be loaded" {
        It "Does not throw an error when instantiated" {
            { $null = New-Object OrgHeadline } | Should -Not -Throw
        }
    }
    Context "When a new object is created without arguments" {
        BeforeAll {
            $h = New-Object OrgHeadline
        }

        It "Should have a default Type of timestamp" {
            $h.Type | Should -Be headline
        }

        It "Should have a level of 0" {
            $h.Level | Should -Be 0
        }
    }
}
