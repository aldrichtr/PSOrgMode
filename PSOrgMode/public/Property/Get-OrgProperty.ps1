<#
.SYNOPSIS
    Gets the Value of the Property requested
#>

Function Get-OrgProperty {
    [CmdletBinding()]
    param(
        # The property to get
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [string]
        $Name,

        # the Element to test for the property
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [OrgElement]
        $Element

    )
    begin { }
    process {
        $p = $Element.Properties.Where( { $_.Name -eq $Name })
        if ($p) {
            Write-Debug "$Name was found in .Where() search"
            if ($null -eq $p.Value) {
                $val = $true
            } else {
                $val = $p.Value
            }
        } else {
            Write-Debug "$Name was not found in .Where() search"
        }
    }
    end {
        $val
    }
}
