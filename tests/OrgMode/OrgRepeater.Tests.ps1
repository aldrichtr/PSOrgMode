BeforeDiscovery {
    . "$($Source.Path)\OrgMode\enum\OrgRepeatType.ps1"
    . "$($Source.Path)\OrgMode\enum\OrgTimeUnit.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgRepeater.ps1"
}
BeforeAll {
    . "$($Source.Path)\OrgMode\enum\OrgRepeatType.ps1"
    . "$($Source.Path)\OrgMode\enum\OrgTimeUnit.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgRepeater.ps1"
}
Describe "Testing OrgMode class OrgRepeater" -Tags @('unit', 'OrgRepeater') {
    Context "Class can be loaded" {
        It "Does not throw an error when instantiated" {
            { $null = New-Object OrgRepeater } | Should -Not -Throw
        }
    }
    Context "When a new OrgRepeater object is created without arguments" {
        BeforeAll {
            $repeat = New-Object OrgRepeater
        }
        It "Should have a default Value of 0" {
            $repeat.Value | Should -Be 0
        }
        It "Should have a default Unit of none" {
            $repeat.Unit | Should -Be none
        }
        It "Should have a default Type of none" {
            $repeat.Type | Should -Be none
        }
    }

    Context "When a new OrgMarning object is created with a warning string <RepeatField>" -Foreach @(
        @{
            RepeatField = '+1d'
            Type      = [OrgRepeatType]::cumulate
            Value     = 1
            Unit      = [OrgTimeUnit]::day
        }
        @{
            RepeatField = '++1d'
            Type      = [OrgRepeatType]::catchup
            Value     = 1
            Unit      = [OrgTimeUnit]::day
        }
        @{
            RepeatField = '.+1d'
            Type      = [OrgRepeatType]::restart
            Value     = 1
            Unit      = [OrgTimeUnit]::day
        }
        @{
            RepeatField = '+1h'
            Type      = [OrgRepeatType]::cumulate
            Value     = 1
            Unit      = [OrgTimeUnit]::hour
        }
        @{
            RepeatField = '+1w'
            Type      = [OrgRepeatType]::cumulate
            Value     = 1
            Unit      = [OrgTimeUnit]::week
        }
        @{
            RepeatField = '+1m'
            Type      = [OrgRepeatType]::cumulate
            Value     = 1
            Unit      = [OrgTimeUnit]::month
        }
        @{
            RepeatField = '+1y'
            Type      = [OrgRepeatType]::cumulate
            Value     = 1
            Unit      = [OrgTimeUnit]::year
        }
    ) {
        BeforeAll {
            $repeat = New-Object OrgRepeater -ArgumentList $RepeatField
        }
        It "Should have a Type of '<Type>'" {
            $repeat.Type | Should -Be $Type
        }
        It "Should have a Value of '<Value>'" {
            $repeat.Value | Should -Be $Value
        }
        It "Should have a Unit of '<Unit>'" {
            $repeat.Unit | Should -Be $Unit
        }

    }

}
