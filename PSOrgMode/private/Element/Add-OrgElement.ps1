
Function Add-OrgElement {
<#
.SYNOPSIS
    Add a Child Item to an OrgElement
#>
    [CmdletBinding()]
    param(
        # Child object to add
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [OrgElement]
        $Child,

        # Element to add to
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [Alias('To')]
        [OrgElement]
        $Parent,

        # Optionally return the Child element to
        # the pipeline
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [switch]
        $PassThru
    )
    # make sure we set up bidirectional relationship
    # or fail out
    begin {}
    process {
        try {
            $Parent.Children.Add($Child) | Out-Null
            $Child.addParent($Parent)

            Write-Debug "Parent set to : $($Child.Parent.Type)"
        }
        catch {
            Write-Error "Unable to add the $($Child.Type) to $($Parent.Type)`n$_"
        }
    }
    end {
        if ($PassThru) { $Child }
    }
}
