
BeforeAll {
    # enums
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    # functions
    . "$($Source.Path)\Parser\private\RegexPatterns\Build-OrgHeadlineRegex.ps1"
    . "$($Source.Path)\Parser\private\RegexPatterns\Build-OrgPlainTextRegex.ps1"
    . "$($Source.Path)\Parser\private\RegexPatterns\Build-OrgTimeStampRegex.ps1"
    . "$($Source.Path)\Parser\private\Get-OrgModeRegexPattern.ps1"
}
Describe "Testing private Parser function Get-OrgModeRegexPattern" -Tags @('unit', 'OrgModeRegexPattern', 'Get' ) {
    Context "When <Type> is set <Object> is returned" -Foreach @(
        @{ Type = 'headline'; Object = 'OrgMode.Type.Regex.Headline' },
        @{ Type = 'timestamp'; Object = 'OrgMode.Type.Regex.TimeStamp' }
        @{ Type = 'plaintext'; Object = 'OrgMode.Type.Regex.PlainText' }
    ) {
        It "Returns the correct type" {
            $r = Get-OrgModeRegexPattern -Type $Type
            $r.psobject.Typenames[0] | Should -Be $Object
        }
    }
}
