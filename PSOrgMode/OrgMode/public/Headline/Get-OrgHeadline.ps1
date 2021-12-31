
<#
.SYNOPSIS
    Get headlines from the given element
#>
Function Get-OrgHeadline {
    [CmdletBinding()]
    param(
                # The container to retrieve elements from
                [Parameter(
                    Mandatory = $true,
                    ValueFromPipeline = $true
                )]
                [OrgElement]
                $From,

                # Fields and values to filter Elements by
                # Expects a HashTable of 'Field = ValueFilter' to build the return
                # elements list:
                #
                # -Filter @{'State' = 'TODO'} -Type "headline"
                # -Filter @{'Property' = @{'CATEGORY' = 'Garden'}}
                # -Filter @{'Property' = @{'CATEGORY' = 'Garden'; 'Location' = 'Georgia'}}
                [Parameter(
                    Mandatory = $false,
                    ValueFromPipeline = $true
                )]
                [HashTable]
                $Filter,

                # Recurse into elements.
                [Parameter(
                    Mandatory = $false,
                    ValueFromPipeline = $false,
                    ParameterSetName = 'Recursion'
                )]
                [switch]
                $Recurse,

                # If recursion is specified, limit the levels to recurse into
                # defaults to 8.
                [Parameter(
                    Mandatory = $false,
                    ValueFromPipeline = $false,
                    ParameterSetName = 'Recursion'
                )]
                [Int]
                $Depth
    )

    Get-OrgElement @PSBoundParameters -Type headline

}
