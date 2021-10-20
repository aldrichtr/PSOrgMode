
Function New-OrgProperty {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [string]
        $Name,

        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true
        )]
        [string[]]
        $Value
    )
    begin {
        $p = [OrgProperty]::new()
    }

    process {
        $p.Name = $Name
        if ($PSBoundParameters['Value']) {
            if ($Value.Count -eq 1) {
                $p.Value = [regex]::Split( $Value, ' (?=(?:[^"]|"[^"]*")*$)')
            }
        }
    }
    end {
        $p
    }
}
