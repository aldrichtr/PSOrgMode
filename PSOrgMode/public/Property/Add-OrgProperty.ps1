
Function Add-OrgProperty {
    <#
.SYNOPSIS

#>
[CmdletBinding(DefaultParameterSetName = 'Object')]
param(
        # The org element to add the property to
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [OrgElement]
        $Element,

        # The OrgProperty object to add
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'Object',
            Position = 0
        )]
        [OrgProperty]
        $Property,

        # The name of the parameter to add
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'Text'
        )]
        [string]
        $Name,

        # The value(s) of the parameter.  To set values with spaces in them,
        # surround them in quotes, like:
        # Add-OrgProperty -Name 'Contacts' -Value "Jim", "Bob", "Norma Jean"
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ParameterSetName = 'Text'
        )]
        [string[]]
        $Value,


        # If the Element already has a property with the given name,
        # `Add-OrgProperty` will give an error.
        # Use -Force to overwrite the property.
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [switch]
        $Force,

        # Optionally return the Element
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [switch]
        $PassThru
    )

    begin {
        if ($PSBoundParameters['Name']) {
            $p = New-OrgProperty -Name $Name
            if ($PSBoundParameters['Value']) {
                $p.Value = $Value
            }
        } elseif ( $PSBoundParameters['Property']) {
            $p = $Property
        }
    }

    process {
        if ($Element | Test-OrgProperty -Name $p.Name ) {
            if ($Force) {
                # A bit long and nested, but find the property and remove it
                #
                $Element.Properties.Remove( $Element.Properties.Where({ $_.Name -eq $p.Name }))
            } else {
                throw "$($p.Name) already exists.  use -Force to overwrite"
            }
        }
        $Element.Properties.Add($p) | Out-Null
    }

    end {
        if ($PassThru) { $Element }
     }
}
