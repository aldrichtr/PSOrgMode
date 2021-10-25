
<#
.SYNOPSIS
    Return an `OrgMode.Type.Regex.PlainText` object with regex patterns as named
    NoteProperties.
#>
Function Build-OrgPlainTextRegex {
    [CmdletBinding()]
    param()
    begin {}
    process {
        $ts = [PSCustomObject]@{
            PSTypeName = 'OrgMode.Type.Regex.PlainText'
            blank_line = ''
        }
    }
    end {
        $ts
    }
}
