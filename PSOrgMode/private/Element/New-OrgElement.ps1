

<#
.SYNOPSIS
    Return an OrgElement of the specified type
#>
Function New-OrgElement {
    [CmdletBinding()]
    param(
        # The Element Type to create, default is 'orgdata'
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true
        )]
        [OrgType]
        $Type = [OrgType]::orgdata
    )
    begin {
        Write-Debug "In $($PSCmdlet.MyInvocation.MyCommand.Name)`n$('-' * 78)"
    }
    process {
        Write-Debug "Creating new $Type"
        switch ($Type) {
            headline {
                $e = [OrgHeadline]::new()
                continue
            }
            Default {$e = [OrgElement]::new(); $e.Type = $Type }
        }
    }
    end {
        Write-Debug "End $($PSCmdlet.MyInvocation.MyCommand.Name)`n$('-' * 78)"
        $e
    }
}
