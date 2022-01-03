
<#
.SYNOPSIS
    Return an `OrgMode.Type.Regex.Headline` object with regex patterns as named
    NoteProperties.
#>
Function Build-OrgHeadlineRegex {
    [CmdletBinding()]
    param()
    begin {}
    process {
        $ts = [PSCustomObject]@{
            PSTypeName = 'OrgMode.Type.Regex.Headline'
            line       = '\*+\s+.*'
            state      = '[A-Z]{4,}' #case sensitive!
            priority   = '\[\#\w\]'
            track      = '\[\d+/\d+\]'
            tags       = '\:(\w+\:)+'
        }
    }
    end {
        $ts
    }
}
