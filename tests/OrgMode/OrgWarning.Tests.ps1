

# Because we need enums and classes to be available during discovery for the '-Foreach'
# expansion, and during Run, it is called twice.
BeforeDiscovery {
    . "$($Source.Path)\OrgMode\classes\OrgWarning.ps1"
    . "$($Source.Path)\OrgMode\enum\OrgWarningType.ps1"
    . "$($Source.Path)\OrgMode\enum\OrgTimeUnit.ps1"

}
BeforeAll {
    . "$($Source.Path)\OrgMode\enum\OrgWarningType.ps1"
    . "$($Source.Path)\OrgMode\enum\OrgTimeUnit.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgWarning.ps1"

}
Describe "Testing OrgMode class OrgWarning" -Tags @('unit', 'OrgWarning') {

    Context "Class can be loaded" {
        It "Does not throw an error when instantiated" {
            { $null = New-Object OrgWarning } | Should -Not -Throw
        }
    }

    Context "When a new OrgWarning object is created without arguments" {
        BeforeAll {
            $warn = New-Object OrgWarning
        }
        It "Should have a default Value of 0" {
            $warn.Value | Should -Be 0
        }
        It "Should have a default Unit of none" {
            $warn.Unit | Should -Be none
        }
        It "Should have a default Type of none" {
            $warn.Type | Should -Be none
        }
    }

    Context "When a new OrgMarning object is created with a warning string <WarnField>" -Foreach @(
        @{
            WarnField = '-1d'
            Type      = [OrgWarningType]::all
            Value     = 1
            Unit      = [OrgTimeUnit]::day
        }
        @{
            WarnField = '--1d'
            Type      = [OrgWarningType]::first
            Value     = 1
            Unit      = [OrgTimeUnit]::day
        }
        @{
            WarnField = '-1h'
            Type      = [OrgWarningType]::all
            Value     = 1
            Unit      = [OrgTimeUnit]::hour
        }
        @{
            WarnField = '-1w'
            Type      = [OrgWarningType]::all
            Value     = 1
            Unit      = [OrgTimeUnit]::week
        }
        @{
            WarnField = '-1m'
            Type      = [OrgWarningType]::all
            Value     = 1
            Unit      = [OrgTimeUnit]::month
        }
        @{
            WarnField = '-1y'
            Type      = [OrgWarningType]::all
            Value     = 1
            Unit      = [OrgTimeUnit]::year
        }
    ) {
        BeforeAll {
            $warn = New-Object OrgWarning -ArgumentList $WarnField
        }
        It "Should have a Type of '<Type>'" {
            $warn.Type | Should -Be $Type
        }
        It "Should have a Value of '<Value>'" {
            $warn.Value | Should -Be $Value
        }
        It "Should have a Unit of '<Unit>'" {
            $warn.Unit | Should -Be $Unit
        }

    }
}
