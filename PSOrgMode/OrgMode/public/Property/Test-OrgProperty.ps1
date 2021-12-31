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
            if ($PSBoundParameters['Value']) {
                if ($p.Value -contains $Value) {
                    $isFound = $true
                } else {
                    $isFound = $false
                }
            } else {
                $isFound = $true
            }
        } else {
            $isFound = $false
        }
    }
    end {
        $isFound
    }
}
