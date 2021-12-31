
InModuleScope -ModuleName PSOrgMode -ScriptBlock {
    Describe "Testing private Parser function ConvertFrom-OrgTimeStamp" -Tags @('unit', 'OrgTimeStamp', 'ConvertFrom' ) {
        Context "Basic functionality" {
            It "Should load without error" {
                {Get-Help ConvertFrom-OrgTimeStamp -ErrorAction Stop} | Should -Not -Throw
            }
        }
        Context "When a single <Type> org timestamp string is given" -Foreach @(
            @{
                Type    = "Date only - Active"
                Stamp   = "<2021-09-10 Fri>"
                Start   = (Get-Date "2021-09-10")
                End     = (Get-Date "2021-09-10")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }

            }
            @{
                Type    = "Date only - Inactive"
                Stamp   = "[2021-09-11 Sat]"
                Start   = (Get-Date "2021-09-11")
                End     = (Get-Date "2021-09-11")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }

            }
            @{
                Type    = "Date and repeat - Active"
                Stamp   = "<2021-09-10 Fri +2d>"
                Start   = (Get-Date "2021-09-10")
                End     = (Get-Date "2021-09-10")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 2
                    Unit  = [OrgTimeUnit]::day
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
            @{
                Type    = "Date and repeat - Inactive"
                Stamp   = "[2021-09-11 Sat +5d]"
                Start   = (Get-Date "2021-09-11")
                End     = (Get-Date "2021-09-11")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 5
                    Unit  = [OrgTimeUnit]::day
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
            @{
                Type    = "Date repeat, and warn - Active"
                Stamp   = "<2021-09-10 Fri +2d -1m>"
                Start   = (Get-Date "2021-09-10")
                End     = (Get-Date "2021-09-10")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 2
                    Unit  = [OrgTimeUnit]::day
                }
                Warning = @{
                    Type  = [OrgWarningType]::all
                    Value = 1
                    Unit  = [OrgTimeUnit]::month
                }
            }
            @{
                Type    = "Date repeat, and warn - Inactive"
                Stamp   = "[2021-09-11 Sat +5d -2y]"
                Start   = (Get-Date "2021-09-11")
                End     = (Get-Date "2021-09-11")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 5
                    Unit  = [OrgTimeUnit]::day
                }
                Warning = @{
                    Type  = [OrgWarningType]::all
                    Value = 2
                    Unit  = [OrgTimeUnit]::year
                }

            }
            @{
                Type    = "Date and time - Active"
                Stamp   = "<2021-09-11 Sat 11:00>"
                Start   = (Get-Date "2021-09-11 11:00")
                End     = (Get-Date "2021-09-11 11:00")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }


            }
            @{  Type    = "Date and time - Inactive"
                Stamp   = "[2021-09-11 Sat 11:00]"
                Start   = (Get-Date "2021-09-11 11:00")
                End     = (Get-Date "2021-09-11 11:00")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
            @{  Type    = "Date, time and repeat - Active"
                Stamp   = "<2021-09-11 Sat 11:00 +5w>"
                Start   = (Get-Date "2021-09-11 11:00")
                End     = (Get-Date "2021-09-11 11:00")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 5
                    Unit  = [OrgTimeUnit]::week
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
            @{  Type    = "Date, time and repeat - Inactive"
                Stamp   = "[2021-09-11 Sat 11:00 +1y]"
                Start   = (Get-Date "2021-09-11 11:00")
                End     = (Get-Date "2021-09-11 11:00")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 1
                    Unit  = [OrgTimeUnit]::year
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
            @{  Type    = "Date and time span - Active"
                Stamp   = "<2021-09-11 Sat 11:00-12:00>"
                Start   = (Get-Date "2021-09-11 11:00")
                End     = (Get-Date "2021-09-11 12:00")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
            @{  Type    = "Date and time span - Inactive"
                Stamp   = "[2021-09-11 Sat 11:00-12:00]"
                Start   = (Get-Date "2021-09-11 11:00")
                End     = (Get-Date "2021-09-11 12:00")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
            @{  Type    = "Date, time span and repeat - Active"
                Stamp   = "<2021-09-11 Sat 11:00-12:00 +20h>"
                Start   = (Get-Date "2021-09-11 11:00")
                End     = (Get-Date "2021-09-11 12:00")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 20
                    Unit  = [OrgTimeUnit]::hour
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
            @{  Type    = "Date, time span and repeat - Inactive"
                Stamp   = "[2021-09-11 Sat 11:00-12:00 +1m]"
                Start   = (Get-Date "2021-09-11 11:00")
                End     = (Get-Date "2021-09-11 12:00")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 1
                    Unit  = [OrgTimeUnit]::month
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
        ) {
            BeforeAll {
                $d = $Stamp | ConvertFrom-OrgTimeStamp
            }
            It "Sets the start date to '<Start>' using '<Stamp>'" {
                $d.Start | Should -Be $Start
            }
            It "Sets the end date to '<End>' using '<Stamp>'" {
                $d.End | Should -Be $End
            }
            It "Sets the active state to <Active> using '<Stamp>'" {
                $d.Active | Should -Be $Active
            }
            It "Sets the repeat interval to '<Repeat>' using '<Stamp>'" {
                $d.Repeat.Type  | Should -Be $Repeat.Type
                $d.Repeat.Value | Should -Be $Repeat.Value
                $d.Repeat.Unit  | Should -Be $Repeat.Unit
            }
            It "Sets the warning to '<Warning.Type>-<Warning.Value> <Warning.Unit>' using '<Stamp>'" {
                $d.Warning.Type | Should -Be $Warning.Type
                $d.Warning.Value | Should -Be $Warning.Value
                $d.Warning.Unit | Should -Be $Warning.Unit
            }

        }
        Context "When a span <Type> org timestamp string is given" -Foreach @(
            @{
                Type    = "Date only - Active"
                Stamp   = "<2021-09-10 Fri>--<2021-09-11 Sat>"
                Start   = (Get-Date "2021-09-10")
                End     = (Get-Date "2021-09-11")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
            @{
                Type    = "Date only - Inactive"
                Stamp   = "[2021-09-11 Sat]--[2021-09-21 Tue]"
                Start   = (Get-Date "2021-09-11")
                End     = (Get-Date "2021-09-21")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }

            }
            @{
                Type    = "Date and repeat - Active"
                Stamp   = "<2021-09-09 Thu>--<2021-09-10 Fri +2d>"
                Start   = (Get-Date "2021-09-09")
                End     = (Get-Date "2021-09-10")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 2
                    Unit  = [OrgTimeUnit]::day
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
            @{
                Type    = "Date and repeat - Inactive"
                Stamp   = "[2021-09-08 Wed]--[2021-09-11 Sat +5d]"
                Start   = (Get-Date "2021-09-08")
                End     = (Get-Date "2021-09-11")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 5
                    Unit  = [OrgTimeUnit]::day
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
            @{
                Type    = "Date and time - Active"
                Stamp   = "<2021-09-11 Sat 11:00>--<2021-09-11 Sat 11:00>"
                Start   = (Get-Date "2021-09-11 11:00")
                End     = (Get-Date "2021-09-11 11:00")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }

            }
            @{  Type    = "Date and time - Inactive"
                Stamp   = "[2021-09-11 Sat 11:00]--[2021-09-11 Sat 11:00]"
                Start   = (Get-Date "2021-09-11 11:00")
                End     = (Get-Date "2021-09-11 11:00")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }

            }
            @{  Type    = "Date, time and repeat - Active"
                Stamp   = "<2021-09-11 Sat 11:00>--<2021-09-11 Sat 12:00 +5w>"
                Start   = (Get-Date "2021-09-11 11:00")
                End     = (Get-Date "2021-09-11 12:00")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 5
                    Unit  = [OrgTimeUnit]::week
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }

            }
            @{  Type    = "Date, time and repeat - Inactive"
                Stamp   = "[2021-09-11 Sat 11:00]--[2021-09-11 Sat 12:00 +1y]"
                Start   = (Get-Date "2021-09-11 11:00")
                End     = (Get-Date "2021-09-11 12:00")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 1
                    Unit  = [OrgTimeUnit]::year
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }

            }
            @{
                Type    = "Date and repeat on the right - Active"
                Stamp   = "<2021-09-09 Thu>--<2021-09-10 Fri +2d>"
                Start   = (Get-Date "2021-09-09")
                End     = (Get-Date "2021-09-10")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 2
                    Unit  = [OrgTimeUnit]::day
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }

            }
            @{
                Type    = "Date and repeat on the right - Inactive"
                Stamp   = "[2021-09-08 Wed]--[2021-09-11 Sat +5d]"
                Start   = (Get-Date "2021-09-08")
                End     = (Get-Date "2021-09-11")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 5
                    Unit  = [OrgTimeUnit]::day
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }

            }
            @{
                Type    = "Date and repeat on the left - Active"
                Stamp   = "<2021-09-09 Thu +2d>--<2021-09-10 Fri>"
                Start   = (Get-Date "2021-09-09")
                End     = (Get-Date "2021-09-10")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 2
                    Unit  = [OrgTimeUnit]::day
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }

            }
            @{
                Type    = "Date and repeat on the left - Inactive"
                Stamp   = "[2021-09-08 Wed +5d]--[2021-09-11 Sat]"
                Start   = (Get-Date "2021-09-08")
                End     = (Get-Date "2021-09-11")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 5
                    Unit  = [OrgTimeUnit]::day
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }

            }
            @{
                Type    = "Date and repeat on the both - Active"
                Stamp   = "<2021-09-09 Thu +2d>--<2021-09-10 Fri +5y>"
                Start   = (Get-Date "2021-09-09")
                End     = (Get-Date "2021-09-10")
                Active  = $true
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 5
                    Unit  = [OrgTimeUnit]::year
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }
            }
            @{
                Type    = "Date and repeat on the both - Inactive"
                Stamp   = "[2021-09-08 Wed +5d]--[2021-09-11 Sat +1d]"
                Start   = (Get-Date "2021-09-08")
                End     = (Get-Date "2021-09-11")
                Active  = $false
                Repeat  = @{
                    Type  = [OrgRepeatType]::cumulate
                    Value = 1
                    Unit  = [OrgTimeUnit]::day
                }
                Warning = @{
                    Type  = [OrgWarningType]::none
                    Value = 0
                    Unit  = [OrgTimeUnit]::none
                }

            }
        ) {
            BeforeAll {
                $d = $Stamp | ConvertFrom-OrgTimeStamp
            }
            It "Sets the start date to '<Start>' using '<Stamp>'" {
                $d.Start | Should -Be $Start
            }
            It "Sets the end date to '<End>' using '<Stamp>'" {
                $d.End | Should -Be $End
            }
            It "Sets the active state to <Active> using '<Stamp>'" {
                $d.Active | Should -Be $Active
            }
            It "Sets the recurrence to '<Repeat.Type>-<Repeat.Value> <Repeat.Unit>' using '<Stamp>'" {
                $d.Repeat.Type | Should -Be $Repeat.Type
                $d.Repeat.Value | Should -Be $Repeat.Value
                $d.Repeat.Unit | Should -Be $Repeat.Unit
            }
            It "Sets the warning to '<Warning.Type>-<Warning.Value> <Warning.Unit>' using '<Stamp>'" {
                $d.Warning.Type | Should -Be $Warning.Type
                $d.Warning.Value | Should -Be $Warning.Value
                $d.Warning.Unit | Should -Be $Warning.Unit
            }
        }
    }
}
