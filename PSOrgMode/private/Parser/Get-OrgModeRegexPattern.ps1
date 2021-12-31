
<#
.SYNOPSIS
    Return `OrgMode.Type.Regex` objects.
.DESCRIPTION
    An object of type `OrgMode.Type.Regex.*` is a collection of regular
    expression strings used to identify, parse and validate OrgMode syntax.

    When no Type is specified, `Get-OrgModeRegexPattern` returns a collection
    of all objects listed in the internal `TypeMap` variable.

    Any pattern can be "wrapped" in anchors ('^\s*' and '\s*$'), by calling the
    .withAnchors(<string to be wrapped>)
.EXAMPLE
    PS C:\> $regex = Get-OrgModeRegexPattern -Type timestamp
    PS C:\> $regex.date
    \d{4}-\d{2}-\d{2}\s+\w{3}
.EXAMPLE
     PS C:\> $regex.withAnchors($regex.date)
    ^\s*\d{4}-\d{2}-\d{2}\s+\w{3}\s*$
#>

Function Get-OrgModeRegexPattern {
    [OutputType('OrgMode.Type.Regex.Collection')]
    [CmdletBinding()]
    param(
        # Optionally, return the regex pattern for an OrgType
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true
        )]
        [OrgType]
        $Type
    )

    begin {
        $TypeMap = @{
            'plaintext' = 'Build-OrgPlainTextRegex'
            'timestamp' = 'Build-OrgTimeStampRegex'
            'headline'  = 'Build-OrgHeadlineRegex'
        }
    }

    process {
        if ($PSBoundParameters['Type']) {
            if ($TypeMap.ContainsKey("$Type")) {
                $regex = Invoke-Expression -Command $TypeMap["$Type"]
            } else {
                Write-Error "$Type type not mapped"
            }
        } else {
            $regex = [PSCustomObject]@{
                PSTypeName = 'OrgMode.Type.Regex.Collection'
            }
            foreach ($k in $TypeMap.Keys) {
                Write-Debug ("{0} calling -> {1}" -f $k, $TypeMap["$k"])
                $o = Invoke-Expression -Command $TypeMap["$k"]
                $regex | Add-Member $k -MemberType NoteProperty -Value $o
            }
        }
    }
    end {
        $regex | Add-Member -MemberType ScriptMethod -Name 'withAnchors' -Value {
            ('^\s*', $args[0], '\s*$') -join ''
        }
        $regex
    }

}
