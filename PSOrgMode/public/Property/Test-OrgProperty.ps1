<#
.SYNOPSIS
    Validate whether the given Element has the given Property
.DESCRIPTION
    If no value is provided, `Test-OrgProperty` validates the property
    exists, if the value is provided, `Test-OrgProperty` validates that the
    property is the value requested.
#>

Function Test-OrgProperty {
    [CmdletBinding()]
    param(
        # The parameter to test
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
        $Element,

        # Optionally, provide a value to look for in the property
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [string]
        $Value
    )
    begin {
        $isFound = $false

    }
    process {
        $p = $Element.Properties.Where( {$_.Name -eq $Name})
        if ($p) {
            Write-Debug "$Name was found in .Where() search"
            if ($PSBoundParameters['Value']) {
                Write-Debug "Looking for the property to have Value: $Value"
                if ($p.Value -contains $Value) {
                    Write-Debug "Property contained $Value"
                    $isFound = $true
                } else {
                    Write-Debug "Property did not contain $Value"
                    $isFound = $false
                }
            } else {
                Write-Debug "Not looking for a value."
                $isFound = $true
            }
        } else {
            Write-Debug "$Name was not found in .Where() search"
            $isFound = $false
        }
    }
    end {
        $isFound
    }
}
