

<#
.SYNOPSIS
    Return an OrgElement of the specified type
#>
Function New-OrgElement {
    [CmdletBinding()]
    param(
        # The Element Type to create, default is 'orgdata'
        [Parameter(
            ValueFromPipeline
        )]
        [OrgType]
        $Type = [OrgType]::orgdata
    )
    begin {
    }
    process {
        switch ($Type) {
            headline {
                $e = [OrgHeadline]::new()
                continue
            }
            Default {$e = [OrgElement]::new(); $e.Type = $Type }
        }
    }
    end {
        $e
    }
}
