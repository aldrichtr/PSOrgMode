
InModuleScope -ModuleName PSOrgMode -ScriptBlock {
    Describe "Get-OrgModeRegexPattern function" -Tag "unit", "Get", "OrgModeRegexPattern" {
        Context "When <Type> is set <Object> is returned" -Foreach @(
            @{ Type = 'headline'; Object = 'OrgMode.Type.Regex.Headline' },
            @{ Type = 'timestamp'; Object = 'OrgMode.Type.Regex.TimeStamp' }
        ) {
            It "Returns the correct type" {
                $r = Get-OrgModeRegexPattern -Type $Type
                $r.psobject.Typenames[0] | Should -Be $Object
            }
        }
    }
}
